import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/scouting_page/form_input/counter_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/dropdown_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/number_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/text_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/toggle_input.dart';

interface class FormInput extends StatelessWidget {
  final Widget inputField;

  const FormInput._(this.inputField);

  factory FormInput.fromQuestion(Question question) {
    switch (question.type) {
      case QuestionType.toggle:
        return FormInput._(
          ToggleInput(key: UniqueKey(), question: question as QuestionToggle),
        );

      case QuestionType.counter:
        return FormInput._(
          CounterInput(key: UniqueKey(), question: question as QuestionCounter),
        );

      case QuestionType.dropdown:
        return FormInput._(
          DropdownInput(
            key: UniqueKey(),
            question: question as QuestionDropdown,
          ),
        );

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
