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

    ref.listen(formResetProvider, (previous, next) {
      (context as Element).markNeedsBuild(); // Force rebuild when form is reset
    });
    Key fieldKey = ValueKey(ref.watch(formResetProvider));

    FormField formField = switch (question.type) {
      QuestionType.toggle => FormField<bool>(
        key: fieldKey,
        initialValue:
            ref.watch(currentFormDataProvider).data[question.key] ??
            (question as QuestionToggle).preset ??
            false,
        builder:
            (formState) => ToggleInput(
              question: question as QuestionToggle,
              value: ref.watch(currentFormDataProvider).data[question.key],
              onChanged: (value) {
                onChanged(value);
                formState.didChange(value);
                if (formState.hasError) {
                  formState.validate();
                }
              },
            ),
      ),
      QuestionType.counter => FormField<int>(
        key: fieldKey,
        initialValue: ref.watch(currentFormDataProvider).data[question.key],
        builder:
            (formState) => CounterInput(
              question: question as QuestionCounter,
              value: ref.watch(currentFormDataProvider).data[question.key],
              onChanged: (value) {
                onChanged(value);
                formState.didChange(value);
                if (formState.hasError) {
                  formState.validate();
                }
              },
            ),
      ),
      QuestionType.number => FormField<int>(
        key: fieldKey,
        validator: (value) {
          QuestionNumber questionNumber = question as QuestionNumber;
          if (value == null) {
            return 'Please answer the question';
          }

          if ((questionNumber.min != null && value < questionNumber.min!) ||
              (questionNumber.max != null && value > questionNumber.max!)) {
            return 'Value must be between ${questionNumber.min} and ${questionNumber.max}';
          }
          return null;
        },
        initialValue: ref.watch(currentFormDataProvider).data[question.key],
        builder:
            (formState) => NumberInput(
              initialValue:
                  ref.watch(currentFormDataProvider).data[question.key],
              formState: formState,
              question: question as QuestionNumber,
              onChanged: (value) {
                onChanged(value);
                formState.didChange(value);
                if (formState.hasError) {
                  formState.validate();
                }
              },
            ),
      ),
      QuestionType.dropdown => FormField<int>(
        key: fieldKey,
        validator: (value) {
          if (value == null) {
            return 'Please select an option';
          }
          return null;
        },
        initialValue: ref.watch(currentFormDataProvider).data[question.key],
        builder:
            (formState) => DropdownInput(
              question: question as QuestionDropdown,
              formState: formState,
              onChanged: (value) {
                onChanged(value);
                if (formState.hasError) {
                  formState.validate();
                }
              },
            ),
      ),
      QuestionType.text => FormField<String>(
        key: fieldKey,
        validator: (value) {
          if ((value == null || value == "") &&
              (question as QuestionText).requiredField) {
            return 'Please respond to the question';
          }
          return null;
        },
        initialValue: ref.watch(currentFormDataProvider).data[question.key],
        builder:
            (formState) => TextInput(
              initialValue:
                  ref.watch(currentFormDataProvider).data[question.key],
              formState: formState,
              question: question as QuestionText,
              onChanged: (value) {
                onChanged(value);
                formState.didChange(value);
                if (formState.hasError) {
                  formState.validate();
                }
              },
            ),
      ),
    };
    return formField;
  }
}
