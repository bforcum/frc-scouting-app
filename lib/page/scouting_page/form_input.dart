import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/scouting_page/form_input/counter_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/number_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/text_input.dart';

enum FieldType { text, number, counter, dropdown, barSelect, toggle }

class CustomField extends StatelessWidget {
  final Widget inputField;
  final String label;

  const CustomField._(this.label, this.inputField);

  factory CustomField.fromQuestion(Question question) {
    switch (question.type) {
      case QuestionType.binary:
      case QuestionType.counter:
        question = question as QuestionCounter;
        return CustomField._(
          question.label,
          CounterInput(
            key: UniqueKey(),
            min: question.min,
            max: question.max,
            preset: question.preset,
          ),
        );
      case QuestionType.dropdown:
      case QuestionType.number:
        question = question as QuestionNumber;
        return CustomField._(
          question.label,
          NumberField(
            key: UniqueKey(),
            hintText: question.hint,
            min: question.min,
            max: question.max,
          ),
        );
      case QuestionType.text:
        question = question as QuestionText;
        return CustomField._(
          question.label,
          TextInput(
            key: UniqueKey(),
            hintText: question.hintText,
            maxLength: question.length,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 25)),
        Spacer(),
        inputField,
      ],
    );
  }
}
