import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/question.dart';
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
            String? error = await generateDummyData(ref);
            if (context.mounted) {
              if (error != null) {
                showSnackBarMessage("Error generating dummy data: $error");
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
    for (int i = 1; i <= 72; i++) {
      for (int j = 0; j < 6; j++) {
        Map<String, dynamic> data = {};
        for (var question in kGameFormat.questions) {
          if (question.type == QuestionType.toggle) {
            data[question.key] = rng.nextBool();
          } else if (question.type == QuestionType.counter) {
            question = question as QuestionCounter;
            data[question.key] =
                rng.nextInt(question.max - question.min + 1) + question.min;
          } else if (question.type == QuestionType.number) {
            question = question as QuestionNumber;
            data[question.key] =
                rng.nextInt(question.max ?? 10000 - (question.min ?? 0) + 1) +
                (question.min ?? 0);
          } else if (question.type == QuestionType.dropdown) {
            question = question as QuestionDropdown;
            data[question.key] = rng.nextInt(question.options.length - 1);
          } else if (question.type == QuestionType.text) {
            data[question.key] = "Sample text ${(i + j)}";
          }
        }
        await ref
            .read(storedResultsProvider.notifier)
            .addResult(
              MatchResult(
                gameFormatName: kGameFormat.name,
                eventName: "Test Event",
                teamNumber: 1000 + j,
                matchNumber: i,
                scoutName: "Test Scout",
                timeStamp: DateTime.now().add(
                  Duration(minutes: i * 6 - 500, seconds: j * 5),
                ),
                data: data,
              ),
            );
      }
    }
  } catch (error) {
    return "Error: ${error.toString()}";
  }
  await ref.read(storedResultsProvider.notifier).refresh();

  return null;
}
