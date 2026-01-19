import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/model/game_format.dart';
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
    return await db.managers.matchResults.get();
  }

  Future<MatchResult?> getResult(BigInt uuid) {
    final db = ref.read(databaseProvider);
    return db.managers.matchResults
        .filter((e) => e.uuid(uuid))
        .getSingleOrNull();
  }

  Future<List<MatchResult>> filterResults({
    String? event,
    int? team,
    int? match,
    GameFormat? gameFormat,
  }) {
    final db = ref.read(databaseProvider);
    String? game = gameFormat?.name;
    return db.managers.matchResults
        .filter((e) => Variable(event).isNull() | e.eventName(event))
        .filter((e) => Variable(team).isNull() | e.teamNumber(team))
        .filter((e) => Variable(match).isNull() | e.matchNumber(match))
        .filter((e) => Variable(game).isNull() | e.gameFormatName(game))
        .get();
  }

  Future<String?> addResult(MatchResult result, [bool doRefresh = true]) async {
    final db = ref.read(databaseProvider);

    try {
      await db.into(db.matchResults).insert(result);
    } catch (error) {
      return "Error: ${error.toString()}";
    }
    if (doRefresh) {
      ref.invalidateSelf();
    }
    return null;
  }

  Future<String?> addAllResults(
    List<MatchResult> results, [
    bool doRefresh = true,
  ]) async {
    final db = ref.read(databaseProvider);

    try {
      await db.matchResults.insertAll(results);
    } catch (error) {
      return "Error: ${error.toString()}";
    }
    if (doRefresh) {
      ref.invalidateSelf();
    }
    return null;
  }

  Future<String?> deleteResults({
    String? eventName,
    int? teamNumber,
    int? matchNumber,
    GameFormat? gameFormat,
  }) async {
    final db = ref.read(databaseProvider);

    String? gameFormatName = gameFormat?.name;
    int deletions =
        await db.managers.matchResults
            .filter((e) => e.eventName(eventName))
            .filter((e) => e.teamNumber(teamNumber))
            .filter((e) => e.matchNumber(matchNumber))
            .filter((e) => e.gameFormatName(gameFormatName))
            .delete();

    if (deletions == 0) {
      return "Zero succesful deletions";
    }

    ref.invalidateSelf();

    return null;
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
      await db.managers.matchResults.delete();
    } catch (error) {
      return "Error: ${error.toString()}";
    }
    ref.invalidateSelf();

    return null;
  }
}

@riverpod
Future<List<int>> resultIndices(
  Ref ref, {
  SortType sort = SortType.matchNumAscending,
  String? teamFilter,
  String? eventName,
  int? matchNumber,
  GameFormat? gameFormat,
}) async {
  final List<MatchResult> results = await ref
      .watch(storedResultsProvider.notifier)
      .filterResults(
        event: eventName,
        match: matchNumber,
        gameFormat: gameFormat,
      );

  List<int> indices = [];
  for (int i = 0; i < results.length; i++) {
    if (results[i].teamNumber.toString().startsWith(teamFilter ?? "")) {
      indices.add(i);
    }
  }

  switch (sort) {
    case SortType.matchNumAscending:
      indices.sort((a, b) {
        int sort = results[a].matchNumber - results[b].matchNumber;
        if (sort == 0) {
          return results[a].teamNumber - results[b].teamNumber;
        }
        return sort;
      });
      break;
    case SortType.matchNumDescending:
      indices.sort((a, b) {
        int sort = results[b].matchNumber - results[a].matchNumber;
        if (sort == 0) {
          return results[b].teamNumber - results[a].teamNumber;
        }
        return sort;
      });
      break;
    case SortType.teamNumAscending:
      indices.sort((a, b) {
        int sort = results[a].teamNumber - results[b].teamNumber;
        if (sort == 0) {
          return results[a].matchNumber - results[b].matchNumber;
        }
        return sort;
      });
      break;
    case SortType.teamNumDescending:
      indices.sort((a, b) {
        int sort = results[b].teamNumber - results[a].teamNumber;
        if (sort == 0) {
          return results[a].matchNumber - results[b].matchNumber;
        }
        return sort;
      });
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

@Riverpod(keepAlive: true)
Future<List<String>> resultEvents(Ref ref) async {
  List<String> events = [];
  List<MatchResult> results = await ref.read(storedResultsProvider.future);

  for (final result in results) {
    if (!events.contains(result.eventName)) {
      events.add(result.eventName);
    }
  }
  return events;
}
