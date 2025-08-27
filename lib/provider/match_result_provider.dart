import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/provider/database_provider.dart';

part 'match_result_provider.g.dart';

@Riverpod(keepAlive: true)
class StoredResults extends _$StoredResults {
  @override
  Future<List<MatchResult>> build() async {
    return await _fetch();
  }

  Future<List<MatchResult>> _fetch() async {
    final db = ref.watch(databaseProvider);

    var results = await db.managers.matchResults.get();

    return results;
  }

  Future<void> refresh() async {
    state = AsyncLoading();
    ref.notifyListeners();
    final values = await _fetch();
    state = AsyncData(values);
    ref.notifyListeners();
  }

  Future<String?> addResult(MatchResult result) async {
    final db = ref.read(databaseProvider);

    try {
      await db.into(db.matchResults).insert(result);
    } catch (error) {
      return "This match already exists";
    }
    await refresh();

    return null;
  }
}
