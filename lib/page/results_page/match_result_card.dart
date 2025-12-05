import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/alert.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/results_page/view_result_page.dart';
import 'package:scouting_app/page/results_page/qr_code_overlay.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class MatchResultCard extends ConsumerWidget {
  final MatchResult result;

  const MatchResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async => await _viewResults(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        padding: const EdgeInsets.all(kBorderRadius),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Team ${result.teamNumber}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text.rich(
                  TextSpan(
                    text: "Match ${result.matchNumber}, ",
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: (result.data["timeStamp"] as DateTime)
                            .toLocal()
                            .toString()
                            .substring(0, 11),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextSpan(
                        text: TimeOfDay.fromDateTime(
                          (result.data["timeStamp"] as DateTime)
                              .copyWith(
                                second: 0,
                                millisecond: 0,
                              ) // Exclude granular time info
                              .toLocal(),
                        ).format(context),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                if (kSupportedGameFormats.firstWhereOrNull(
                      (gameFormat) => gameFormat.name == result.gameFormatName,
                    ) ==
                    null) {
                  await showAlertDialog(
                    "Unsupported Game Format",
                    "The game format for this result is not known or supported by the app",
                    "Okay",
                  );
                  return;
                }
                showQRCodeOverlay(result);
              },
              icon: Icon(Icons.qr_code),
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text("View"),
                    onTap: () async => await _viewResults(context),
                  ),
                  PopupMenuItem(
                    child: Text("Edit"),
                    onTap: () async {
                      ref
                          .read(storedResultsProvider.notifier)
                          .updateResult(
                            result.copyWith(timeStamp: DateTime.timestamp()),
                          );
                      await ref.read(storedResultsProvider.notifier).refresh();
                    },
                  ),
                  PopupMenuItem(
                    child: Text("Delete"),
                    onTap: () async {
                      if (!(await showConfirmationDialog(
                        ConfirmationInfo(
                          title: "Delete Match Result",
                          content:
                              "Are you sure you want to delete this match result?",
                        ),
                      ))) {
                        return;
                      }
                      ref
                          .read(storedResultsProvider.notifier)
                          .deleteResult(
                            result.eventName,
                            result.teamNumber,
                            result.matchNumber,
                          );
                      await ref.read(storedResultsProvider.notifier).refresh();
                    },
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _viewResults(BuildContext context) async {
    if (kSupportedGameFormats.firstWhereOrNull(
          (gameFormat) => gameFormat.name == result.gameFormatName,
        ) ==
        null) {
      await showAlertDialog(
        "Unsupported Game Format",
        "The game format for this result is not known or supported by the app",
        "Okay",
      );
      return;
    }
    (Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewResultPage(matchResult: result),
      ),
    ));
  }
}
