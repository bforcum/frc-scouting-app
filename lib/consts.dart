import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

const double kBorderRadius = 10;

final String kDbName = "scouting_app";

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

final kButtonStyle = ButtonStyle(
  padding: WidgetStatePropertyAll(const EdgeInsets.all(0)),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  alignment: Alignment.center,
);
