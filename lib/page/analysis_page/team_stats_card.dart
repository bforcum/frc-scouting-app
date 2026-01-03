import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/team_data.dart';

class TeamStatsCard extends ConsumerStatefulWidget {
  final TeamData data;
  final int Function(TeamData) analysisFunc;

  const TeamStatsCard({
    super.key,
    required this.data,
    required this.analysisFunc,
  });

  @override
  ConsumerState<TeamStatsCard> createState() => _TeamStatsCardState();
}

class _TeamStatsCardState extends ConsumerState<TeamStatsCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    Color accent =
        (widget.data.totalScores.length) < 12
            ? Color(0xFFFFCC00)
            : Color(0xFF009900);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap:
                () => setState(() {
                  isExpanded = !isExpanded;
                }),

            child: Container(
              padding: const EdgeInsets.all(kBorderRadius),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Team ${widget.data.teamNumber}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Match count: ${widget.data.totalScores.length}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      border: Border.all(color: accent),
                      color: accent.withAlpha(32),
                    ),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.analytics, color: accent),
                        Text(
                          "${widget.analysisFunc(widget.data)}",
                          style: TextTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(children: [
                
              ],),
            ),
          ),
        ],
      ),
    );
  }
}
