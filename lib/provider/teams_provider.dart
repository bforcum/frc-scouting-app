import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
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

@riverpod
class TeamsList extends _$TeamsList {
  @override
  Future<List<TeamData>> build(String eventCode) async {
    SettingsModel settings = ref.watch(settingsProvider);
    GameFormat gameFormat = settings.gameFormat;

    List<MatchResult> results = await ref.watch(
      FilteredResultsProvider(
        gameFormat: gameFormat,
        eventCode: eventCode,
      ).future,
    );
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
        .filter((e) => e.gameFormat.equals(gameFormat.id))
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
              eventCode: Value(eventCode),
              gameFormat: Value(gameFormat.id),
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
                .filter((e) => e.gameFormat.equals(gameFormat.id))
                .orderBy((o) => o.pickListPosition.asc(nulls: NullsOrder.last))
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

  Future addToList({
    required int team,
    required String eventCode,
    required GameFormat format,
  }) async {
    AppDatabase db = ref.read(databaseProvider);
    final int size =
        (await db.managers.teams
                .filter((f) => f.pickListPosition.isNotNull())
                .get())
            .length;
    db.managers.teams.replace(
      Team(
        teamNumber: team,
        eventCode: eventCode,
        gameFormat: format.id,
        pickListPosition: size,
      ),
    );
    ref.invalidateSelf();
  }

  Future<void> move(Team team) async {
    AppDatabase db = ref.read(databaseProvider);
    Team previous =
        await db.managers.teams
            .filter((e) => e.gameFormat.equals(team.gameFormat))
            .filter((e) => e.teamNumber.equals(team.teamNumber))
            .getSingle();

    if (previous.pickListPosition == team.pickListPosition) return;

    final updateStatement = db.update(db.teams);
    if (previous.pickListPosition == null) {
      updateStatement.where(
        (e) =>
            e.gameFormat.equals(team.gameFormat) &
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
            e.gameFormat.equals(team.gameFormat) &
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
            e.gameFormat.equals(team.gameFormat) &
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
            e.gameFormat.equals(team.gameFormat) &
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
    ref.invalidateSelf();
  }

  /// Orders team numbers based on a new pick list order
  Future order(
    GameFormat gameFormat,
    String eventCode,
    List<int> teamNumbers,
  ) async {
    AppDatabase db = ref.read(databaseProvider);
    // Clear existing positions
    db.managers.teams.update((e) => e(pickListPosition: Value(null)));

    // get team numbers that actually exist
    Iterable<int> realTeamNumbers = (await db.managers.teams
            .filter((e) => e.gameFormat.equals(gameFormat.id))
            .filter((e) => e.eventCode.equals(eventCode))
            .get())
        .map((team) => team.teamNumber);
    // Filter provided teamNumbers to only those with data and assign it to realTeamNumbers
    realTeamNumbers = teamNumbers.where(
      (team) => realTeamNumbers.contains(team),
    );
    // Update teams table
    await db.managers.teams.bulkReplace(
      teamNumbers.mapIndexed(
        (int i, int team) => Team(
          teamNumber: team,
          eventCode: eventCode,
          gameFormat: gameFormat.id,
          pickListPosition: i,
        ),
      ),
    );
    ref.invalidateSelf();
  }
}
