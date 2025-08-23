import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/question.dart';
import 'dart:convert' show utf8;
import 'package:drift/drift.dart' as drift;

part 'match_data.freezed.dart';

@freezed
abstract class MatchData
    with _$MatchData
    implements drift.Insertable<MatchData> {
  const MatchData._();

  const factory MatchData({
    required String gameFormatName,
    required DateTime date,
    required int teamNumber,
    required int matchNumber,
    required String scoutName,
    required Map<String, dynamic> data,
  }) = _MatchDataModel;

  factory MatchData.fromMap(Map<String, dynamic> data) {
    assert(data["gameFormatName"].runtimeType == String);
    assert(data["dateTime"].runtimeType == DateTime);
    assert(data["teamNumber"].runtimeType == int);
    assert(data["matchNumber"].runtimeType == int);
    assert(data["scoutName"].runtimeType == String);

    return MatchData(
      // Remove time information to get just local date
      date: (data["dateTime"]! as DateTime).toLocal().copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      teamNumber: data["teamNumber"]!,
      matchNumber: data["matchNumber"]!,
      gameFormatName: data["gameFormatName"]!,
      scoutName: data["scoutName"]!,
      data: data,
    );
  }

  Uint8List toBin() {
    final writer = ByteDataWriter();
    writer.write(utf8.encode(gameFormatName.padRight(8, ' ')));
    writer.writeUint64(data["dateTime"].millisecondsSinceEpoch);
    writer.writeUint16(teamNumber);
    writer.writeUint8(matchNumber);
    writer.write(utf8.encode(scoutName.padRight(30, ' ')));

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
          String text =
              data[question.key]?.toString() ??
              ''.padRight((question as QuestionText).length, '0');
          writer.writeUint8(text.length);
          writer.write(utf8.encode(text));
          break;
      }
    }

    return writer.toBytes();
  }

  factory MatchData.fromBin(Uint8List bytes) {
    final reader = ByteDataReader();
    reader.add(bytes);

    final data = <String, dynamic>{};

    data["gameFormatName"] = String.fromCharCodes(reader.read(8)).trim();
    data["dateTime"] = DateTime.fromMillisecondsSinceEpoch(reader.readUint8());
    data["teamNumber"] = reader.readUint16();
    data["matchNumber"] = reader.readUint8();
    data["scoutName"] = utf8.decode(reader.read(30)).trim();

    final GameFormat gameFormat = kSupportedGameFormats.firstWhere(
      (format) => format.name == data["gameFormatName"],
      orElse:
          () =>
              throw Exception(
                "Unsupported game format: ${data["gameFormatName"]}",
              ),
    );

    for (var question in gameFormat.questions) {
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
          data[question.key] = String.fromCharCodes(reader.read(length)).trim();
          break;
      }
    }

    return MatchData.fromMap(data);
  }

  factory MatchData.fromDb({
    required String gameFormatName,
    required DateTime date,
    required int teamNumber,
    required int matchNumber,
    required String scoutName,
    required Uint8List data,
  }) {
    return MatchData.fromBin(data);
  }

  @override
  Map<String, drift.Expression<Object>> toColumns(bool nullToAbsent) {
    return MatchDataTableCompanion(
      gameFormatName: drift.Value<String>(gameFormatName),
      date: drift.Value<DateTime>(date),
      teamNumber: drift.Value<int>(teamNumber),
      matchNumber: drift.Value<int>(matchNumber),
      scoutName: drift.Value<String>(scoutName),
      data: drift.Value<Uint8List>(toBin()),
    ).toColumns(nullToAbsent);
  }
}
