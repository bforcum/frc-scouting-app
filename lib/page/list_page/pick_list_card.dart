import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/analysis_page/analysis_details.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/provider/teams_provider.dart';

class PickListCard extends ConsumerStatefulWidget {
  final TeamData data;
  final int listPosition;
  final bool editMode;

  const PickListCard({
    super.key,
    required this.data,
    required this.listPosition,
    required this.editMode,
  });

  @override
  ConsumerState<PickListCard> createState() => _PickListCardState();
}

class _PickListCardState extends ConsumerState<PickListCard> {
  bool disabled = false;
  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 5,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Team ${widget.data.teamNumber}",
              style: TextTheme.of(
                context,
              ).bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "Match count: ${widget.data.results.length}",
              style: TextTheme.of(context).bodySmall,
            ),
          ],
        ),
        Spacer(),
        if (widget.editMode) ...[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              if (!await showConfirmationDialog(
                ConfirmationInfo(
                  title: "Remove Team from List",
                  content: "Are you sure you want to remove this team?",
                ),
              )) {
                return;
              }
              ref
                  .read(TeamsListProvider(widget.data.eventCode).notifier)
                  .move(
                    Team(
                      teamNumber: widget.data.teamNumber,
                      eventCode: widget.data.eventCode,
                      gameFormat: widget.data.gameFormat.id,
                      pickListPosition: null,
                    ),
                  );
            },
          ),
          ReorderableDragStartListener(
            index: widget.listPosition,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainer,
              ),
              child: Icon(Icons.drag_handle),
            ),
          ),
        ] else
          IconButton(
            icon:
                disabled
                    ? Icon(
                      Icons.remove_circle,
                      color: ColorScheme.of(context).errorContainer,
                    )
                    : Icon(Icons.remove_circle_outline),
            onPressed:
                () => setState(() {
                  disabled = !disabled;
                }),
          ),
      ],
    );
    Widget frame =
        (disabled)
            ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: ColorScheme.of(context).outline,
                  radius: Radius.circular(kBorderRadius),
                  dashPattern: [10, 5],
                  strokeWidth: 2,
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorScheme.of(context).surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: content,
                ),
              ),
            )
            : Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainer,
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: content,
            );
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnalysisDetailsPage(data: widget.data),
          ),
        );
      },
      child: frame,
    );
  }
}
