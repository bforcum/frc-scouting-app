// dart format width=80
import 'dart:typed_data' as i2;
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

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
  late final GeneratedColumn<String> eventName = GeneratedColumn<String>(
    'event_name',
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
  late final GeneratedColumn<String> gameFormatName = GeneratedColumn<String>(
    'game_format_name',
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
    uuid,
    eventName,
    teamNumber,
    matchNumber,
    timeStamp,
    scoutName,
    gameFormatName,
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
      eventName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_name'],
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
      gameFormatName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}game_format_name'],
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
  final String eventName;
  final String teamNumber;
  final int matchNumber;
  final BigInt timeStamp;
  final String scoutName;
  final String gameFormatName;
  final i2.Uint8List data;
  const MatchResultsData({
    required this.uuid,
    required this.eventName,
    required this.teamNumber,
    required this.matchNumber,
    required this.timeStamp,
    required this.scoutName,
    required this.gameFormatName,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<BigInt>(uuid);
    map['event_name'] = Variable<String>(eventName);
    map['team_number'] = Variable<String>(teamNumber);
    map['match_number'] = Variable<int>(matchNumber);
    map['time_stamp'] = Variable<BigInt>(timeStamp);
    map['scout_name'] = Variable<String>(scoutName);
    map['game_format_name'] = Variable<String>(gameFormatName);
    map['data'] = Variable<i2.Uint8List>(data);
    return map;
  }

  MatchResultsCompanion toCompanion(bool nullToAbsent) {
    return MatchResultsCompanion(
      uuid: Value(uuid),
      eventName: Value(eventName),
      teamNumber: Value(teamNumber),
      matchNumber: Value(matchNumber),
      timeStamp: Value(timeStamp),
      scoutName: Value(scoutName),
      gameFormatName: Value(gameFormatName),
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
      eventName: serializer.fromJson<String>(json['eventName']),
      teamNumber: serializer.fromJson<String>(json['teamNumber']),
      matchNumber: serializer.fromJson<int>(json['matchNumber']),
      timeStamp: serializer.fromJson<BigInt>(json['timeStamp']),
      scoutName: serializer.fromJson<String>(json['scoutName']),
      gameFormatName: serializer.fromJson<String>(json['gameFormatName']),
      data: serializer.fromJson<i2.Uint8List>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<BigInt>(uuid),
      'eventName': serializer.toJson<String>(eventName),
      'teamNumber': serializer.toJson<String>(teamNumber),
      'matchNumber': serializer.toJson<int>(matchNumber),
      'timeStamp': serializer.toJson<BigInt>(timeStamp),
      'scoutName': serializer.toJson<String>(scoutName),
      'gameFormatName': serializer.toJson<String>(gameFormatName),
      'data': serializer.toJson<i2.Uint8List>(data),
    };
  }

  MatchResultsData copyWith({
    BigInt? uuid,
    String? eventName,
    String? teamNumber,
    int? matchNumber,
    BigInt? timeStamp,
    String? scoutName,
    String? gameFormatName,
    i2.Uint8List? data,
  }) => MatchResultsData(
    uuid: uuid ?? this.uuid,
    eventName: eventName ?? this.eventName,
    teamNumber: teamNumber ?? this.teamNumber,
    matchNumber: matchNumber ?? this.matchNumber,
    timeStamp: timeStamp ?? this.timeStamp,
    scoutName: scoutName ?? this.scoutName,
    gameFormatName: gameFormatName ?? this.gameFormatName,
    data: data ?? this.data,
  );
  MatchResultsData copyWithCompanion(MatchResultsCompanion data) {
    return MatchResultsData(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      eventName: data.eventName.present ? data.eventName.value : this.eventName,
      teamNumber:
          data.teamNumber.present ? data.teamNumber.value : this.teamNumber,
      matchNumber:
          data.matchNumber.present ? data.matchNumber.value : this.matchNumber,
      timeStamp: data.timeStamp.present ? data.timeStamp.value : this.timeStamp,
      scoutName: data.scoutName.present ? data.scoutName.value : this.scoutName,
      gameFormatName:
          data.gameFormatName.present
              ? data.gameFormatName.value
              : this.gameFormatName,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchResultsData(')
          ..write('uuid: $uuid, ')
          ..write('eventName: $eventName, ')
          ..write('teamNumber: $teamNumber, ')
          ..write('matchNumber: $matchNumber, ')
          ..write('timeStamp: $timeStamp, ')
          ..write('scoutName: $scoutName, ')
          ..write('gameFormatName: $gameFormatName, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    eventName,
    teamNumber,
    matchNumber,
    timeStamp,
    scoutName,
    gameFormatName,
    $driftBlobEquality.hash(data),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchResultsData &&
          other.uuid == this.uuid &&
          other.eventName == this.eventName &&
          other.teamNumber == this.teamNumber &&
          other.matchNumber == this.matchNumber &&
          other.timeStamp == this.timeStamp &&
          other.scoutName == this.scoutName &&
          other.gameFormatName == this.gameFormatName &&
          $driftBlobEquality.equals(other.data, this.data));
}

class MatchResultsCompanion extends UpdateCompanion<MatchResultsData> {
  final Value<BigInt> uuid;
  final Value<String> eventName;
  final Value<String> teamNumber;
  final Value<int> matchNumber;
  final Value<BigInt> timeStamp;
  final Value<String> scoutName;
  final Value<String> gameFormatName;
  final Value<i2.Uint8List> data;
  const MatchResultsCompanion({
    this.uuid = const Value.absent(),
    this.eventName = const Value.absent(),
    this.teamNumber = const Value.absent(),
    this.matchNumber = const Value.absent(),
    this.timeStamp = const Value.absent(),
    this.scoutName = const Value.absent(),
    this.gameFormatName = const Value.absent(),
    this.data = const Value.absent(),
  });
  MatchResultsCompanion.insert({
    this.uuid = const Value.absent(),
    required String eventName,
    required String teamNumber,
    required int matchNumber,
    required BigInt timeStamp,
    required String scoutName,
    required String gameFormatName,
    required i2.Uint8List data,
  }) : eventName = Value(eventName),
       teamNumber = Value(teamNumber),
       matchNumber = Value(matchNumber),
       timeStamp = Value(timeStamp),
       scoutName = Value(scoutName),
       gameFormatName = Value(gameFormatName),
       data = Value(data);
  static Insertable<MatchResultsData> custom({
    Expression<BigInt>? uuid,
    Expression<String>? eventName,
    Expression<String>? teamNumber,
    Expression<int>? matchNumber,
    Expression<BigInt>? timeStamp,
    Expression<String>? scoutName,
    Expression<String>? gameFormatName,
    Expression<i2.Uint8List>? data,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (eventName != null) 'event_name': eventName,
      if (teamNumber != null) 'team_number': teamNumber,
      if (matchNumber != null) 'match_number': matchNumber,
      if (timeStamp != null) 'time_stamp': timeStamp,
      if (scoutName != null) 'scout_name': scoutName,
      if (gameFormatName != null) 'game_format_name': gameFormatName,
      if (data != null) 'data': data,
    });
  }

  MatchResultsCompanion copyWith({
    Value<BigInt>? uuid,
    Value<String>? eventName,
    Value<String>? teamNumber,
    Value<int>? matchNumber,
    Value<BigInt>? timeStamp,
    Value<String>? scoutName,
    Value<String>? gameFormatName,
    Value<i2.Uint8List>? data,
  }) {
    return MatchResultsCompanion(
      uuid: uuid ?? this.uuid,
      eventName: eventName ?? this.eventName,
      teamNumber: teamNumber ?? this.teamNumber,
      matchNumber: matchNumber ?? this.matchNumber,
      timeStamp: timeStamp ?? this.timeStamp,
      scoutName: scoutName ?? this.scoutName,
      gameFormatName: gameFormatName ?? this.gameFormatName,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<BigInt>(uuid.value);
    }
    if (eventName.present) {
      map['event_name'] = Variable<String>(eventName.value);
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
    if (gameFormatName.present) {
      map['game_format_name'] = Variable<String>(gameFormatName.value);
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
          ..write('eventName: $eventName, ')
          ..write('teamNumber: $teamNumber, ')
          ..write('matchNumber: $matchNumber, ')
          ..write('timeStamp: $timeStamp, ')
          ..write('scoutName: $scoutName, ')
          ..write('gameFormatName: $gameFormatName, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

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
  late final GeneratedColumn<String> gameFormatName = GeneratedColumn<String>(
    'game_format_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    gameFormatName,
    pickListPosition,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams';
  @override
  Set<GeneratedColumn> get $primaryKey => {teamNumber, gameFormatName};
  @override
  TeamsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamsData(
      teamNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}team_number'],
          )!,
      gameFormatName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}game_format_name'],
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
  final String gameFormatName;
  final int? pickListPosition;
  const TeamsData({
    required this.teamNumber,
    required this.gameFormatName,
    this.pickListPosition,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['team_number'] = Variable<int>(teamNumber);
    map['game_format_name'] = Variable<String>(gameFormatName);
    if (!nullToAbsent || pickListPosition != null) {
      map['pick_list_position'] = Variable<int>(pickListPosition);
    }
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(
      teamNumber: Value(teamNumber),
      gameFormatName: Value(gameFormatName),
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
      gameFormatName: serializer.fromJson<String>(json['gameFormatName']),
      pickListPosition: serializer.fromJson<int?>(json['pickListPosition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'teamNumber': serializer.toJson<int>(teamNumber),
      'gameFormatName': serializer.toJson<String>(gameFormatName),
      'pickListPosition': serializer.toJson<int?>(pickListPosition),
    };
  }

  TeamsData copyWith({
    int? teamNumber,
    String? gameFormatName,
    Value<int?> pickListPosition = const Value.absent(),
  }) => TeamsData(
    teamNumber: teamNumber ?? this.teamNumber,
    gameFormatName: gameFormatName ?? this.gameFormatName,
    pickListPosition:
        pickListPosition.present
            ? pickListPosition.value
            : this.pickListPosition,
  );
  TeamsData copyWithCompanion(TeamsCompanion data) {
    return TeamsData(
      teamNumber:
          data.teamNumber.present ? data.teamNumber.value : this.teamNumber,
      gameFormatName:
          data.gameFormatName.present
              ? data.gameFormatName.value
              : this.gameFormatName,
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
          ..write('gameFormatName: $gameFormatName, ')
          ..write('pickListPosition: $pickListPosition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(teamNumber, gameFormatName, pickListPosition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamsData &&
          other.teamNumber == this.teamNumber &&
          other.gameFormatName == this.gameFormatName &&
          other.pickListPosition == this.pickListPosition);
}

class TeamsCompanion extends UpdateCompanion<TeamsData> {
  final Value<int> teamNumber;
  final Value<String> gameFormatName;
  final Value<int?> pickListPosition;
  final Value<int> rowid;
  const TeamsCompanion({
    this.teamNumber = const Value.absent(),
    this.gameFormatName = const Value.absent(),
    this.pickListPosition = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeamsCompanion.insert({
    required int teamNumber,
    required String gameFormatName,
    this.pickListPosition = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : teamNumber = Value(teamNumber),
       gameFormatName = Value(gameFormatName);
  static Insertable<TeamsData> custom({
    Expression<int>? teamNumber,
    Expression<String>? gameFormatName,
    Expression<int>? pickListPosition,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (teamNumber != null) 'team_number': teamNumber,
      if (gameFormatName != null) 'game_format_name': gameFormatName,
      if (pickListPosition != null) 'pick_list_position': pickListPosition,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeamsCompanion copyWith({
    Value<int>? teamNumber,
    Value<String>? gameFormatName,
    Value<int?>? pickListPosition,
    Value<int>? rowid,
  }) {
    return TeamsCompanion(
      teamNumber: teamNumber ?? this.teamNumber,
      gameFormatName: gameFormatName ?? this.gameFormatName,
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
    if (gameFormatName.present) {
      map['game_format_name'] = Variable<String>(gameFormatName.value);
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
          ..write('gameFormatName: $gameFormatName, ')
          ..write('pickListPosition: $pickListPosition, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final MatchResults matchResults = MatchResults(this);
  late final Teams teams = Teams(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [matchResults, teams];
  @override
  int get schemaVersion => 1;
}
