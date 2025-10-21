import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/provider/database_provider.dart';

part 'stored_results_provider.g.dart';

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

  MatchResult? getResult(int index) {
    return state.value?[index];
  }

  Future<String?> updateResult(MatchResult result) async {
    final db = ref.read(databaseProvider);

    if (await db.managers.matchResults.replace(result) == false) {
      return "Replacement failed";
    }

    return null;
  }

  Future<String?> clearAll() async {
    final db = ref.read(databaseProvider);

    try {
      await db.delete(db.matchResults).go();
    } catch (error) {
      return "Error: ${error.toString()}";
    }
    await refresh();

    return null;
  }
}

@riverpod
Future<List<int>> resultIndices(Ref ref, SortType sort, String teamFilter) async {
  List<MatchResult> results = await ref.watch(storedResultsProvider.future);
  
  List<int> indices = List<int>.empty(growable: true);

  for (int i = 0; i < results.length; i++) {
    if (results[i].teamNumber.toString().contains(teamFilter)) {
      indices.add(i);
    }
  }

  switch (sort) {
    case SortType.matchNumAscending: 
      indices.sort((a,b) =>
        results[a].matchNumber - results[b].matchNumber
      );
      break;
    case SortType.matchNumDescending:
      indices.sort((a,b) =>
        results[b].matchNumber - results[a].matchNumber
      );
      break;
    case SortType.teamNumAscending:
      indices.sort((a,b) =>
        results[a].teamNumber - results[b].teamNumber
      );
      break;
    case SortType.teamNumDescending:
      indices.sort((a,b) =>
        results[b].teamNumber - results[a].teamNumber
      );
      break;
  }
  return indices;
}

enum SortType {
  matchNumAscending,
  matchNumDescending,
  teamNumAscending,
  teamNumDescending,
}
