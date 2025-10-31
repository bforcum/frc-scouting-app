import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';

class GameFormat {
  final String name;

  final List<String> sections;

  final List<Question> questions;

  final int Function(MatchResult) autoScore;
  final int Function(MatchResult) teleScore;
  final int Function(MatchResult) otherScore;

  final List<String> scoringLocations;
  final Map<String, bool> Function(MatchResult) getScoringLocations;

  GameFormat({
    required this.name,
    required this.sections,
    required this.questions,
    required this.autoScore,
    required this.teleScore,
    required this.otherScore,
    required this.scoringLocations,
    required this.getScoringLocations,
  });
}
