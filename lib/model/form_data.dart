import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';

part 'form_data.freezed.dart';

@freezed
abstract class FormDataModel with _$FormDataModel {
  const FormDataModel._();

  const factory FormDataModel(Map<String, dynamic> data) = _FormDataModel;

  MatchResult? toMatchResult() {
    if (data["gameFormat"] is! GameFormat) return null;
    if (data["timeStamp"] is! DateTime) return null;
    if (data["teamNumber"] is! int) return null;
    if (data["matchNumber"] is! int) return null;
    if (data["eventName"] is! String) return null;
    if (data["scoutName"] is! String) return null;
    GameFormat gameFormat = data["gameFormat"];
    for (var key in gameFormat.questions.map((q) => q.key)) {
      if (!data.containsKey(key) || data[key] == null) {
        return null; // Ensure all questions are included
      }
    }
    return MatchResult.fromMap(data);
  }
}
