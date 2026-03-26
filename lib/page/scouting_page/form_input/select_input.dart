import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SelectQuestionInput extends StatelessWidget {
  final String label;
  final List<String> options;
  final bool dropdown;
  final int? preset;

  final Function(int?) onChanged;
  final String? errorText;
  final int? initialValue;

  const SelectQuestionInput({
    super.key,
    required this.label,
    required this.options,
    required this.dropdown,
    required this.onChanged,
    this.preset,
    this.errorText,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    if (!dropdown) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments:
                options
                    .mapIndexed(
                      (i, val) => ButtonSegment<int>(
                        value: i,
                        label: Text(
                          val,
                          style: TextTheme.of(context).bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
            selected: initialValue == null ? {} : {initialValue!},
            emptySelectionAllowed: true,
            onSelectionChanged: (set) => onChanged(set.firstOrNull),
            expandedInsets: EdgeInsets.zero,
          ),
        ],
      );
    }
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Spacer(),
        DropdownMenu<int>(
          width: 144,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            errorStyle: TextStyle(fontSize: 0),
            isCollapsed: !Platform.isWindows,
            isDense: false,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color:
                    errorText != null
                        ? ColorScheme.of(context).errorContainer
                        : ColorScheme.of(context).outline,
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
          initialSelection: initialValue ?? preset,
          hintText: "Select",
          keyboardType: TextInputType.none,
          enableSearch: false,
          textStyle: Theme.of(context).textTheme.bodySmall!,
          dropdownMenuEntries: [
            for (int i = 0; i < options.length; i++)
              DropdownMenuEntry(value: i, label: options[i]),
          ],
          onSelected: (value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}
