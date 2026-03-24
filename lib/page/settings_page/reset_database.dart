import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/common/snack_bar_message.dart';
import 'package:scouting_app/provider/database_provider.dart';

class ResetDatabase extends ConsumerWidget {
  const ResetDatabase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text("Reset database", style: Theme.of(context).textTheme.bodyMedium),
        Spacer(),
        FilledButton(
          onPressed: () async {
            if (!await showConfirmationDialog(
              ConfirmationInfo(
                title: "Are you sure?",
                content: "This will clear all existing data",
              ),
            )) {
              return;
            }
            AppDatabase db = ref.read(databaseProvider);
            final m = drift.Migrator(db);
            for (final drift.TableInfo<drift.Table, Object?> table
                in db.allTables) {
              m
                  .deleteTable(table.actualTableName)
                  .whenComplete(() => m.createTable(table));
            }
            if (context.mounted) {
              showSnackBarMessage("All data cleared");
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              ColorScheme.of(context).primaryContainer,
            ),
          ),
          child: Text("RESET", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
