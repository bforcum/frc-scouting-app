import 'package:scouting_app/analysis/match_analysis.dart';
import 'package:scouting_app/model/match_result.dart';

class MatchAnalysis2026v2 implements MatchAnalysis {
  MatchResult result;

  MatchAnalysis2026v2(this.result);

  @override
  // ignore: override_on_non_overriding_member
  static const List<String> scoreOptions = [
    "Hub",
    "Auto",
    "Tele",
    "Defense",
    "Climb",
  ];

  @override
  int getScore(int scoreOption) {
    assert(
      0 <= scoreOption && scoreOption < scoreOptions.length,
      "Option does not exist",
    );
    return switch (scoreOption) {
      0 => getScore(1) + getScore(2),
      1 =>
        ((result.data["autoCycleSize"] as int) *
                ((result.data["autoCycleFull"] as int) +
                    0.5 * (result.data["autoCycleHalf"] as int) +
                    0.2 * (result.data["autoCycleSmall"] as int)) *
                ([0.2, 0.4, 0.6, 0.8, 0.9][result.data["autoAccuracy"]]))
            .round(),
      2 =>
        <double>[
          for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++)
              result.data["teleHubCycles"][3 * i + j] *
                  result.data["teleCycleSize"] *
                  [1, 0.5, 0.2][i] * // Hopper amount
                  [0.9, 0.6, 0.3][j], // Accuracy
        ].reduce((a, b) => a + b).round(),
      3 =>
        result.data["defBlock"] * 5 +
            result.data["defPush"] * 4 +
            result.data["defPass"] * 4 +
            result.data["defCollect"] * 2 +
            result.data["defFuelPush"] * 2,
      4 => (result.data["autoClimb"] ? 15 : 0) + result.data["climb"] * 10,
      _ => 0,
    };
  }

  @override
  // ignore: override_on_non_overriding_member
  static const List<String> criteriaOptions = [
    "Ground Pickup",
    "Moving Shot",
    "Auto Climb",
    "Climb 1+",
    "Climb 2+",
    "Climb 3",
    "Stayed enabled",
  ];

  @override
  bool getCriterion(int criterion) {
    return switch (criterion) {
      0 => result.data["groundPickup"],
      1 => result.data["moveShot"],
      2 => result.data["autoClimb"],
      3 => result.data["climb"] >= 1 || result.data["autoClimb"],
      4 => result.data["climb"] >= 2,
      5 => result.data["climb"] == 3,
      6 => !result.data["disabled"],
      _ => false,
    };
  }
}
