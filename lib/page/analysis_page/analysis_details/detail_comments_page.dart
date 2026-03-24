import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/team_data.dart';

class DetailCommentsPage extends StatelessWidget {
  final List<MatchResult> results;

  DetailCommentsPage({super.key, required TeamData data})
    : results = data.results.sortedBy((e) => e.teamNumber);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children:
                results
                    .where((e) => (e.comment ?? "").isNotEmpty)
                    .map(
                      (e) => Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorScheme.of(context).surfaceContainer,
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Match ${e.matchNumber}",
                              style: TextTheme.of(context).bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(e.comment!),
                            Row(
                              children: [
                                Spacer(),
                                Text(e.scoutName, textAlign: TextAlign.end),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
