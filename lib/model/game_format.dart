import 'package:scouting_app/analysis/match_analysis.dart';
import 'package:scouting_app/analysis/match_analysis/match_analysis_2025.dart';
import 'package:scouting_app/analysis/match_analysis/match_analysis_2026.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';

enum GameFormat {
  v2026(
    id: 2,
    sections: _sections2026,
    questions: _questions2026,
    comments: _comments2026,
    analysis: MatchAnalysis2026.new,
    scoreOptions: MatchAnalysis2026.scoreOptions,
    criteriaOptions: MatchAnalysis2026.criteriaOptions,
  ),
  v2025(
    id: 1,
    sections: _sections2025,
    questions: _questions2025,
    comments: _comments2025,
    analysis: MatchAnalysis2025.new,
    scoreOptions: MatchAnalysis2025.scoreOptions,
    criteriaOptions: MatchAnalysis2025.criteriaOptions,
  ),
  v2024(
    id: 0,
    sections: _sections2024,
    questions: _questions2024,
    comments: _comments2024,
  );

  final int id;
  final List<String> sections;
  final List<Question> _questions;
  final QuestionText _comments;
  final MatchAnalysis Function(MatchResult)? analysis;
  final List<String>? scoreOptions;
  final List<String>? criteriaOptions;

  const GameFormat({
    required this.id,
    required this.sections,
    required List<Question> questions,
    required QuestionText comments,
    this.analysis,
    this.scoreOptions,
    this.criteriaOptions,
  }) : _questions = questions,
       _comments = comments;

  List<Question> get questions => [..._questions, _comments];
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
  QuestionToggle(section: 3, key: "groundPickup", label: "Ground Pickup"),
  QuestionToggle(section: 3, key: "moveShot", label: "Can shoot while moving"),
  QuestionToggle(section: 3, key: "disabled", label: "Disabled during match"),
];
const QuestionText _comments2026 = QuestionText(
  section: 3,
  key: "comments",
  label: "Notes",
  hint: "Additional Notes",
  length: 100,
  big: true,
);

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
];

const QuestionText _comments2025 = QuestionText(
  section: 3,
  key: "comments",
  label: "Notes",
  hint: "Additional Notes",
  length: 100,
  big: true,
);

const List<String> _sections2024 = [
  "Autonomous",
  "Tele-Op",
  "End-Game",
  "Additional",
];

const List<Question> _questions2024 = [
  QuestionToggle(key: "autoMove", section: 0, label: "Movement"),
  QuestionCounter(key: "autoSpeaker", section: 0, label: "Speaker Success"),
  QuestionCounter(key: "autoSpeakerMiss", section: 0, label: "Speaker Miss"),
  QuestionCounter(key: "autoPickup", section: 0, label: "Pickup Success"),
  QuestionCounter(key: "autoPickupMiss", section: 0, label: "Pickup Fail"),
  QuestionCounter(key: "autoAmp", section: 0, label: "Amp Success"),
  QuestionCounter(key: "autoAmpMiss", section: 0, label: "Amp Fail"),
  QuestionCounter(key: "speaker", section: 1, label: "Speaker Success"),
  QuestionCounter(key: "speakerMiss", section: 1, label: "Speaker Miss"),
  QuestionCounter(key: "amp", section: 1, label: "Amp Success"),
  QuestionCounter(key: "ampMiss", section: 1, label: "Amp Miss"),
  QuestionDropdown(
    section: 2,
    key: "end",
    label: "End Position",
    options: ["Park", "Hang", "Partner Hang"],
  ),
  QuestionCounter(
    section: 2,
    key: "human",
    label: "Spotlights (by this team)",
    min: 0,
    max: 3,
  ),
  QuestionToggle(section: 2, key: "trap", label: "Scored note in trap"),
];

const QuestionText _comments2024 = QuestionText(
  section: 3,
  key: "comments",
  label: "Notes",
  hint: "Additional Notes",
  length: 100,
  big: true,
);
