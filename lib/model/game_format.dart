import 'package:scouting_app/analysis/match_analysis.dart';
import 'package:scouting_app/analysis/match_analysis/match_analysis_2025.dart';
import 'package:scouting_app/analysis/match_analysis/match_analysis_2026.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/model/team_data.dart';

enum GameFormat {
  v2025,
  v2026;

  const GameFormat();

  List<String> get sections => switch (this) {
    v2025 => _sections2025,
    v2026 => _sections2026,
  };

  List<Question> get questions => switch (this) {
    v2025 => _questions2025,
    v2026 => _questions2026,
  };

  MatchAnalysis analysis(MatchResult result) => switch (this) {
    GameFormat.v2025 => MatchAnalysis2025(result),
    GameFormat.v2026 => MatchAnalysis2026(result),
  };

  List<String> get scoreOptions {
    return switch (this) {
      GameFormat.v2025 => MatchAnalysis2025.scoreOptions,
      GameFormat.v2026 => MatchAnalysis2026.scoreOptions,
    };
  }

  List<String> get criteriaOptions {
    return switch (this) {
      GameFormat.v2025 => MatchAnalysis2025.criteriaOptions,
      GameFormat.v2026 => MatchAnalysis2026.criteriaOptions,
    };
  }
}

class GameQuestions {
  final GameFormat gameFormat;

  final List<String> sections;

  final List<Question> questions;

  final int Function(MatchResult) autoScore;
  final int Function(MatchResult) teleScore;
  final int Function(MatchResult) endScore;

  final List<String> scoringLocations;
  final Map<String, bool> Function(MatchResult) getScoringLocations;

  final List<AnalysisScore> analysisOptions;
  GameQuestions({
    required this.gameFormat,
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

const List<String> _sections2026 = [
  "Autonomous",
  "Defense",
  "Offense",
  "End-Game, Additional",
];
const List<Question> _questions2026 = [
  QuestionCounter(section: 0, key: "autoFuel", label: "Auto Fuel"),
  QuestionToggle(section: 0, key: "autoClimbAttempt", label: "Climb Attempted"),
  QuestionToggle(section: 0, key: "autoClimb", label: "Climb Success"),
  QuestionCounter(section: 2, key: "cycleSize", label: "Fuel per cycle"),
  QuestionCounter(section: 2, key: "cycles", label: "Number of cycles"),
  QuestionDropdown(
    section: 2,
    key: "accuracy",
    label: "Accuracy",
    options: [
      "Most miss",
      "Majority miss",
      "Half and half",
      "Majority succeed",
      "Most succeed",
    ],
  ),
  QuestionDropdown(
    section: 2,
    key: "offPass",
    label: "Passing",
    options: ["None", "Some", "Lots"],
  ),
  QuestionDropdown(
    section: 1,
    key: "aggression",
    label: "Aggression",
    options: ["None", "Blocking", "Pushing", "Ramming"],
  ),
  QuestionDropdown(
    section: 1,
    key: "defPass",
    label: "Passing",
    options: ["None", "Some", "Lots"],
  ),
  QuestionCounter(
    section: 3,
    key: "climb",
    label: "Climb level",
    min: 0,
    max: 3,
  ),
  QuestionText(section: 3, key: "notes", label: "Notes", length: 100),
];

const List<String> _sections2025 = [
  "Autonomous",
  "Tele-Op",
  "End Game",
  "Additional",
];
const List<Question> _questions2025 = [
  QuestionToggle(key: "autoMove", section: 0, label: "Movement"),
  QuestionCounter(
    key: "autoL4",
    section: 0,
    label: "Coral L4",
    min: 0,
    max: 12,
  ),
  QuestionCounter(
    key: "autoL3",
    section: 0,
    label: "Coral L3",
    min: 0,
    max: 12,
  ),
  QuestionCounter(
    key: "autoL2",
    section: 0,
    label: "Coral L2",
    min: 0,
    max: 12,
  ),
  QuestionCounter(
    key: "autoL1",
    section: 0,
    label: "Coral L1",
    min: 0,
    max: 12,
  ),
  QuestionCounter(
    key: "teleL4",
    section: 1,
    label: "Coral L4",
    min: 0,
    max: 12,
  ),
  QuestionCounter(
    key: "teleL3",
    section: 1,
    label: "Coral L3",
    min: 0,
    max: 12,
  ),
  QuestionCounter(
    key: "teleL2",
    section: 1,
    label: "Coral L2",
    min: 0,
    max: 12,
  ),
  QuestionCounter(
    key: "teleL1",
    section: 1,
    label: "Coral L1",
    min: 0,
    max: 12,
  ),
  QuestionToggle(key: "defense", section: 2, label: "Played defense?"),
  QuestionDropdown(
    key: "endAttempt",
    section: 2,
    label: "End attempt",
    options: ["None", "Park", "High Cage", "Low Cage"],
  ),
  QuestionDropdown(
    key: "endResult",
    section: 2,
    label: "End result",
    options: ["None", "Park", "High Cage", "Low Cage"],
  ),
  QuestionText(
    key: "notes",
    section: 3,
    label: "Notes",
    length: 50,
    hint: "Additional notes",
    big: true,
  ),
];
