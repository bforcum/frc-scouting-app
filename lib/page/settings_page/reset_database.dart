import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/common/snack_bar_message.dart';
import 'package:scouting_app/provider/database_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class ResetDatabase extends ConsumerWidget {
  const ResetDatabase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text("Reset database", style: Theme.of(context).textTheme.bodyMedium),
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
            await ref.read(databaseProvider).managers.matchResults.delete();
            ref.invalidate(storedResultsProvider);
            if (context.mounted) {
              showSnackBarMessage("All data cleared");
            }
          },
          child: Text("RESET"),
        ),
      ],
    );
  }
}
