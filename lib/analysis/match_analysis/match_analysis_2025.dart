import 'package:scouting_app/analysis/match_analysis.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';

class MatchAnalysis2025 implements MatchAnalysis {
  static const GameFormat gameFormat = GameFormat.v2025;
  final MatchResult result;

  MatchAnalysis2025(this.result);

  @override
  // ignore: override_on_non_overriding_member
  static List<String> scoreOptions = ["Auto Score", "Tele Score", "End Score"];

  @override
  int getScore(int scoreOption) {
    assert(
      0 <= scoreOption && scoreOption < scoreOptions.length,
      "Option does not exist",
    );
    return switch (scoreOption) {
      0 =>
        result.data["autoL4"] * 7 +
            result.data["autoL3"] * 6 +
            result.data["autoL2"] * 4 +
            result.data["autoL1"] * 3,
      1 =>
        result.data["teleL4"] * 5 +
            result.data["teleL3"] * 4 +
            result.data["teleL2"] * 3 +
            result.data["teleL1"] * 2,
      2 => [0, 2, 6, 12][result.data["endResult"]],
      _ => 0,
    };
  }

  @override
  // ignore: override_on_non_overriding_member
  static const List<String> criteriaOptions = [
    "L1",
    "L2",
    "L3",
    "L4",
    "Shallow Cage",
    "Deep Cage",
    "Auto Move",
    "Auto Score",
  ];

  @override
  bool getCriterion(int criterion) {
    assert(
      0 <= criterion && criterion < criteriaOptions.length,
      "Criterion does not exist",
    );
    return switch (criterion) {
      0 => result.data["teleL4"] + result.data["autoL4"] > 0,
      1 => result.data["teleL4"] + result.data["autoL4"] > 0,
      2 => result.data["teleL4"] + result.data["autoL4"] > 0,
      3 => result.data["teleL4"] + result.data["autoL4"] > 0,
      4 => result.data["endResult"] == 2,
      5 => result.data["endResult"] == 3,
      6 => result.data["autoMove"],
      7 =>
        result.data["autoL1"] > 0 ||
            result.data["autoL3"] > 0 ||
            result.data["autoL3"] > 0 ||
            result.data["autoL4"] > 0,
      _ => false,
    };
  }
}
