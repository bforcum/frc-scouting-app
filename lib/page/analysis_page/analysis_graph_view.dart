import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/provider/statistics_provider.dart';

class AnalysisGraphView extends ConsumerWidget {
  const AnalysisGraphView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int criterion = ref.watch(analysisCriterionProvider);
    AsyncValue<List<TeamData>> asyncStats = ref.watch(teamStatisticsProvider);

    if (asyncStats.hasError) {
      return SliverFillRemaining(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            children: [
              Text(
                "Error: ${asyncStats.error}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "${asyncStats.stackTrace}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }
    if (asyncStats.isLoading) {
      return SliverToBoxAdapter(
        child: Center(
          child: Container(
            constraints: BoxConstraints.tight(Size(60, 60)),
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    if (asyncStats.value!.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "No results",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
    List<TeamData> stats = asyncStats.value!;
    stats.sort((a, b) {
      double diff = b.scores[criterion].average - a.scores[criterion].average;
      // Convert to int without missing edge cases if the diff is small
      return diff > 0 ? 1 : diff.floor();
    });

    final double max = stats[0].scores[criterion].average;
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorScheme.of(context).surfaceContainer,
        ),
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...stats.map((e) {
                  double score = e.scores[criterion].average;
                  double fraction = score / max;
                  return Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          e.teamNumber.toString(),
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Container(
                        alignment: AlignmentGeometry.centerRight,
                        height: 30,
                        width: (constraints.maxWidth - 50.0) * fraction,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.blue.shade300
                                : Colors.blue.shade700,
                        child:
                            (fraction > 0.5)
                                ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(score.round().toString()),
                                )
                                : null,
                      ),
                      if (fraction < 0.5)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(score.round().toString()),
                        ),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
