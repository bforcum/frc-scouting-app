import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/common/toggle_switch.dart';

class ToggleInput extends StatelessWidget {
  final Function(bool) onChanged;
  final bool? value;
  final QuestionToggle question;

  const ToggleInput({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: Theme.of(context).textTheme.bodyMedium),
        Spacer(),
        SizedBox(
          height: 48,
          child: ToggleSwitch(
            value: value ?? question.preset ?? false,
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
