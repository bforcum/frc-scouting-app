import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/common/snack_bar_message.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class GenerateDummyData extends ConsumerWidget {
  const GenerateDummyData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          "Generate dummy data",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () async {
            if (!await showConfirmationDialog(
              ConfirmationInfo(
                title: "Are you sure?",
                content: "This will clear all existing data",
              ),
            )) {
              return;
            }
            String? error = await generateDummyData(ref);
            if (context.mounted) {
              if (error != null) {
                showSnackBarMessage(error);
              } else {
                showSnackBarMessage("Dummy data generated");
              }
            }
          },
          child: Text("Generate"),
        ),
      ],
    );
  }
}

Future<String?> generateDummyData(WidgetRef ref) async {
  Random rng = Random();
  try {
    await ref.read(storedResultsProvider.notifier).clearAll();
    List<MatchResult> results = List.empty(growable: true);
    for (int i = 1; i <= 72; i++) {
      for (int j = 0; j < 6; j++) {
        Map<String, dynamic> data = {
          "gameFormatName": kGameFormat.name,
          "eventName": "Test",
          "teamNumber": 1000 + j,
          "matchNumber": i,
          "scoutName": "Test Scout",
          "timeStamp": DateTime.now().add(
            Duration(minutes: i * 6 - 500, seconds: j * 5),
          ),
        };
        for (var question in kGameFormat.questions) {
          switch (question.type) {
            case QuestionType.toggle:
              data[question.key] = rng.nextBool();
            case QuestionType.counter:
              question = question as QuestionCounter;
              data[question.key] =
                  rng.nextInt(question.max - question.min + 1) + question.min;
            case QuestionType.number:
              question = question as QuestionNumber;
              data[question.key] =
                  rng.nextInt(question.max ?? 10000 - (question.min ?? 0) + 1) +
                  (question.min ?? 0);
            case QuestionType.dropdown:
              question = question as QuestionDropdown;
              data[question.key] = rng.nextInt(question.options.length);
            case QuestionType.text:
              data[question.key] = "Sample text ${(i + j)}";
          }
        }
        results.add(MatchResult.fromMap(data));
      }
    }
    await ref.read(storedResultsProvider.notifier).addAllResults(results);
  } catch (error) {
    return "Error: ${error.toString()}";
  }
  ref.invalidate(storedResultsProvider);
  return null;
}
