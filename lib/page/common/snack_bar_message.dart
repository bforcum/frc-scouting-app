import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

void showSnackBarMessage(String text, [BuildContext? context]) {
  context = context ?? homeKey.currentContext;
  if (context == null || !context.mounted) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SelectableText(
        text,
        style: TextStyle(
          color: Theme.of(homeKey.currentContext!).colorScheme.onSurface,
        ),
      ),
      backgroundColor:
          Theme.of(homeKey.currentContext!).colorScheme.surfaceContainerHighest,
    ),
  );
}
