import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/scouting_page/form_input/counter_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/number_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/text_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/toggle_input.dart';

interface class FormInput extends StatelessWidget {
  final Widget inputField;

  const FormInput._(this.inputField);

  factory FormInput.fromQuestion(Question question) {
    switch (question.type) {
      case QuestionType.toggle:
        question = question as QuestionToggle;
        return FormInput._(ToggleInput(key: UniqueKey(), question: question));

      case QuestionType.counter:
        question = question as QuestionCounter;
        return FormInput._(CounterInput(key: UniqueKey(), question: question));

      case QuestionType.dropdown:
        throw UnimplementedError("Dropdown input not implemented yet.");

      case QuestionType.number:
        question = question as QuestionNumber;
        return FormInput._(NumberField(key: UniqueKey(), question: question));

      case QuestionType.text:
        question = question as QuestionText;
        return FormInput._(TextInput(key: UniqueKey(), question: question));
    }
  }

  @override
  Widget build(BuildContext context) {
    return inputField;
  }
}
