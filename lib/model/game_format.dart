import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/model/team_data.dart';

class GameFormat {
  final String name;

  final List<String> sections;

  final List<Question> questions;

  final int Function(MatchResult) autoScore;
  final int Function(MatchResult) teleScore;
  final int Function(MatchResult) endScore;

  final List<String> scoringLocations;
  final Map<String, bool> Function(MatchResult) getScoringLocations;

  final List<AnalysisScore> analysisOptions;
  GameFormat({
    required this.name,
    required this.sections,
    required this.questions,
    required this.autoScore,
    required this.teleScore,
    required this.endScore,
    required this.scoringLocations,
    required this.getScoringLocations,
    required this.analysisOptions,
  });
}

class AnalysisScore {
  final String label;

  final int Function(TeamData) score;

  const AnalysisScore({required this.label, required this.score});
}
