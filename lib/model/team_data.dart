import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';

class TeamData {
  int teamNumber;
  List<int> autoScores;
  List<int> teleScores;
  List<int> otherScores;
  List<int> totalScores;
  Map<String, bool> scoringLocations = {};

  TeamData({
    required this.teamNumber,

    required this.autoScores,
    required this.teleScores,
    required this.otherScores,
    required this.totalScores,
    required this.scoringLocations,
  });

  factory TeamData.fromList(List<MatchResult> results) {
    List<int> autoScores = [];
    List<int> teleScores = [];
    List<int> otherScores = [];
    List<int> totalScores = [];
    Map<String, bool> scoringLocations = {};

    assert(results.isNotEmpty, "The MatchResult list must contain results");

    int teamNumber = results[0].teamNumber;

    for (int i = 0; i < results.length; i++) {
      MatchResult result = results[i];
      GameFormat gameFormat = kSupportedGameFormats.firstWhere(
        (format) => format.name == result.gameFormatName,
      );
      assert(
        result.teamNumber == teamNumber,
        "Team number was $teamNumber but result #$i was ${result.teamNumber}",
      );
      autoScores.add(result.getAutoScore());
      teleScores.add(result.getTeleScore());
      otherScores.add(result.getOtherScore());
      totalScores.add(result.getTotalScore());

      var locations = gameFormat.getScoringLocations(result);

      for (var location in locations.entries) {
        scoringLocations.update(
          location.key,
          (current) => current || location.value,
          ifAbsent: () => location.value,
        );
      }
    }

    return TeamData(
      teamNumber: teamNumber,
      autoScores: autoScores,
      teleScores: teleScores,
      otherScores: otherScores,
      totalScores: totalScores,
      scoringLocations: scoringLocations,
    );
  }
}
