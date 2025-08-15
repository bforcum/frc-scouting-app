import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class CounterInput extends StatefulWidget {
  final Function(int)? onChanged;
  final QuestionCounter question;
  const CounterInput({super.key, this.onChanged, required this.question});

  @override
  State<CounterInput> createState() => _CounterInputState();
}

class _CounterInputState extends State<CounterInput> {
  late final QuestionCounter question;

  int count = 0;

  @override
  void initState() {
    super.initState();
    question = widget.question;
    count = question.preset ?? question.min;
  }

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
                    (count <= question.min)
                        ? null
                        : () => setState(() {
                          count -= 1;
                          if (widget.onChanged != null) {
                            widget.onChanged!(count);
                          }
                        }),
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: TextStyle(fontSize: 25, fontFamily: "Roboto"),
                ),
              ),
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.add),
                onPressed:
                    (count >= question.max)
                        ? null
                        : () => setState(() {
                          count += 1;
                          if (widget.onChanged != null) {
                            widget.onChanged!(count);
                          }
                        }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
