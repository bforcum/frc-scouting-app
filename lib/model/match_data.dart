import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_data.freezed.dart';

@freezed
abstract class MatchDataModel with _$MatchDataModel {
  const factory MatchDataModel({
    required int teamNumber,
    required int matchNumber,
    required String gameFormatName,
    required String scoutName,
    required Map<String, dynamic> data,
  }) = _MatchDataModel;
}
