import 'package:flutter/material.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/question.dart';

const double kBorderRadius = 10;

final kGameFormat = kGame2025;

final String kEventName = "2025W2WASAM";

final String kDbName = "scouting_app";

final bool incrementMatchNumber = true;

final List<GameFormat> kSupportedGameFormats = [kGame2025];

const Brightness kBrightness = Brightness.dark;

final List<Question> kRequiredQuestions = [
  QuestionNumber(
    key: "teamNumber",
    section: 0,
    label: "Team number",
    hint: "0000",
  ),
  QuestionNumber(
    key: "matchNumber",
    section: 0,
    label: "Match number",
    hint: "0",
    min: 1,
    max: 100,
  ),
  QuestionText(
    key: "scoutName",
    section: 0,
    label: "Scout name",
    length: 30,
    hint: "Full name",
    requiredField: true,
  ),
];

final kGame2025 = GameFormat(
  name: "2025",
  autoScore:
      (result) =>
          result.data["autoL4"] * 7 +
          result.data["autoL3"] * 6 +
          result.data["autoL2"] * 4 +
          result.data["autoL1"] * 3,
  teleScore:
      (result) =>
          result.data["teleL4"] * 5 +
          result.data["teleL3"] * 4 +
          result.data["teleL2"] * 3 +
          result.data["teleL1"] * 2,
  endScore: (result) {
    // Select a point value from the list based on the total value
    return [0, 2, 6, 12][result.data["endResult"]];
  },
  scoringLocations: ["L4", "L3", "L2", "L1", "deepCage", "shallowCage"],
  getScoringLocations: (result) {
    return <String, bool>{
      "L4": result.data["teleL4"] + result.data["autoL4"] > 0,
      "L3": result.data["teleL4"] + result.data["autoL4"] > 0,
      "L2": result.data["teleL4"] + result.data["autoL4"] > 0,
      "L1": result.data["teleL4"] + result.data["autoL4"] > 0,
      "deepCage": result.data["endResult"] == 3,
      "shallowCage": result.data["endResult"] == 2,
    };
  },

  sections: ["Autonomous", "Tele-Op", "End Game", "Additional"],
  questions: [
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
    QuestionText(
      key: "notes",
      section: 3,
      label: "Notes",
      length: 150,
      hint: "Enter any additional notes here",
      multiline: true,
    ),
    QuestionToggle(key: "defense", section: 2, label: "Played defense?"),
    QuestionDropdown(
      key: "endAttempt",
      section: 2,
      label: "Endgame attempt",
      options: ["None", "Park", "High Cage", "Low Cage"],
    ),
    QuestionDropdown(
      key: "endResult",
      section: 2,
      label: "Endgame result",
      options: ["None", "Park", "High Cage", "Low Cage"],
    ),
  ],
);

final kButtonStyle = ButtonStyle(
  padding: WidgetStatePropertyAll(const EdgeInsets.all(0)),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  alignment: Alignment.center,
);
