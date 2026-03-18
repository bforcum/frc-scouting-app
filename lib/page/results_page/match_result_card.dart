import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/results_page/edit_result_page.dart';
import 'package:scouting_app/page/results_page/qr_code_overlay.dart';
import 'package:scouting_app/page/results_page/view_result_page.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class MatchResultCard extends ConsumerWidget {
  final MatchResult result;
  final bool selectMode;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const MatchResultCard({
    super.key,
    required this.result,
    required this.selectMode,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () => onSelected(!selected),
      onTap:
          () async =>
              selectMode ? onSelected(!selected) : _viewResults(context),
      child: AnimatedContainer(
        duration: Durations.medium1,
        decoration: BoxDecoration(
          color:
              (selected)
                  ? ColorScheme.of(context).primaryContainer
                  : ColorScheme.of(context).surfaceContainer,
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
                          color: ColorScheme.of(context).onSurfaceVariant,
                        ),
                      ),
                      TextSpan(
                        text: TimeOfDay.fromDateTime(
                          result.timeStamp
                              .copyWith(
                                second: 0,
                                millisecond: 0,
                              ) // Exclude granular time info
                              .toLocal(),
                        ).format(context),
                        style: TextStyle(
                          color: ColorScheme.of(context).onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (selectMode)
              Checkbox(
                value: selected,
                onChanged: (val) => onSelected(!selected),
              ),
            if (!selectMode)
              IconButton(
                onPressed: () async => showQRCode([result]),
                icon: Icon(Icons.qr_code),
              ),
            if (!selectMode)
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text("Select"),
                      onTap: () => onSelected(!selected),
                    ),
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
                            .deleteResults(
                              event: result.eventName,
                              team: result.teamNumber,
                              match: result.matchNumber,
                              gameFormat: ref.read(settingsProvider).gameFormat,
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
    (Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewResultPage(matchResult: result),
      ),
    ));
  }

  Future _editResults(BuildContext context) async {
    (Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditResultPage(matchResult: result),
      ),
    ));
  }
}
