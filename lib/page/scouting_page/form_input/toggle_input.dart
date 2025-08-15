import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class ToggleInput extends StatefulWidget {
  final Function(bool)? onChanged;
  final QuestionToggle question;
  const ToggleInput({super.key, required this.question, this.onChanged});

  @override
  State<ToggleInput> createState() => _ToggleInputState();
}

class _ToggleInputState extends State<ToggleInput> {
  late final QuestionToggle question;

  bool enabled = false;

  @override
  void initState() {
    super.initState();

    question = widget.question;
    enabled = question.preset ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: TextStyle(fontSize: 25)),
        Spacer(),
        SizedBox(
          height: 60,
          child: Switch(
            value: enabled,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (value) {
              setState(() {
                enabled = value;
              });
              if (widget.onChanged != null) widget.onChanged!(value);
            },
          ),
        ),
      ],
    );
  }
}
