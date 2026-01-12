import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

part 'statistics_provider.g.dart';

@riverpod
Future<List<TeamData>> teamStatistics(Ref ref) async {
  List<MatchResult> results = await ref.watch(storedResultsProvider.future);

  List<int> teamNumbers = [];
  List<List<MatchResult>> binnedResults = [];

  for (MatchResult result in results) {
    assert(teamNumbers.length == binnedResults.length);

    int teamNumber = result.teamNumber;
    int maybeIndex = teamNumbers.indexOf(teamNumber);

    // If the binned list doesn't contain this team number yet, add it
    if (maybeIndex < 0) {
      teamNumbers.add(teamNumber);
      binnedResults.add([result]);
      continue;
    }
    // Add the match result to its respective bin
    binnedResults[maybeIndex].add(result);
  }
  List<TeamData> stats = [];
  for (int i = 0; i < teamNumbers.length; i++) {
    stats.add(TeamData(binnedResults[i]));
  }
  return stats;
}
