import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/analysis/match_analysis.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/question.dart';
import 'dart:convert' show utf8;
import 'package:drift/drift.dart' as drift;
import 'package:statistics/statistics.dart';

part 'match_result.freezed.dart';

@freezed
abstract class MatchResult
    with _$MatchResult
    implements drift.Insertable<MatchResult> {
  const MatchResult._();

  const factory MatchResult({
    required String eventName,
    required int teamNumber,
    required int matchNumber,
    required DateTime timeStamp,
    required String scoutName,
    required GameFormat gameFormat,
    required Map<String, dynamic> data,
  }) = _MatchResultModel;

  factory MatchResult.fromMap(Map<String, dynamic> data) {
    assert(data["eventName"].runtimeType == String);
    assert(data["teamNumber"].runtimeType == int);
    assert(data["matchNumber"].runtimeType == int);
    assert(data["timeStamp"].runtimeType == DateTime);
    assert(data["scoutName"].runtimeType == String);
    assert(data["gameFormat"].runtimeType == GameFormat);

    return MatchResult(
      eventName: data["eventName"],
      teamNumber: data["teamNumber"]!,
      matchNumber: data["matchNumber"]!,
      timeStamp: data["timeStamp"]!,
      scoutName: data["scoutName"]!,
      gameFormat: data["gameFormat"],
      data: data,
    );
  }

  Uint8List toBin() {
    final writer = ByteDataWriter();
    writer.write(utf8.encode(eventName.padRight(12)));
    writer.writeUint16(teamNumber);
    writer.writeUint8(matchNumber);
    writer.writeUint64(timeStamp.millisecondsSinceEpoch);
    writer.writeUint8(scoutName.length);
    writer.write(utf8.encode(scoutName));
    writer.write(utf8.encode(gameFormat.name.padRight(8)));

    for (var question in gameFormat.questions) {
      switch (question.type) {
        case QuestionType.counter:
          writer.writeUint8(data[question.key] ?? 0);
          break;
        case QuestionType.toggle:
          writer.writeUint8(data[question.key] == true ? 1 : 0);
          break;
        case QuestionType.number:
          writer.writeUint16(data[question.key] ?? 0);
          break;
        case QuestionType.dropdown:
          writer.writeUint8(data[question.key] ?? 0);
          break;
        case QuestionType.text:
          Uint8List text = utf8.encode(data[question.key]?.toString() ?? "");
          writer.writeUint8(text.length);
          writer.write(text);
          break;
      }
    }

    return writer.toBytes();
  }

  static MatchResult? fromBin(Uint8List bytes) {
    final reader = ByteDataReader();
    reader.add(bytes);

    final data = <String, dynamic>{};

    String eventName = utf8.decode(reader.read(12)).trim();
    int teamNumber = reader.readUint16();
    int matchNumber = reader.readUint8();
    DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(
      reader.readUint64(),
    );
    final int nameLength = reader.readUint8();
    String scoutName = utf8.decode(reader.read(nameLength)).trim();
    String gameFormatName = String.fromCharCodes(reader.read(8)).trim();

    final GameFormat? gameFormat = GameFormat.values.firstWhereOrNull(
      (format) => format.name == gameFormatName,
    );
    if (gameFormat == null) {
      return null;
    }
    for (var question in gameFormat.questions) {
      try {
        switch (question.type) {
          case QuestionType.counter:
            data[question.key] = reader.readUint8();
            break;
          case QuestionType.toggle:
            data[question.key] = reader.readUint8() > 0;
            break;
          case QuestionType.number:
            data[question.key] = reader.readUint16();
            break;
          case QuestionType.dropdown:
            data[question.key] = reader.readUint8();
            break;
          case QuestionType.text:
            int length = reader.readUint8();
            data[question.key] =
                String.fromCharCodes(reader.read(length)).trim();
            break;
        }
      } catch (e) {
        debugPrint(e.toString());
        continue;
      }
    }

    return MatchResult(
      eventName: eventName,
      teamNumber: teamNumber,
      matchNumber: matchNumber,
      timeStamp: timeStamp,
      scoutName: scoutName,
      gameFormat: gameFormat,
      data: data,
    );
  }

  factory MatchResult.fromExcel(List<Data> values, GameFormat gameFormat) {
    final data = <String, dynamic>{};

    String eventName = values[0].value.toString();
    int teamNumber = (values[1].value as IntCellValue).value;
    int matchNumber = (values[2].value as IntCellValue).value;
    DateTime timeStamp = (values[3].value as DateTimeCellValue).asDateTimeUtc();
    String scoutName = values[4].value.toString();

    for (int i = 0; i < gameFormat.questions.length; i++) {
      Question question = gameFormat.questions[i];
      Data dataVal = values[i + 5];
      try {
        switch (question.type) {
          case QuestionType.counter:
          case QuestionType.number:
          case QuestionType.dropdown:
            data[question.key] = (dataVal.value as IntCellValue).value;
            break;
          case QuestionType.toggle:
            data[question.key] = (dataVal.value as BoolCellValue).value;
            break;
          case QuestionType.text:
            data[question.key] = (dataVal.value as TextCellValue).toString();
            break;
        }
      } catch (e) {
        debugPrint(e.toString());
        continue;
      }
    }

    return MatchResult(
      gameFormat: gameFormat,
      eventName: eventName,
      teamNumber: teamNumber,
      matchNumber: matchNumber,
      timeStamp: timeStamp,
      scoutName: scoutName,
      data: data,
    );
  }

  List<CellValue> toExcel({bool withEvent = true}) {
    List<CellValue> row = List.empty(growable: true);

    if (withEvent) row.add(TextCellValue(eventName));
    row.add(IntCellValue(teamNumber));
    row.add(IntCellValue(matchNumber));
    row.add(DateTimeCellValue.fromDateTime(timeStamp));
    row.add(TextCellValue(scoutName));

    for (var question in gameFormat.questions) {
      switch (question.type) {
        case QuestionType.counter:
        case QuestionType.number:
        case QuestionType.dropdown:
          row.add(IntCellValue(data[question.key]));
          break;
        case QuestionType.toggle:
          row.add(BoolCellValue(data[question.key]));
        case QuestionType.text:
          row.add(TextCellValue(data[question.key]));
          break;
      }
    }
    return row;
  }

  factory MatchResult.fromDb({
    required BigInt uuid,
    required String eventName,
    required int teamNumber,
    required int matchNumber,
    required BigInt timeStamp,
    required String scoutName,
    required String gameFormatName,
    required Uint8List data,
  }) {
    return MatchResult.fromBin(data)!;
  }

  @override
  Map<String, drift.Expression<Object>> toColumns(bool nullToAbsent) {
    return MatchResultsCompanion(
      uuid: drift.Value<BigInt>(id),
      eventName: drift.Value<String>(eventName),
      teamNumber: drift.Value<int>(teamNumber),
      matchNumber: drift.Value<int>(matchNumber),
      timeStamp: drift.Value<BigInt>(
        BigInt.from(timeStamp.millisecondsSinceEpoch),
      ),
      scoutName: drift.Value<String>(scoutName),
      gameFormatName: drift.Value<String>(gameFormat.name),
      data: drift.Value<Uint8List>(toBin()),
    ).toColumns(nullToAbsent);
  }

  BigInt get id {
    int uuid = (timeStamp.year - 2000) << (7 * 8);
    List<int> eventBytes =
        eventName.toUpperCase().padRight(5, '\x40').encodeUTF8();
    int eventCode = 0;
    for (int i = 0; i < 5; i++) {
      eventCode *= 26;
      eventCode += eventBytes[i] - 0x40;
    }
    uuid |= eventCode << 24;
    uuid |= teamNumber << 8;
    uuid |= matchNumber;
    return uuid.toBigInt();
  }

  MatchAnalysis? get analysis => gameFormat.analysis(this);
}
