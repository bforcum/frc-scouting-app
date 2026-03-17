import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/settings.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/provider/database_provider.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

part 'teams_provider.g.dart';

@Riverpod(keepAlive: true)
class TeamsList extends _$TeamsList {
  @override
  Future<List<TeamData>> build() async {
    SettingsModel settings = ref.watch(settingsProvider);
    GameFormat gameFormat = settings.gameFormat;
    List<MatchResult> results = await ref
        .watch(storedResultsProvider.notifier)
        .filterResults(gameFormat: gameFormat);
    Map<int, List<MatchResult>> binnedResults = {};

    for (MatchResult result in results) {
      int teamNumber = result.teamNumber;

      // If the binned list doesn't contain this team number yet, add it
      if (!binnedResults.containsKey(teamNumber)) {
        binnedResults[teamNumber] = [result];
        continue;
      }
      // Add the match result to its respective bin
      binnedResults[teamNumber]!.add(result);
    }
    final teamNumbers = binnedResults.keys;

    // Delete all teams not in teamNumbers list
    await ref
        .read(databaseProvider)
        .managers
        .teams
        .filter((e) => e.gameFormatName.equals(gameFormat.name))
        .filter((e) => e.teamNumber.not.isIn(teamNumbers))
        .delete();

    // Add all teams not in database list
    await ref
        .read(databaseProvider)
        .managers
        .teams
        .bulkCreate(
          (o) => teamNumbers.map(
            (val) => TeamsCompanion(
              teamNumber: Value(val),
              gameFormatName: Value(gameFormat.name),
            ),
          ),
          mode: InsertMode.insertOrIgnore,
        );

    // Filter results and map them to TeamData
    List<TeamData> stats =
        (await ref
                .read(databaseProvider)
                .managers
                .teams
                .filter((e) => e.gameFormatName.equals(gameFormat.name))
                .get())
            .map(
              (team) => TeamData(
                position: team.pickListPosition,
                results: binnedResults[team.teamNumber]!,
              ),
            )
            .toList();
    return stats;
  }

  Future move(Team team) async {
    AppDatabase db = await ref.read(databaseProvider);
    Team previous =
        await db.managers.teams
            .filter((e) => e.gameFormatName.equals(team.gameFormatName))
            .filter((e) => e.teamNumber.equals(team.teamNumber))
            .getSingle();

    if (previous.pickListPosition == team.pickListPosition) return;

    final updateStatement = db.update(db.teams);
    if (previous.pickListPosition == null) {
      updateStatement.where(
        (e) =>
            e.gameFormatName.equals(team.gameFormatName) &
            e.pickListPosition.isBiggerOrEqualValue(team.pickListPosition!) &
            e.pickListPosition.isNotNull(),
      );
      await updateStatement.write(
        TeamsCompanion.custom(
          pickListPosition: db.teams.pickListPosition + Variable(1),
        ),
      );
    } else if (team.pickListPosition == null) {
      updateStatement.where(
        (e) =>
            e.gameFormatName.equals(team.gameFormatName) &
            e.pickListPosition.isBiggerThanValue(previous.pickListPosition!) &
            e.pickListPosition.isNotNull(),
      );
      await updateStatement.write(
        TeamsCompanion.custom(
          pickListPosition: db.teams.pickListPosition - Variable(1),
        ),
      );
    } else if (team.pickListPosition! < previous.pickListPosition!) {
      updateStatement.where(
        (e) =>
            e.gameFormatName.equals(team.gameFormatName) &
            e.pickListPosition.isBiggerOrEqualValue(team.pickListPosition!) &
            e.pickListPosition.isSmallerThanValue(previous.pickListPosition!) &
            e.pickListPosition.isNotNull(),
      );
      await updateStatement.write(
        TeamsCompanion.custom(
          pickListPosition: db.teams.pickListPosition + Variable(1),
        ),
      );
    } else if (team.pickListPosition! > previous.pickListPosition!) {
      updateStatement.where(
        (e) =>
            e.gameFormatName.equals(team.gameFormatName) &
            e.pickListPosition.isSmallerOrEqualValue(team.pickListPosition!) &
            e.pickListPosition.isBiggerThanValue(previous.pickListPosition!) &
            e.pickListPosition.isNotNull(),
      );
      await updateStatement.write(
        TeamsCompanion.custom(
          pickListPosition: db.teams.pickListPosition - Variable(1),
        ),
      );
    }

    db.update(db.teams).replace(team);
  }
}

@riverpod
class AnalysisCriterion extends _$AnalysisCriterion {
  @override
  int build() {
    return 0;
  }

  void set(int criterion) {
    state = criterion;
    ref.notifyListeners();
  }
}

@Riverpod(keepAlive: true)
class AnalysisView extends _$AnalysisView {
  @override
  int build() {
    return 0;
  }

  void set(int criterion) {
    state = criterion;
    ref.notifyListeners();
  }
}
