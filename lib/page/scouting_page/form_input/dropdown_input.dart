import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class DropdownInput extends StatelessWidget {
  final QuestionDropdown question;
  final Function(int?) onChanged;
  final FormFieldState<int?> formState;

  const DropdownInput({
    super.key,
    required this.question,
    required this.formState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: TextStyle(fontSize: 25)),
        Spacer(),
        Container(
          width: 154,
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  formState.errorText != null
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownMenu<int>(
            width: 154,
            inputDecorationTheme: const InputDecorationTheme(
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            trailingIcon: Icon(Icons.arrow_drop_down, size: 30),
            selectedTrailingIcon: Icon(Icons.arrow_drop_up, size: 30),
            requestFocusOnTap: false,
            initialSelection: question.preset,
            keyboardType: TextInputType.none,
            enableSearch: false,
            dropdownMenuEntries: [
              for (int i = 0; i < question.options.length; i++)
                DropdownMenuEntry(value: i, label: question.options[i]),
            ],
            onSelected: (value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
