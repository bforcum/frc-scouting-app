import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/scouting_page/form_input/counter_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/dropdown_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/number_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/text_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/toggle_input.dart';
import 'package:scouting_app/provider/form_data_provider.dart';

class FormInput extends ConsumerWidget {
  final Question question;

  const FormInput({super.key, required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onChanged(dynamic value) {
      ref.read(currentFormDataProvider.notifier).setValue(question.key, value);
    }

    FormField formField = switch (question.type) {
      QuestionType.toggle => FormField<bool>(
        initialValue:
            ref
                .watch(currentFormDataProvider.notifier)
                .getValue(question.key) ??
            (question as QuestionToggle).preset ??
            false,
        builder:
            (formState) => ToggleInput(
              question: question as QuestionToggle,
              value: ref
                  .watch(currentFormDataProvider.notifier)
                  .getValue(question.key),
              onChanged: onChanged,
            ),
      ),
      QuestionType.counter => FormField<int>(
        initialValue: ref.watch(currentFormDataProvider).data[question.key],
        builder:
            (formState) => CounterInput(
              question: question as QuestionCounter,
              value: ref
                  .watch(currentFormDataProvider.notifier)
                  .getValue(question.key),
              onChanged: onChanged,
            ),
      ),
      QuestionType.number => FormField<int>(
        validator: (value) {
          QuestionNumber questionNumber = question as QuestionNumber;
          if (value == null) {
            return 'Please answer the question';
          }

          if ((questionNumber.min != null && value < questionNumber.min!) ||
              (questionNumber.min != null && value > questionNumber.max!)) {
            return 'Value must be between ${questionNumber.min} and ${questionNumber.max}';
          }
          return null;
        },
        initialValue: ref
            .watch(currentFormDataProvider.notifier)
            .getValue(question.key),
        builder:
            (formState) => NumberInput(
              initialValue:
                  ref.watch(currentFormDataProvider).data[question.key],
              question: question as QuestionNumber,
              onChanged: onChanged,
            ),
      ),
      QuestionType.dropdown => FormField<int>(
        builder:
            (formState) => DropdownInput(
              question: question as QuestionDropdown,
              onChanged: onChanged,
            ),
      ),
      QuestionType.text => FormField<String>(
        builder:
            (formState) => TextInput(
              initialValue:
                  ref.watch(currentFormDataProvider).data[question.key],
              question: question as QuestionText,
              onChanged: onChanged,
            ),
      ),
    };
    return formField;
  }
}
