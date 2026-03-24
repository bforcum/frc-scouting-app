// dart format width=80
import 'dart:typed_data' as i2;
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Teams extends Table with TableInfo<Teams, TeamsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Teams(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> teamNumber = GeneratedColumn<int>(
    'team_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
    'event_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> gameFormat = GeneratedColumn<int>(
    'game_format',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> pickListPosition = GeneratedColumn<int>(
    'pick_list_position',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    teamNumber,
    eventCode,
    gameFormat,
    pickListPosition,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams';
  @override
  Set<GeneratedColumn> get $primaryKey => {teamNumber, eventCode, gameFormat};
  @override
  TeamsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamsData(
      teamNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}team_number'],
          )!,
      eventCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_code'],
          )!,
      gameFormat:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}game_format'],
          )!,
      pickListPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pick_list_position'],
      ),
    );
  }

  @override
  Teams createAlias(String alias) {
    return Teams(attachedDatabase, alias);
  }
}

class TeamsData extends DataClass implements Insertable<TeamsData> {
  final int teamNumber;
  final String eventCode;
  final int gameFormat;
  final int? pickListPosition;
  const TeamsData({
    required this.teamNumber,
    required this.eventCode,
    required this.gameFormat,
    this.pickListPosition,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['team_number'] = Variable<int>(teamNumber);
    map['event_code'] = Variable<String>(eventCode);
    map['game_format'] = Variable<int>(gameFormat);
    if (!nullToAbsent || pickListPosition != null) {
      map['pick_list_position'] = Variable<int>(pickListPosition);
    }
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(
      teamNumber: Value(teamNumber),
      eventCode: Value(eventCode),
      gameFormat: Value(gameFormat),
      pickListPosition:
          pickListPosition == null && nullToAbsent
              ? const Value.absent()
              : Value(pickListPosition),
    );
  }

  factory TeamsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamsData(
      teamNumber: serializer.fromJson<int>(json['teamNumber']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      gameFormat: serializer.fromJson<int>(json['gameFormat']),
      pickListPosition: serializer.fromJson<int?>(json['pickListPosition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'teamNumber': serializer.toJson<int>(teamNumber),
      'eventCode': serializer.toJson<String>(eventCode),
      'gameFormat': serializer.toJson<int>(gameFormat),
      'pickListPosition': serializer.toJson<int?>(pickListPosition),
    };
  }

  TeamsData copyWith({
    int? teamNumber,
    String? eventCode,
    int? gameFormat,
    Value<int?> pickListPosition = const Value.absent(),
  }) => TeamsData(
    teamNumber: teamNumber ?? this.teamNumber,
    eventCode: eventCode ?? this.eventCode,
    gameFormat: gameFormat ?? this.gameFormat,
    pickListPosition:
        pickListPosition.present
            ? pickListPosition.value
            : this.pickListPosition,
  );
  TeamsData copyWithCompanion(TeamsCompanion data) {
    return TeamsData(
      teamNumber:
          data.teamNumber.present ? data.teamNumber.value : this.teamNumber,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      gameFormat:
          data.gameFormat.present ? data.gameFormat.value : this.gameFormat,
      pickListPosition:
          data.pickListPosition.present
              ? data.pickListPosition.value
              : this.pickListPosition,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamsData(')
          ..write('teamNumber: $teamNumber, ')
          ..write('eventCode: $eventCode, ')
          ..write('gameFormat: $gameFormat, ')
          ..write('pickListPosition: $pickListPosition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(teamNumber, eventCode, gameFormat, pickListPosition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamsData &&
          other.teamNumber == this.teamNumber &&
          other.eventCode == this.eventCode &&
          other.gameFormat == this.gameFormat &&
          other.pickListPosition == this.pickListPosition);
}

class TeamsCompanion extends UpdateCompanion<TeamsData> {
  final Value<int> teamNumber;
  final Value<String> eventCode;
  final Value<int> gameFormat;
  final Value<int?> pickListPosition;
  final Value<int> rowid;
  const TeamsCompanion({
    this.teamNumber = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.gameFormat = const Value.absent(),
    this.pickListPosition = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeamsCompanion.insert({
    required int teamNumber,
    required String eventCode,
    required int gameFormat,
    this.pickListPosition = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : teamNumber = Value(teamNumber),
       eventCode = Value(eventCode),
       gameFormat = Value(gameFormat);
  static Insertable<TeamsData> custom({
    Expression<int>? teamNumber,
    Expression<String>? eventCode,
    Expression<int>? gameFormat,
    Expression<int>? pickListPosition,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (teamNumber != null) 'team_number': teamNumber,
      if (eventCode != null) 'event_code': eventCode,
      if (gameFormat != null) 'game_format': gameFormat,
      if (pickListPosition != null) 'pick_list_position': pickListPosition,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeamsCompanion copyWith({
    Value<int>? teamNumber,
    Value<String>? eventCode,
    Value<int>? gameFormat,
    Value<int?>? pickListPosition,
    Value<int>? rowid,
  }) {
    return TeamsCompanion(
      teamNumber: teamNumber ?? this.teamNumber,
      eventCode: eventCode ?? this.eventCode,
      gameFormat: gameFormat ?? this.gameFormat,
      pickListPosition: pickListPosition ?? this.pickListPosition,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (teamNumber.present) {
      map['team_number'] = Variable<int>(teamNumber.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (gameFormat.present) {
      map['game_format'] = Variable<int>(gameFormat.value);
    }
    if (pickListPosition.present) {
      map['pick_list_position'] = Variable<int>(pickListPosition.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsCompanion(')
          ..write('teamNumber: $teamNumber, ')
          ..write('eventCode: $eventCode, ')
          ..write('gameFormat: $gameFormat, ')
          ..write('pickListPosition: $pickListPosition, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MatchResults extends Table
    with TableInfo<MatchResults, MatchResultsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MatchResults(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<BigInt> uuid = GeneratedColumn<BigInt>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
    'event_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> teamNumber = GeneratedColumn<String>(
    'team_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> matchNumber = GeneratedColumn<int>(
    'match_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> timeStamp = GeneratedColumn<BigInt>(
    'time_stamp',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> scoutName = GeneratedColumn<String>(
    'scout_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> gameFormat = GeneratedColumn<int>(
    'game_format',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<i2.Uint8List> data = GeneratedColumn<i2.Uint8List>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    eventCode,
    teamNumber,
    matchNumber,
    timeStamp,
    scoutName,
    gameFormat,
    data,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'match_results';
  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  MatchResultsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchResultsData(
      uuid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bigInt,
            data['${effectivePrefix}uuid'],
          )!,
      eventCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_code'],
          )!,
      teamNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}team_number'],
          )!,
      matchNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}match_number'],
          )!,
      timeStamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bigInt,
            data['${effectivePrefix}time_stamp'],
          )!,
      scoutName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}scout_name'],
          )!,
      gameFormat:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}game_format'],
          )!,
      data:
          attachedDatabase.typeMapping.read(
            DriftSqlType.blob,
            data['${effectivePrefix}data'],
          )!,
    );
  }

  @override
  MatchResults createAlias(String alias) {
    return MatchResults(attachedDatabase, alias);
  }
}

class MatchResultsData extends DataClass
    implements Insertable<MatchResultsData> {
  final BigInt uuid;
  final String eventCode;
  final String teamNumber;
  final int matchNumber;
  final BigInt timeStamp;
  final String scoutName;
  final int gameFormat;
  final i2.Uint8List data;
  const MatchResultsData({
    required this.uuid,
    required this.eventCode,
    required this.teamNumber,
    required this.matchNumber,
    required this.timeStamp,
    required this.scoutName,
    required this.gameFormat,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<BigInt>(uuid);
    map['event_code'] = Variable<String>(eventCode);
    map['team_number'] = Variable<String>(teamNumber);
    map['match_number'] = Variable<int>(matchNumber);
    map['time_stamp'] = Variable<BigInt>(timeStamp);
    map['scout_name'] = Variable<String>(scoutName);
    map['game_format'] = Variable<int>(gameFormat);
    map['data'] = Variable<i2.Uint8List>(data);
    return map;
  }

  MatchResultsCompanion toCompanion(bool nullToAbsent) {
    return MatchResultsCompanion(
      uuid: Value(uuid),
      eventCode: Value(eventCode),
      teamNumber: Value(teamNumber),
      matchNumber: Value(matchNumber),
      timeStamp: Value(timeStamp),
      scoutName: Value(scoutName),
      gameFormat: Value(gameFormat),
      data: Value(data),
    );
  }

  factory MatchResultsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchResultsData(
      uuid: serializer.fromJson<BigInt>(json['uuid']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      teamNumber: serializer.fromJson<String>(json['teamNumber']),
      matchNumber: serializer.fromJson<int>(json['matchNumber']),
      timeStamp: serializer.fromJson<BigInt>(json['timeStamp']),
      scoutName: serializer.fromJson<String>(json['scoutName']),
      gameFormat: serializer.fromJson<int>(json['gameFormat']),
      data: serializer.fromJson<i2.Uint8List>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<BigInt>(uuid),
      'eventCode': serializer.toJson<String>(eventCode),
      'teamNumber': serializer.toJson<String>(teamNumber),
      'matchNumber': serializer.toJson<int>(matchNumber),
      'timeStamp': serializer.toJson<BigInt>(timeStamp),
      'scoutName': serializer.toJson<String>(scoutName),
      'gameFormat': serializer.toJson<int>(gameFormat),
      'data': serializer.toJson<i2.Uint8List>(data),
    };
  }

  MatchResultsData copyWith({
    BigInt? uuid,
    String? eventCode,
    String? teamNumber,
    int? matchNumber,
    BigInt? timeStamp,
    String? scoutName,
    int? gameFormat,
    i2.Uint8List? data,
  }) => MatchResultsData(
    uuid: uuid ?? this.uuid,
    eventCode: eventCode ?? this.eventCode,
    teamNumber: teamNumber ?? this.teamNumber,
    matchNumber: matchNumber ?? this.matchNumber,
    timeStamp: timeStamp ?? this.timeStamp,
    scoutName: scoutName ?? this.scoutName,
    gameFormat: gameFormat ?? this.gameFormat,
    data: data ?? this.data,
  );
  MatchResultsData copyWithCompanion(MatchResultsCompanion data) {
    return MatchResultsData(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      teamNumber:
          data.teamNumber.present ? data.teamNumber.value : this.teamNumber,
      matchNumber:
          data.matchNumber.present ? data.matchNumber.value : this.matchNumber,
      timeStamp: data.timeStamp.present ? data.timeStamp.value : this.timeStamp,
      scoutName: data.scoutName.present ? data.scoutName.value : this.scoutName,
      gameFormat:
          data.gameFormat.present ? data.gameFormat.value : this.gameFormat,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchResultsData(')
          ..write('uuid: $uuid, ')
          ..write('eventCode: $eventCode, ')
          ..write('teamNumber: $teamNumber, ')
          ..write('matchNumber: $matchNumber, ')
          ..write('timeStamp: $timeStamp, ')
          ..write('scoutName: $scoutName, ')
          ..write('gameFormat: $gameFormat, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    eventCode,
    teamNumber,
    matchNumber,
    timeStamp,
    scoutName,
    gameFormat,
    $driftBlobEquality.hash(data),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchResultsData &&
          other.uuid == this.uuid &&
          other.eventCode == this.eventCode &&
          other.teamNumber == this.teamNumber &&
          other.matchNumber == this.matchNumber &&
          other.timeStamp == this.timeStamp &&
          other.scoutName == this.scoutName &&
          other.gameFormat == this.gameFormat &&
          $driftBlobEquality.equals(other.data, this.data));
}

class MatchResultsCompanion extends UpdateCompanion<MatchResultsData> {
  final Value<BigInt> uuid;
  final Value<String> eventCode;
  final Value<String> teamNumber;
  final Value<int> matchNumber;
  final Value<BigInt> timeStamp;
  final Value<String> scoutName;
  final Value<int> gameFormat;
  final Value<i2.Uint8List> data;
  const MatchResultsCompanion({
    this.uuid = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.teamNumber = const Value.absent(),
    this.matchNumber = const Value.absent(),
    this.timeStamp = const Value.absent(),
    this.scoutName = const Value.absent(),
    this.gameFormat = const Value.absent(),
    this.data = const Value.absent(),
  });
  MatchResultsCompanion.insert({
    this.uuid = const Value.absent(),
    required String eventCode,
    required String teamNumber,
    required int matchNumber,
    required BigInt timeStamp,
    required String scoutName,
    required int gameFormat,
    required i2.Uint8List data,
  }) : eventCode = Value(eventCode),
       teamNumber = Value(teamNumber),
       matchNumber = Value(matchNumber),
       timeStamp = Value(timeStamp),
       scoutName = Value(scoutName),
       gameFormat = Value(gameFormat),
       data = Value(data);
  static Insertable<MatchResultsData> custom({
    Expression<BigInt>? uuid,
    Expression<String>? eventCode,
    Expression<String>? teamNumber,
    Expression<int>? matchNumber,
    Expression<BigInt>? timeStamp,
    Expression<String>? scoutName,
    Expression<int>? gameFormat,
    Expression<i2.Uint8List>? data,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (eventCode != null) 'event_code': eventCode,
      if (teamNumber != null) 'team_number': teamNumber,
      if (matchNumber != null) 'match_number': matchNumber,
      if (timeStamp != null) 'time_stamp': timeStamp,
      if (scoutName != null) 'scout_name': scoutName,
      if (gameFormat != null) 'game_format': gameFormat,
      if (data != null) 'data': data,
    });
  }

  MatchResultsCompanion copyWith({
    Value<BigInt>? uuid,
    Value<String>? eventCode,
    Value<String>? teamNumber,
    Value<int>? matchNumber,
    Value<BigInt>? timeStamp,
    Value<String>? scoutName,
    Value<int>? gameFormat,
    Value<i2.Uint8List>? data,
  }) {
    return MatchResultsCompanion(
      uuid: uuid ?? this.uuid,
      eventCode: eventCode ?? this.eventCode,
      teamNumber: teamNumber ?? this.teamNumber,
      matchNumber: matchNumber ?? this.matchNumber,
      timeStamp: timeStamp ?? this.timeStamp,
      scoutName: scoutName ?? this.scoutName,
      gameFormat: gameFormat ?? this.gameFormat,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<BigInt>(uuid.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (teamNumber.present) {
      map['team_number'] = Variable<String>(teamNumber.value);
    }
    if (matchNumber.present) {
      map['match_number'] = Variable<int>(matchNumber.value);
    }
    if (timeStamp.present) {
      map['time_stamp'] = Variable<BigInt>(timeStamp.value);
    }
    if (scoutName.present) {
      map['scout_name'] = Variable<String>(scoutName.value);
    }
    if (gameFormat.present) {
      map['game_format'] = Variable<int>(gameFormat.value);
    }
    if (data.present) {
      map['data'] = Variable<i2.Uint8List>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchResultsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('eventCode: $eventCode, ')
          ..write('teamNumber: $teamNumber, ')
          ..write('matchNumber: $matchNumber, ')
          ..write('timeStamp: $timeStamp, ')
          ..write('scoutName: $scoutName, ')
          ..write('gameFormat: $gameFormat, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class PitScouting extends Table with TableInfo<PitScouting, PitScoutingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PitScouting(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> teamNumber = GeneratedColumn<int>(
    'team_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
    'event_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> gameFormat = GeneratedColumn<int>(
    'game_format',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> timeStamp = GeneratedColumn<BigInt>(
    'time_stamp',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> scoutName = GeneratedColumn<String>(
    'scout_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<i2.Uint8List> data = GeneratedColumn<i2.Uint8List>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    teamNumber,
    eventCode,
    gameFormat,
    timeStamp,
    scoutName,
    data,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pit_scouting';
  @override
  Set<GeneratedColumn> get $primaryKey => {teamNumber, eventCode, gameFormat};
  @override
  PitScoutingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PitScoutingData(
      teamNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}team_number'],
          )!,
      eventCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_code'],
          )!,
      gameFormat:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}game_format'],
          )!,
      timeStamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bigInt,
            data['${effectivePrefix}time_stamp'],
          )!,
      scoutName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}scout_name'],
          )!,
      data:
          attachedDatabase.typeMapping.read(
            DriftSqlType.blob,
            data['${effectivePrefix}data'],
          )!,
    );
  }

  @override
  PitScouting createAlias(String alias) {
    return PitScouting(attachedDatabase, alias);
  }
}

class PitScoutingData extends DataClass implements Insertable<PitScoutingData> {
  final int teamNumber;
  final String eventCode;
  final int gameFormat;
  final BigInt timeStamp;
  final String scoutName;
  final i2.Uint8List data;
  const PitScoutingData({
    required this.teamNumber,
    required this.eventCode,
    required this.gameFormat,
    required this.timeStamp,
    required this.scoutName,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['team_number'] = Variable<int>(teamNumber);
    map['event_code'] = Variable<String>(eventCode);
    map['game_format'] = Variable<int>(gameFormat);
    map['time_stamp'] = Variable<BigInt>(timeStamp);
    map['scout_name'] = Variable<String>(scoutName);
    map['data'] = Variable<i2.Uint8List>(data);
    return map;
  }

  PitScoutingCompanion toCompanion(bool nullToAbsent) {
    return PitScoutingCompanion(
      teamNumber: Value(teamNumber),
      eventCode: Value(eventCode),
      gameFormat: Value(gameFormat),
      timeStamp: Value(timeStamp),
      scoutName: Value(scoutName),
      data: Value(data),
    );
  }

  factory PitScoutingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PitScoutingData(
      teamNumber: serializer.fromJson<int>(json['teamNumber']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      gameFormat: serializer.fromJson<int>(json['gameFormat']),
      timeStamp: serializer.fromJson<BigInt>(json['timeStamp']),
      scoutName: serializer.fromJson<String>(json['scoutName']),
      data: serializer.fromJson<i2.Uint8List>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'teamNumber': serializer.toJson<int>(teamNumber),
      'eventCode': serializer.toJson<String>(eventCode),
      'gameFormat': serializer.toJson<int>(gameFormat),
      'timeStamp': serializer.toJson<BigInt>(timeStamp),
      'scoutName': serializer.toJson<String>(scoutName),
      'data': serializer.toJson<i2.Uint8List>(data),
    };
  }

  PitScoutingData copyWith({
    int? teamNumber,
    String? eventCode,
    int? gameFormat,
    BigInt? timeStamp,
    String? scoutName,
    i2.Uint8List? data,
  }) => PitScoutingData(
    teamNumber: teamNumber ?? this.teamNumber,
    eventCode: eventCode ?? this.eventCode,
    gameFormat: gameFormat ?? this.gameFormat,
    timeStamp: timeStamp ?? this.timeStamp,
    scoutName: scoutName ?? this.scoutName,
    data: data ?? this.data,
  );
  PitScoutingData copyWithCompanion(PitScoutingCompanion data) {
    return PitScoutingData(
      teamNumber:
          data.teamNumber.present ? data.teamNumber.value : this.teamNumber,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      gameFormat:
          data.gameFormat.present ? data.gameFormat.value : this.gameFormat,
      timeStamp: data.timeStamp.present ? data.timeStamp.value : this.timeStamp,
      scoutName: data.scoutName.present ? data.scoutName.value : this.scoutName,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PitScoutingData(')
          ..write('teamNumber: $teamNumber, ')
          ..write('eventCode: $eventCode, ')
          ..write('gameFormat: $gameFormat, ')
          ..write('timeStamp: $timeStamp, ')
          ..write('scoutName: $scoutName, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    teamNumber,
    eventCode,
    gameFormat,
    timeStamp,
    scoutName,
    $driftBlobEquality.hash(data),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PitScoutingData &&
          other.teamNumber == this.teamNumber &&
          other.eventCode == this.eventCode &&
          other.gameFormat == this.gameFormat &&
          other.timeStamp == this.timeStamp &&
          other.scoutName == this.scoutName &&
          $driftBlobEquality.equals(other.data, this.data));
}

class PitScoutingCompanion extends UpdateCompanion<PitScoutingData> {
  final Value<int> teamNumber;
  final Value<String> eventCode;
  final Value<int> gameFormat;
  final Value<BigInt> timeStamp;
  final Value<String> scoutName;
  final Value<i2.Uint8List> data;
  final Value<int> rowid;
  const PitScoutingCompanion({
    this.teamNumber = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.gameFormat = const Value.absent(),
    this.timeStamp = const Value.absent(),
    this.scoutName = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PitScoutingCompanion.insert({
    required int teamNumber,
    required String eventCode,
    required int gameFormat,
    required BigInt timeStamp,
    required String scoutName,
    required i2.Uint8List data,
    this.rowid = const Value.absent(),
  }) : teamNumber = Value(teamNumber),
       eventCode = Value(eventCode),
       gameFormat = Value(gameFormat),
       timeStamp = Value(timeStamp),
       scoutName = Value(scoutName),
       data = Value(data);
  static Insertable<PitScoutingData> custom({
    Expression<int>? teamNumber,
    Expression<String>? eventCode,
    Expression<int>? gameFormat,
    Expression<BigInt>? timeStamp,
    Expression<String>? scoutName,
    Expression<i2.Uint8List>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (teamNumber != null) 'team_number': teamNumber,
      if (eventCode != null) 'event_code': eventCode,
      if (gameFormat != null) 'game_format': gameFormat,
      if (timeStamp != null) 'time_stamp': timeStamp,
      if (scoutName != null) 'scout_name': scoutName,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PitScoutingCompanion copyWith({
    Value<int>? teamNumber,
    Value<String>? eventCode,
    Value<int>? gameFormat,
    Value<BigInt>? timeStamp,
    Value<String>? scoutName,
    Value<i2.Uint8List>? data,
    Value<int>? rowid,
  }) {
    return PitScoutingCompanion(
      teamNumber: teamNumber ?? this.teamNumber,
      eventCode: eventCode ?? this.eventCode,
      gameFormat: gameFormat ?? this.gameFormat,
      timeStamp: timeStamp ?? this.timeStamp,
      scoutName: scoutName ?? this.scoutName,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (teamNumber.present) {
      map['team_number'] = Variable<int>(teamNumber.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (gameFormat.present) {
      map['game_format'] = Variable<int>(gameFormat.value);
    }
    if (timeStamp.present) {
      map['time_stamp'] = Variable<BigInt>(timeStamp.value);
    }
    if (scoutName.present) {
      map['scout_name'] = Variable<String>(scoutName.value);
    }
    if (data.present) {
      map['data'] = Variable<i2.Uint8List>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PitScoutingCompanion(')
          ..write('teamNumber: $teamNumber, ')
          ..write('eventCode: $eventCode, ')
          ..write('gameFormat: $gameFormat, ')
          ..write('timeStamp: $timeStamp, ')
          ..write('scoutName: $scoutName, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final Teams teams = Teams(this);
  late final MatchResults matchResults = MatchResults(this);
  late final PitScouting pitScouting = PitScouting(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    teams,
    matchResults,
    pitScouting,
  ];
  @override
  int get schemaVersion => 2;
}
