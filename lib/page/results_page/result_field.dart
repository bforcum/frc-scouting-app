import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class MatchResultField extends StatelessWidget {
  factory MatchResultField.question({
    required Question question,
    required dynamic value,
  }) {
    switch (question.type) {
      case QuestionType.toggle:
        return MatchResultField(
          label: question.label,
          value: value ? "True" : "False",
        );
      case QuestionType.select:
        return MatchResultField(
          label: question.label,
          value: (question as QuestionSelect).options[value],
        );
      case QuestionType.counter:
        return MatchResultField(label: question.label, value: value.toString());
      case QuestionType.number:
        return MatchResultField(label: question.label, value: value.toString());
      case QuestionType.text:
        return MatchResultField(
          label: question.label,
          value: value,
          big: (question as QuestionText).big,
        );
    }
  }

  final String label, value;
  final bool big;

  const MatchResultField({
    super.key,
    required this.label,
    required this.value,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    if (big) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall!),
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
                value,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall!,
              ),
            ),
          ),
        ],
      );
    }
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
