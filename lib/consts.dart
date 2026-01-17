import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/question.dart';
import 'package:statistics/statistics.dart';

const double kBorderRadius = 10;

final kGameFormat = kGame2025;

final String kEventName = "WASAM";

final String kDbName = "scouting_app";

final List<GameFormat> kSupportedGameFormats = [kGame2025];

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
];

final kGame2026v1 = GameFormat(
  name: "2026v1",
  autoScore:
      (result) => result.data["autoFuel"] + result.data["autoClimb"] * 15,
  teleScore: (result) => result.data["perCycle"],
  endScore: (result) => result.data["climb"] * 10,
  sections: ["Autonomous", "Tele-Op Scoring", "Defense", "End Game", "Other"],
  analysisOptions: [
    AnalysisScore(
      label: "Average Score",
      score: (data) => data.totalScores.average.round(),
    ),
    AnalysisScore(
      label: "Pessimistic Score",
      score:
          (data) =>
              (data.totalScores.average - data.totalScores.standardDeviation)
                  .round(),
    ),
    AnalysisScore(
      label: "Score + Defense",
      score:
          (data) =>
              (data.totalScores.average +
                      (data.results.map((e) => e.data["defense"] * 10).toList()
                              as List<int>)
                          .average)
                  .round(),
    ),
  ],
  scoringLocations: [
    "groundPickup",
    "humanPickup",
    "autoClimb",
    "climb1",
    "climb2",
    "climb3",
  ],
  getScoringLocations:
      (result) => <String, bool>{
        "groundPickup": result.data["groundPickup"],
        "humanPickup": result.data["groundPickup"],
        "autoClimb": result.data["autoClimb"],
        "climb1": result.data["climb"] >= 1 || result.data["autoClimb"],
        "climb2": result.data["climb"] >= 2,
        "climb3": result.data["climb"] == 3,
      },
  questions: [
    /*
    auto scored (counter)
    auto climb (bool)
    climb (dropdown)
    tele scored per cycle

     */
  ],
);

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
      "highCage": result.data["endResult"] == 2,
      "lowCage": result.data["endResult"] == 3,
    };
  },
  analysisOptions: [
    AnalysisScore(
      label: "Total Score",
      score: (data) => data.totalScores.average.round(),
    ),
    AnalysisScore(
      label: "Pessimistic Score",
      score:
          (data) =>
              (data.totalScores.average - data.totalScores.standardDeviation)
                  .round(),
    ),
    AnalysisScore(
      label: "Auto Score",
      score: (data) => data.autoScores.average.round(),
    ),
  ],

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
      hint: "Enter any additional notes here",
      multiline: true,
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
