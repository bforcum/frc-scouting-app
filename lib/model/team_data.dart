import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';

class TeamData {
  int teamNumber;
  List<int> autoScores;
  List<int> teleScores;
  List<int> endScores;
  List<int> totalScores;
  Map<String, bool> scoringLocations = {};

  TeamData({
    required this.teamNumber,

    required this.autoScores,
    required this.teleScores,
    required this.endScores,
    required this.totalScores,
    required this.scoringLocations,
  });

  factory TeamData.fromList(List<MatchResult> results) {
    List<int> autoScores = [];
    List<int> teleScores = [];
    List<int> endScores = [];
    List<int> totalScores = [];
    Map<String, bool> scoringLocations = {};

    assert(results.isNotEmpty, "The MatchResult list must contain results");

    int teamNumber = results[0].teamNumber;

    for (int i = 0; i < results.length; i++) {
      MatchResult result = results[i];
      GameFormat gameFormat = kSupportedGameFormats.firstWhere(
        (format) => format.name == result.gameFormatName,
      );
      autoScores.add(result.getAutoScore());
      teleScores.add(result.getTeleScore());
      endScores.add(result.getEndScore());
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
      endScores: endScores,
      totalScores: totalScores,
      scoringLocations: scoringLocations,
    );
  }
}
