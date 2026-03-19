import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/team_data.dart';

class TeamStatsCard extends ConsumerStatefulWidget {
  final TeamData data;
  final int listPosition;

  const TeamStatsCard({
    super.key,
    required this.data,
    required this.listPosition,
  });

  @override
  ConsumerState<TeamStatsCard> createState() => _TeamStatsCardState();
}

class _TeamStatsCardState extends ConsumerState<TeamStatsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainer,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainer,
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: Row(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
