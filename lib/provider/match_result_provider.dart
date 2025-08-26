import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/provider/database_provider.dart';

part 'match_result_provider.g.dart';

@Riverpod(keepAlive: true)
class StoredResults extends _$StoredResults {
  @override
  Future<List<MatchResult>> build() async {
    final db = ref.watch(databaseProvider);

    var results = await db.managers.matchResults.get();

    return results;
  }
}

@riverpod
Future<List<MatchResult>> storedMatchResults(Ref ref) async {
  final db = ref.watch(databaseProvider);

  // var results = await db.select(db.matchResults).get();
  var results = await db.managers.matchResults.get();
  return results;
}
