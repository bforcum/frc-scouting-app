import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/question.dart';
import 'dart:convert' show utf8;
import 'package:drift/drift.dart' as drift;

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
    required String gameFormatName,
    required Map<String, dynamic> data,
  }) = _MatchResultModel;

  factory MatchResult.fromMap(Map<String, dynamic> data) {
    assert(data["eventName"].runtimeType == String);
    assert(data["teamNumber"].runtimeType == int);
    assert(data["matchNumber"].runtimeType == int);
    assert(data["timeStamp"].runtimeType == DateTime);
    assert(data["scoutName"].runtimeType == String);
    assert(data["gameFormatName"].runtimeType == String);

    return MatchResult(
      eventName: data["eventName"],
      teamNumber: data["teamNumber"]!,
      matchNumber: data["matchNumber"]!,
      timeStamp: data["timeStamp"]!,
      scoutName: data["scoutName"]!,
      gameFormatName: data["gameFormatName"]!,
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
    writer.write(utf8.encode(gameFormatName.padRight(8)));

    final GameFormat gameFormat = kSupportedGameFormats.firstWhere(
      (format) => format.name == gameFormatName,
      orElse: () => throw Exception("Unsupported game format: $gameFormatName"),
    );

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

  factory MatchResult.fromBin(Uint8List bytes) {
    final reader = ByteDataReader();
    reader.add(bytes);

    final data = <String, dynamic>{};

    data["eventName"] = utf8.decode(reader.read(12)).trim();
    data["teamNumber"] = reader.readUint16();
    data["matchNumber"] = reader.readUint8();
    data["timeStamp"] = DateTime.fromMillisecondsSinceEpoch(
      reader.readUint64(),
    );
    final int nameLength = reader.readUint8();
    data["scoutName"] = utf8.decode(reader.read(nameLength)).trim();
    data["gameFormatName"] = String.fromCharCodes(reader.read(8)).trim();

    final GameFormat? gameFormat = kSupportedGameFormats.firstWhereOrNull(
      (format) => format.name == data["gameFormatName"],
    );
    if (gameFormat == null) {
      return MatchResult.fromMap(data);
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

    return MatchResult.fromMap(data);
  }

  factory MatchResult.fromDb({
    required String eventName,
    required int teamNumber,
    required int matchNumber,
    required BigInt timeStamp,
    required String scoutName,
    required String gameFormatName,
    required Uint8List data,
  }) {
    return MatchResult.fromBin(data);
  }

  @override
  Map<String, drift.Expression<Object>> toColumns(bool nullToAbsent) {
    return MatchResultsCompanion(
      eventName: drift.Value<String>(eventName),
      teamNumber: drift.Value<int>(teamNumber),
      matchNumber: drift.Value<int>(matchNumber),
      timeStamp: drift.Value<BigInt>(
        BigInt.from(timeStamp.millisecondsSinceEpoch),
      ),
      scoutName: drift.Value<String>(scoutName),
      gameFormatName: drift.Value<String>(gameFormatName),
      data: drift.Value<Uint8List>(toBin()),
    ).toColumns(nullToAbsent);
  }

  int getAutoScore() {
    GameFormat? format = kSupportedGameFormats.firstWhereOrNull(
      (format) => format.name == gameFormatName,
    );
    if (format == null) {
      return 0;
    }
    return format.autoScore(this);
  }

  int getTeleScore() {
    GameFormat? format = kSupportedGameFormats.firstWhereOrNull(
      (format) => format.name == gameFormatName,
    );
    if (format == null) {
      return 0;
    }
    return format.teleScore(this);
  }

  int getEndScore() {
    GameFormat? format = kSupportedGameFormats.firstWhereOrNull(
      (format) => format.name == gameFormatName,
    );
    if (format == null) {
      return 0;
    }
    return format.endScore(this);
  }

  int getTotalScore() {
    return getAutoScore() + getTeleScore() + getEndScore();
  }
}
