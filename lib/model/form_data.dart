import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';

part 'form_data.freezed.dart';

@freezed
abstract class FormDataModel with _$FormDataModel {
  const FormDataModel._();

  const factory FormDataModel(Map<String, dynamic> data) = _FormDataModel;

  factory FormDataModel.empty() {
    var emptyData = <String, dynamic>{};

    emptyData["teamNumber"] = null;
    emptyData["timeStamp"] = null;
    emptyData["matchNumber"] = null;
    emptyData["gameFormatName"] = null;
    emptyData["gameFormatName"] = null;

    for (var question in kGameFormat.questions) {
      emptyData[question.key] = null; // Initialize all questions to null
    }
    return FormDataModel(emptyData);
  }

  MatchResult? toMatchResult() {
    if (data["gameFormatName"] == null) return null;
    if (data["timeStamp"] == null) return null;
    for (var key in kRequiredQuestions.map((q) => q.key)) {
      if (!data.containsKey(key) || data[key] == null) {
        return null; // Ensure all questions are included
      }
    }

    for (var key in kGameFormat.questions.map((q) => q.key)) {
      if (!data.containsKey(key) || data[key] == null) {
        return null; // Ensure all questions are included
      }
    }
    return MatchResult.fromMap(data);
  }
}
