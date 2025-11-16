import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class CounterInput extends StatelessWidget {
  final Function(int) onChanged;
  final int value;
  final QuestionCounter question;
  const CounterInput({
    super.key,
    required this.value,
    required this.onChanged,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 32,
                icon: Icon(Icons.horizontal_rule),

                onPressed:
                    (value <= question.min) ? null : () => onChanged(value - 1),
              ),
              Container(
                width: 32,
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              IconButton(
                iconSize: 32,
                icon: Icon(Icons.add),
                onPressed:
                    (value >= question.max) ? null : () => onChanged(value + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
