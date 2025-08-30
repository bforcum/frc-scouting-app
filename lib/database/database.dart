import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@UseRowClass(MatchResult, constructor: "fromDb")
class MatchResults extends Table {
  TextColumn get eventName => text()();
  IntColumn get teamNumber => integer()();
  IntColumn get matchNumber => integer()();
  Int64Column get timeStamp => int64()();
  TextColumn get scoutName => text()();
  TextColumn get gameFormatName => text()();
  BlobColumn get data => blob()();

  @override
  Set<Column> get primaryKey => {eventName, teamNumber, matchNumber};
}

@DriftDatabase(tables: [MatchResults])
class AppDatabase extends _$AppDatabase {
  AppDatabase({FutureOr<Directory>? directory})
    : super(_openConnection(directory));

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(FutureOr<Directory>? dbDirectory) {
    return LazyDatabase(() async {
      final dbFolder =
          await dbDirectory ?? await getApplicationSupportDirectory();
      debugPrint(dbFolder.toString());
      final file = File(path.join(dbFolder.path, 'db.sqlite'));

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

  // static QueryExecutor _openConnection() {
  //   return driftDatabase(
  //     name: 'app_database',
  //     native: DriftNativeOptions(
  //       databaseDirectory: () => getApplicationCacheDirectory(),
  //     ),
  //     // If you need web support, see https://drift.simonbinder.eu/platforms/web/
  //   );
  // }
}
