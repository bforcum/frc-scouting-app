import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/team_data.dart';

class TeamStatsCard extends ConsumerWidget {
  final TeamData data;

  const TeamStatsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color accent =
        (data.totalScores.length) < 12 ? Color(0xFFFFCC00) : Color(0xFF009900);
    return GestureDetector(
      // onTap: () async => await _viewResults(context),
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
                  "Team ${data.teamNumber}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Match count: ${data.totalScores.length}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Spacer(),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadius),
                border: Border.all(color: accent),
                color: accent.withAlpha(32),
              ),
              child: Row(
                spacing: 10,
                children: [
                  Icon(Icons.analytics, color: accent),
                  Text(
                    "${data.totalScores.average.floor()}",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
