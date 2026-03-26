import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/provider/form_field_provider.dart';

class FormInput extends ConsumerWidget {
  final Question question;

  const FormInput({super.key, required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(formFieldNotifierProvider(question.key));
    void onChanged(dynamic value) {
      ref
          .read(formFieldNotifierProvider(question.key).notifier)
          .setValue(value);
    }

    ref.listen(formResetProvider, (previous, next) {
      (context as Element).markNeedsBuild(); // Force rebuild when form is reset
    });
    Key fieldKey = ValueKey(ref.watch(formResetProvider));

    FormField formField = createFormField(
      context: context,
      fieldKey: fieldKey,
      question: question,
      value: value,
      onChanged: onChanged,
    );
    return formField;
  }
}

FormField createFormField({
  required BuildContext context,
  Key? fieldKey,
  required Question question,
  required dynamic value,
  required Function(dynamic value) onChanged,
}) {
  return FormField(
    key: fieldKey,
    initialValue: value ?? question.preset,
    validator: (value) => question.validator(value, onChanged),
    builder:
        (formState) => question.input(
          context: context,
          value: value,
          onChanged: (value) {
            onChanged(value);
            formState.didChange(value);
            if (formState.hasError) {
              formState.validate();
            }
          },
          errorText: formState.errorText,
        ),
  );
}
