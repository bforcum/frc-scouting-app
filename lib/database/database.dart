import 'package:drift/drift.dart';
import 'package:scouting_app/model/match_data.dart';

part 'database.g.dart';

@UseRowClass(MatchData, constructor: "fromDb")
class MatchDataTable extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get teamNumber => integer()();
  IntColumn get matchNumber => integer()();
  TextColumn get gameFormatName => text()();
  TextColumn get scoutName => text()();
  BlobColumn get data => blob()();

  @override
  Set<Column> get primaryKey => {gameFormatName, teamNumber, matchNumber};
}

@DriftDatabase(tables: [MatchDataTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
