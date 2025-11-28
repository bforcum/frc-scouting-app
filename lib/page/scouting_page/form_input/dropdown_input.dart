import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class DropdownInput extends StatelessWidget {
  final QuestionDropdown question;
  final Function(int?) onChanged;
  final String? errorText;
  final int? initialValue;

  const DropdownInput({
    super.key,
    required this.question,
    required this.onChanged,
    this.errorText,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: Theme.of(context).textTheme.bodyMedium),
        Spacer(),
        DropdownMenu<int>(
          width: 144,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            errorStyle: TextStyle(fontSize: 0),
            isCollapsed: Platform.isAndroid,
            isDense: false,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color:
                    errorText != null
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
            hintStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Theme.of(context).hintColor),
          ),
          trailingIcon: Icon(Icons.arrow_drop_down, size: 20),
          selectedTrailingIcon: Icon(Icons.arrow_drop_up, size: 20),
          requestFocusOnTap: false,
          initialSelection: initialValue ?? question.preset,
          hintText: "Select",
          keyboardType: TextInputType.none,
          enableSearch: false,
          textStyle: Theme.of(context).textTheme.bodySmall!,
          dropdownMenuEntries: [
            for (int i = 0; i < question.options.length; i++)
              DropdownMenuEntry(value: i, label: question.options[i]),
          ],
          onSelected: (value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}
