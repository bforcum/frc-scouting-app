import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

void showSnackBarMessage(String text) {
  if (homeKey.currentContext == null || !homeKey.currentContext!.mounted) {
    return;
  }
  ScaffoldMessenger.of(homeKey.currentContext!).showSnackBar(
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
