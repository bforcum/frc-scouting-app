import 'package:collection/collection.dart';
import 'package:scouting_app/analysis/match_analysis.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';

class TeamData {
  final int teamNumber;
  final GameFormat gameFormat;
  final int? position;

  final List<MatchResult> results;
  final List<List<int>> scores;
  final List<bool> criteria;

  TeamData._({
    required this.teamNumber,
    required this.gameFormat,
    this.position,
    required this.results,
    required this.scores,
    required this.criteria,
  });

  factory TeamData({int? position, required List<MatchResult> results}) {
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
      gameFormat: format,
      position: position,
      scores: scores,
      criteria: criteria,
    );
  }

  static int Function(TeamData, TeamData) sort(int? sortBy, bool ascending) {
    return sortBy == null
        ? (ascending
            ? (team1, team2) => team1.teamNumber.compareTo(team2.teamNumber)
            : (team1, team2) => team2.teamNumber.compareTo(team1.teamNumber))
        : (ascending
            ? (team1, team2) => team1.scores[sortBy].average.compareTo(
              team2.scores[sortBy].average,
            )
            : (team1, team2) => (team2.scores[sortBy].average.compareTo(
              team1.scores[sortBy].average,
            )));
  }
}
