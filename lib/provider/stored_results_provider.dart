import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/provider/database_provider.dart';

part 'stored_results_provider.g.dart';

@riverpod
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
    int? game = gameFormat?.id;
    return db.managers.matchResults
        .filter((e) => Variable(event).isNull() | e.eventCode(event))
        .filter((e) => Variable(team).isNull() | e.teamNumber(team?.toString()))
        .filter((e) => Variable(match).isNull() | e.matchNumber(match))
        .filter((e) => Variable(game).isNull() | e.gameFormat(game))
        .get();
  }

  Future<String?> addResult(MatchResult result) async {
    final db = ref.read(databaseProvider);

    try {
      await db.into(db.matchResults).insert(result);
    } catch (error) {
      return "Error: ${error.toString()}";
    }
    ref.invalidate(filteredResultsProvider);
    ref.invalidateSelf();

    return null;
  }

  Future<String?> addAllResults(List<MatchResult> results) async {
    final db = ref.read(databaseProvider);

    try {
      await db.matchResults.insertAll(results, mode: InsertMode.insertOrFail);
    } catch (error) {
      return "Error: ${error.toString()}";
    }
    ref.invalidate(filteredResultsProvider);
    ref.invalidateSelf();

    return null;
  }

  Future<bool> deleteByUuid(List<BigInt> uuids) async {
    int successes =
        await ref
            .read(databaseProvider)
            .managers
            .matchResults
            .filter((e) => e.uuid.isIn(uuids))
            .delete();
    ref.invalidate(filteredResultsProvider);
    ref.invalidateSelf();
    return successes == uuids.length;
  }

  Future<int> deleteResults({
    String? event,
    int? team,
    int? match,
    GameFormat? gameFormat,
  }) async {
    final db = ref.read(databaseProvider);

    int? game = gameFormat?.id;
    int deletions =
        await db.managers.matchResults
            .filter((e) => Variable(event).isNull() | e.eventCode(event))
            .filter(
              (e) => Variable(team).isNull() | e.teamNumber(team?.toString()),
            )
            .filter((e) => Variable(match).isNull() | e.matchNumber(match))
            .filter((e) => Variable(game).isNull() | e.gameFormat(game))
            .delete();
    ref.invalidate(filteredResultsProvider);
    ref.invalidateSelf();

    return deletions;
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
    ref.invalidate(filteredResultsProvider);
    ref.invalidateSelf();

    return null;
  }
}

@riverpod
Future<List<MatchResult>> filteredResults(
  Ref ref, {
  SortType sort = SortType.matchNumAscending,
  String? teamFilter,
  String? eventCode,
  int? matchNumber,
  GameFormat? gameFormat,
}) async {
  final AppDatabase db = ref.read(databaseProvider);
  final resultsQuery = db.managers.matchResults
      .filter((e) => Variable(eventCode).isNull() | e.eventCode(eventCode))
      .filter(
        (e) =>
            Variable(teamFilter).isNull() |
            e.teamNumber.startsWith(teamFilter ?? ""),
      )
      .filter(
        (e) => Variable(matchNumber).isNull() | e.matchNumber(matchNumber),
      )
      .filter(
        (e) => Variable(gameFormat?.id).isNull() | e.gameFormat(gameFormat?.id),
      );
  switch (sort) {
    case SortType.matchNumAscending:
      return resultsQuery
          .orderBy((o) => o.matchNumber.asc() & o.teamNumber.asc())
          .get();
    case SortType.matchNumDescending:
      return resultsQuery
          .orderBy((o) => o.matchNumber.desc() & o.teamNumber.asc())
          .get();
    case SortType.teamNumAscending:
      return resultsQuery
          .orderBy((o) => o.teamNumber.asc() & o.matchNumber.asc())
          .get();
    case SortType.teamNumDescending:
      return resultsQuery
          .orderBy((o) => o.teamNumber.desc() & o.matchNumber.asc())
          .get();
    case SortType.timeAscending:
      return resultsQuery.orderBy((o) => o.timeStamp.asc()).get();
    case SortType.timeDescending:
      return resultsQuery.orderBy((o) => o.timeStamp.desc()).get();
  }
}

enum SortType {
  matchNumAscending,
  matchNumDescending,
  teamNumAscending,
  teamNumDescending,
  timeAscending,
  timeDescending,
}

@riverpod
Future<List<String>> resultEvents(Ref ref) async {
  List<String> events = [];
  List<MatchResult> results = await ref.read(storedResultsProvider.future);

  for (final result in results) {
    if (!events.contains(result.eventCode)) {
      events.add(result.eventCode);
    }
  }
  return events;
}
