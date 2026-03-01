import 'package:scouting_app/analysis/match_analysis.dart';
import 'package:scouting_app/model/match_result.dart';

class MatchAnalysis2026 implements MatchAnalysis {
  MatchResult result;

  MatchAnalysis2026(this.result);

  @override
  // ignore: override_on_non_overriding_member
  static const List<String> scoreOptions = [
    "Auto",
    "Approx Hub",
    "Offense",
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
      0 => result.data["autoFuel"] + (result.data["autoClimb"] ? 15 : 0),
      1 =>
        ((result.data["cycles"] as int) *
                (result.data["cycleSize"] as int) *
                (result.data["accuracy"] * 0.2 + 0.1))
            .round(),
      2 => result.data["autoFuel"] + getScore(1),
      3 => result.data["aggression"] * 10 + result.data["defPass"] * 10,
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
