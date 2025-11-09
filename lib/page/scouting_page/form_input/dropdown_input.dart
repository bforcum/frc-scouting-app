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
        Text(question.label, style: Theme.of(context).textTheme.bodyMedium),
        Spacer(),
        Container(
          width: 144,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  formState.errorText != null
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: DropdownMenu<int>(
            inputDecorationTheme: InputDecorationTheme(
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            trailingIcon: Icon(Icons.arrow_drop_down, size: 20),
            selectedTrailingIcon: Icon(Icons.arrow_drop_up, size: 20),
            requestFocusOnTap: false,
            initialSelection: question.preset,
            hintText: "Select",
            keyboardType: TextInputType.none,
            enableSearch: false,
            textStyle: Theme.of(context).textTheme.bodySmall,
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
