import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'database.steps.dart';

part 'database.g.dart';

@UseRowClass(MatchResult, constructor: "fromDb")
class MatchResults extends Table {
  Int64Column get uuid => int64()();
  TextColumn get eventCode => text()();
  TextColumn get teamNumber => text()();
  IntColumn get matchNumber => integer()();
  Int64Column get timeStamp => int64()();
  TextColumn get scoutName => text()();
  IntColumn get gameFormat => integer()();
  BlobColumn get data => blob()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class Teams extends Table {
  IntColumn get teamNumber => integer()();
  TextColumn get eventCode => text()();
  IntColumn get gameFormat => integer()();
  IntColumn get pickListPosition => integer().nullable()();

  @override
  Set<Column> get primaryKey => {teamNumber, eventCode, gameFormat};
}

class PitScouting extends Table {
  IntColumn get teamNumber => integer()();
  TextColumn get eventCode => text()();
  IntColumn get gameFormat => integer()();
  Int64Column get timeStamp => int64()();
  TextColumn get scoutName => text()();
  BlobColumn get data => blob()();

  @override
  Set<Column> get primaryKey => {teamNumber, eventCode, gameFormat};
}

@DriftDatabase(tables: [Teams, MatchResults, PitScouting])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await kDbPath;
      debugPrint(dbFolder.toString());
      final file = File(path.join(dbFolder.path, "$kDbName.sqlite"));

      // Also work around limitations on old Android versions
      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }

      // Make sqlite3 pick a more suitable location for temporary files - the
      // one from the system may be inaccessible due to sandboxing.
      final cachebase = (await getTemporaryDirectory()).path;
      // We can't access /tmp on Android, which sqlite3 would try by default.
      // Explicitly tell it about the correct temporary directory.
      sqlite3.tempDirectory = cachebase;

      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onUpgrade: _schemaUpgrade);
  }
}

extension Migrations on GeneratedDatabase {
  OnUpgrade get _schemaUpgrade => stepByStep(
    from1To2: (m, schema) async {
      await m.drop(schema.matchResults);
      await m.create(schema.matchResults);
      await m.drop(schema.teams);
      await m.create(schema.teams);
      await m.create(schema.pitScouting);
    },
  );
}

/*
extension Migrations on GeneratedDatabase {
  // Extracting the `stepByStep` call into a static field or method ensures that you're not
  // accidentally referring to the current database schema (via a getter on the database class).
  // This ensures that each step brings the database into the correct snapshot.
  OnUpgrade get _schemaUpgrade => stepByStep(
    from1To2: (m, schema) async {
      await m.createTable(schema.groups);
    },
  );
}
*/
