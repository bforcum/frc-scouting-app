import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

Future<void> showAlertDialog({
  required String title,
  required String content,
  required String closeMessage,
  BuildContext? context,
}) async {
  context = context ?? homeKey.currentContext;
  if (context == null || !context.mounted) {
    return;
  }
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(closeMessage),
          ),
        ],
      );
    },
  );

  return;
}
