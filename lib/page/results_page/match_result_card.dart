import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/alert.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/results_page/edit_result_page.dart';
import 'package:scouting_app/page/results_page/qr_code_overlay.dart';
import 'package:scouting_app/page/results_page/view_result_page.dart';
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
                  "Team ${result.teamNumber}, Match ${result.matchNumber}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: result.timeStamp.toLocal().toString().substring(
                          0,
                          11,
                        ),
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
                    title: "Unsupported Game Format",
                    content:
                        "The game format for this result is not known or supported by the app",
                    closeMessage: "Okay",
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
                      await _editResults(context);
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
                      ref.invalidate(storedResultsProvider);
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
        title: "Unsupported Game Format",
        content:
            "The game format for this result is not known or supported by the app",
        closeMessage: "Okay",
      );
      return;
    }
    (Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewResultPage(matchResult: result),
      ),
    ));
  }

  Future _editResults(BuildContext context) async {
    if (kSupportedGameFormats.firstWhereOrNull(
          (gameFormat) => gameFormat.name == result.gameFormatName,
        ) ==
        null) {
      await showAlertDialog(
        title: "Unsupported Game Format",
        content:
            "The game format for this result is not known or supported by the app",
        closeMessage: "Okay",
      );
      return;
    }
    (Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditResultPage(matchResult: result),
      ),
    ));
  }
}
