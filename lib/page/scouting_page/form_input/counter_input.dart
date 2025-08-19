import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class CounterInput extends StatelessWidget {
  final Function(int) onChanged;
  final int value;
  final QuestionCounter question;
  CounterInput({
    super.key,
    int? value,
    required this.onChanged,
    required this.question,
  }) : value = value ?? question.preset ?? question.min;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: TextStyle(fontSize: 25)),
        Spacer(),
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.horizontal_rule),

                onPressed:
                    (value <= question.min) ? null : () => onChanged(value - 1),
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: TextStyle(fontSize: 25, fontFamily: "Roboto"),
                ),
              ),
              IconButton(
                iconSize: 40,
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
