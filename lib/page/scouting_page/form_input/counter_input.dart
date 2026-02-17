import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class CounterQuestionInput extends StatefulWidget {
  final Function(int) onChanged;
  final int value;
  final QuestionCounter question;
  const CounterQuestionInput({
    super.key,
    required this.value,
    required this.onChanged,
    required this.question,
  });

  @override
  State<CounterQuestionInput> createState() => _CounterQuestionInputState();
}

class _CounterQuestionInputState extends State<CounterQuestionInput> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.question.label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorScheme.of(context).outline,
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
                    (value <= widget.question.min)
                        ? null
                        : () {
                          setState(() {
                            --value;
                            widget.onChanged(value);
                          });
                        },
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
                    (value >= widget.question.max)
                        ? null
                        : () {
                          setState(() {
                            value += 1;
                            widget.onChanged(value);
                          });
                        },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
