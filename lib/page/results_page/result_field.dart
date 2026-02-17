import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class MatchResultField extends StatelessWidget {
  final Question question;
  final dynamic value;

  const MatchResultField({
    super.key,
    required this.question,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.toggle:
        return _HorizontalField(
          label: question.label,
          value: value ? "True" : "False",
        );
      case QuestionType.dropdown:
        return _HorizontalField(
          label: question.label,
          value: (question as QuestionDropdown).options[value],
        );
      case QuestionType.counter:
        return _HorizontalField(label: question.label, value: value.toString());
      case QuestionType.number:
        return _HorizontalField(label: question.label, value: value.toString());
      case QuestionType.text:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.label, style: Theme.of(context).textTheme.bodySmall!),
            SizedBox(height: 10),
            Container(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorScheme.of(context).outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "$value",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
              ),
            ),
          ],
        );
    }
  }
}

class _HorizontalField extends StatelessWidget {
  final String label, value;

  const _HorizontalField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium!),
        const Spacer(),
        Container(
          width: 120,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorScheme.of(context).outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium!),
        ),
      ],
    );
  }
}
