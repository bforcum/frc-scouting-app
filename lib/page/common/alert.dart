import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

Future<void> showAlertDialog(
  String title,
  String content,
  String closeMessage,
) async {
  if (homeKey.currentContext == null) {
    return;
  }
  await showDialog(
    context: homeKey.currentContext!,
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
