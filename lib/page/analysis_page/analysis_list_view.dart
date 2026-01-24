import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/analysis_page/team_stats_card.dart';
import 'package:scouting_app/provider/statistics_provider.dart';

class AnalysisListView extends ConsumerWidget {
  const AnalysisListView({super.key});

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
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverList.builder(
        itemCount: asyncStats.value!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: TeamStatsCard(
              data: asyncStats.value![index],
              criterion: criterion,
            ),
          );
        },
      ),
    );
  }
}
