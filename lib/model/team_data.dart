import 'package:scouting_app/analysis/match_analysis.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';

class TeamData {
  int teamNumber;

  List<MatchResult> results;
  List<List<int>> scores;
  List<bool> criteria;

  TeamData._({
    required this.teamNumber,

    required this.results,
    required this.scores,
    required this.criteria,
  });

  factory TeamData(List<MatchResult> results) {
    assert(results.isNotEmpty, "The MatchResult list must contain results");

    int teamNumber = results[0].teamNumber;
    GameFormat format = results[0].gameFormat;
    int numScoreOptions = format.scoreOptions!.length;
    int numCriteriaOptions = format.criteriaOptions!.length;
    List<List<int>> scores = List.generate(
      numScoreOptions,
      (idx) => List<int>.empty(growable: true),
    );
    List<bool> criteria = List.filled(numCriteriaOptions, false);

    for (int i = 0; i < results.length; i++) {
      assert(results[i].gameFormat == format);

      MatchAnalysis? analysis = results[i].analysis;

      for (int j = 0; j < numScoreOptions; j++) {
        scores[j].add(analysis!.getScore(j));
      }
      for (int j = 0; j < numCriteriaOptions; j++) {
        criteria[j] |= analysis!.getCriterion(j);
      }
    }

    return TeamData._(
      results: results,
      teamNumber: teamNumber,
      scores: scores,
      criteria: criteria,
    );
  }
}
