import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/question.dart';

const double kBorderRadius = 10;

const int kMaxTeamNumber = 12000;

final kGameFormat = kGame2025;

final kGame2025 = GameFormat(
  name: "2025",
  sections: ["Autonomous", "Tele-Op", "End Game", "Additional"],
  questions: [
    QuestionCounter(
      key: "autoL4",
      section: 0,
      label: "Coral L4",
      min: 0,
      max: 12,
      pointVal: (n) => 7 * n,
    ),
    QuestionCounter(
      key: "autoL3",
      section: 0,
      label: "Coral L3",
      min: 0,
      max: 12,
      pointVal: (n) => 6 * n,
    ),
    QuestionCounter(
      key: "autoL2",
      section: 0,
      label: "Coral L2",
      min: 0,
      max: 12,
      pointVal: (n) => 4 * n,
    ),
    QuestionCounter(
      key: "autoL1",
      section: 0,
      label: "Coral L1",
      min: 0,
      max: 12,
      pointVal: (n) => 3 * n,
    ),
    QuestionCounter(
      key: "teleL4",
      section: 1,
      label: "Coral L4",
      min: 0,
      max: 12,
      pointVal: (n) => 5 * n,
    ),
    QuestionCounter(
      key: "teleL3",
      section: 1,
      label: "Coral L3",
      min: 0,
      max: 12,
      pointVal: (n) => 4 * n,
    ),
    QuestionCounter(
      key: "teleL2",
      section: 1,
      label: "Coral L2",
      min: 0,
      max: 12,
      pointVal: (n) => 3 * n,
    ),
    QuestionCounter(
      key: "teleL1",
      section: 1,
      label: "Coral L1",
      min: 0,
      max: 12,
      pointVal: (n) => 2 * n,
    ),
  ],
);
