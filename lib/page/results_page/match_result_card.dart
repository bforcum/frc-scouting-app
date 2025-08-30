import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/alert.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/results_page/view_result_page.dart';
import 'package:scouting_app/page/results_page/qr_code_overlay.dart';
import 'package:scouting_app/provider/match_result_provider.dart';

class MatchResultCard extends ConsumerWidget {
  final MatchResult result;

  const MatchResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
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
      },
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
                  style: TextStyle(fontSize: 20),
                ),
                Text.rich(
                  TextSpan(
                    text: "Match ${result.matchNumber}, ",
                    children: [
                      TextSpan(
                        text: (result.data["timeStamp"] as DateTime)
                            .copyWith(second: 0, millisecond: 0)
                            .toLocal()
                            .toString()
                            .substring(0, 16), // Exclude granular time info
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
                  PopupMenuItem(child: Text("View")),
                  PopupMenuItem(child: Text("Edit")),
                  PopupMenuItem(
                    child: Text("Delete"),
                    onTap: () async {
                      if (!(await showConfirmationDialog(
                            ConfirmationInfo(
                              title: "Delete Match Result",
                              content:
                                  "Are you sure you want to delete this match result?",
                            ),
                          ) ??
                          false)) {
                        return;
                      }
                      ref
                          .read(storedResultsProvider.notifier)
                          .deleteResult(
                            result.eventName,
                            result.teamNumber,
                            result.matchNumber,
                          );
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
}
