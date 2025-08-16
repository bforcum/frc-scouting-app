import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/question.dart';

const double kBorderRadius = 10;

const int kMaxTeamNumber = 12000;

final kGameFormat = kGame2025;

final kGame2025 = GameFormat(
  sections: ["Autonomous", "Tele-Op", "End Game", "Additional"],
  questions: [
    QuestionCounter(
      section: 0,
      label: "Coral L4",
      min: 0,
      max: 12,
      pointVal: (n) => 7 * n,
    ),
    QuestionCounter(
      section: 0,
      label: "Coral L3",
      min: 0,
      max: 12,
      pointVal: (n) => 6 * n,
    ),
    QuestionCounter(
      section: 0,
      label: "Coral L2",
      min: 0,
      max: 12,
      pointVal: (n) => 4 * n,
    ),
    QuestionCounter(
      section: 0,
      label: "Coral L1",
      min: 0,
      max: 12,
      pointVal: (n) => 3 * n,
    ),
    QuestionCounter(
      section: 1,
      label: "Coral L4",
      min: 0,
      max: 12,
      pointVal: (n) => 5 * n,
    ),
    QuestionCounter(
      section: 1,
      label: "Coral L3",
      min: 0,
      max: 12,
      pointVal: (n) => 4 * n,
    ),
    QuestionCounter(
      section: 1,
      label: "Coral L2",
      min: 0,
      max: 12,
      pointVal: (n) => 3 * n,
    ),
    QuestionCounter(
      section: 1,
      label: "Coral L1",
      min: 0,
      max: 12,
      pointVal: (n) => 2 * n,
    ),
  ],
);
