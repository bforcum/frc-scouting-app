import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/scouting_page/form_input.dart';

class FormEditInput extends ConsumerWidget {
  final dynamic value;
  final Question question;
  final Function(dynamic value) onChanged;
  const FormEditInput({
    super.key,
    required this.value,
    required this.question,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return createFormField(
      question: question,
      value: value,
      onChanged: onChanged,
    );
  }
}
