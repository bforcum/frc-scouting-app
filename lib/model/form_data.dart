import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_data.dart';

part 'form_data.freezed.dart';

@freezed
abstract class FormDataModel with _$FormDataModel {
  const FormDataModel._();

  const factory FormDataModel({required Map<String, dynamic> data}) =
      _FormDataModel;

  factory FormDataModel.empty() {
    var emptyData = <String, dynamic>{};

    for (var question in kRequiredQuestions) {
      emptyData[question.key] = null; // Initialize required questions to null
    }

    for (var question in kGameFormat.questions) {
      emptyData[question.key] = null; // Initialize all questions to null
    }
    return FormDataModel(data: emptyData);
  }

  MatchDataModel? toMatchData() {
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

    return MatchDataModel(
      teamNumber: int.parse(data["teamNumber"]!),
      matchNumber: int.parse(data["matchNumber"]!),
      gameFormatName: data["gameFormatName"]!,
      scoutName: data["scoutName"]!,
      data: data,
    );
  }
}
