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

  factory FormInput.fromQuestion(
    Question question, {
    Function(dynamic)? onChanged,
  }) {
    switch (question.type) {
      case QuestionType.toggle:
        return FormInput._(
          ToggleInput(
            key: UniqueKey(),
            question: question as QuestionToggle,
            onChanged: onChanged,
          ),
        );

      case QuestionType.counter:
        return FormInput._(
          CounterInput(
            key: UniqueKey(),
            question: question as QuestionCounter,
            onChanged: onChanged,
          ),
        );

      case QuestionType.dropdown:
        return FormInput._(
          DropdownInput(
            key: UniqueKey(),
            question: question as QuestionDropdown,
            onChanged: onChanged,
          ),
        );

      case QuestionType.number:
        question = question as QuestionNumber;
        return FormInput._(
          NumberField(
            key: UniqueKey(),
            question: question,
            onChanged: onChanged,
          ),
        );

      case QuestionType.text:
        return FormInput._(
          TextInput(
            key: UniqueKey(),
            question: question as QuestionText,
            onChanged: onChanged,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return inputField;
  }
}
