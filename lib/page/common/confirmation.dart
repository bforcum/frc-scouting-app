import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

/// Holds information for showing a confirmation dialog.
class ConfirmationInfo {
  /// The confirmation title.
  final String title;

  /// The confirmation content.
  final String content;

  /// The text to show on the negative/cancel button.
  final String negative;

  /// The text to show on the affirmative/confirm button.
  final String affirmative;

  ConfirmationInfo({
    required this.title,
    required this.content,
    this.negative = "Cancel",
    this.affirmative = "Ok",
  });
}

Future<bool> showConfirmationDialog(ConfirmationInfo confirmation) async {
  if (homeKey.currentContext == null) {
    return false;
  }
  return await showDialog<bool>(
        context: homeKey.currentContext!,
        builder:
            (context) => AlertDialog(
              title: Text(confirmation.title),
              content: Text(confirmation.content),
              actions: [
                TextButton(
                  child: Text(confirmation.negative),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(confirmation.affirmative),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
      ) ??
      false;
}
