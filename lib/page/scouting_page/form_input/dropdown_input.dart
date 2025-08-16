import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class DropdownInput extends StatelessWidget {
  final QuestionDropdown question;
  final Function(int)? onChanged;

  const DropdownInput({super.key, required this.question, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: TextStyle(fontSize: 25)),
        Spacer(),
        Container(
          width: 154,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownMenu<int>(
            width: 154,
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            ),
            initialSelection: question.preset,
            enableSearch: false,
            dropdownMenuEntries: [
              for (int i = 0; i < question.options.length; i++)
                DropdownMenuEntry(value: i, label: question.options[i]),
            ],
            onSelected: (value) {
              if (onChanged != null && value != null) {
                onChanged!(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
