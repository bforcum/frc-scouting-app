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
      return "Error: ${error.toString()}";
    }
    await refresh();

    return null;
  }

  Future<String?> deleteResult(
    String eventName,
    int teamNumber,
    int matchNumber,
  ) async {
    final db = ref.read(databaseProvider);

    int deletions =
        await db.managers.matchResults
            .filter((e) => e.eventName(eventName))
            .filter((e) => e.teamNumber(teamNumber))
            .filter((e) => e.matchNumber(matchNumber))
            .delete();

    if (deletions == 0) {
      return "Zero succesful deletions";
    }

    await refresh();

    return null;
  }

  Future<String?> updateResult(MatchResult result) async {
    final db = ref.read(databaseProvider);

    if (await db.managers.matchResults.replace(result) == false) {
      return "Replacement failed";
    }
    refresh();

    return null;
  }
}
