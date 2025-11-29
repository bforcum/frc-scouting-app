import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/analysis_page/team_stats_card.dart';
import 'package:scouting_app/provider/statistics_provider.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({super.key});

  @override
  ConsumerState<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  int sortBy = 0;

  AsyncValue<List<TeamData>> asyncStats = AsyncValue.loading();

  @override
  Widget build(BuildContext context) {
    setState(() {
      asyncStats = ref.watch(teamStatisticsProvider);
    });

    var contentBuilder = Builder(
      builder: (context) {
        if (asyncStats.hasError) {
          return SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Error encountered: ${asyncStats.error}",
                style: Theme.of(context).textTheme.bodyLarge,
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

        stats.sort(
          (a, b) =>
              kGameFormat.analysisOptions[sortBy].score(b) -
              kGameFormat.analysisOptions[sortBy].score(a),
        );
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          sliver: SliverList.builder(
            itemCount: asyncStats.value!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: TeamStatsCard(
                  data: asyncStats.value![index],
                  analysisFunc: kGameFormat.analysisOptions[sortBy].score,
                ),
              );
            },
          ),
        );
      },
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomScrollView(
          slivers: [
            SliverFloatingHeader(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Flex(
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: [
                          Expanded(
                            flex: 2,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return DropdownMenu<int>(
                                  label: Text("Sort by"),
                                  width: constraints.maxWidth,
                                  initialSelection: sortBy,
                                  requestFocusOnTap: false,
                                  keyboardType: TextInputType.none,
                                  enableSearch: false,

                                  inputDecorationTheme: InputDecorationTheme(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        kBorderRadius,
                                      ),
                                    ),
                                    labelStyle: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  textStyle:
                                      Theme.of(context).textTheme.bodySmall,
                                  dropdownMenuEntries: [
                                    for (
                                      int i = 0;
                                      i < kGameFormat.analysisOptions.length;
                                      i++
                                    )
                                      DropdownMenuEntry(
                                        value: i,
                                        label:
                                            kGameFormat
                                                .analysisOptions[i]
                                                .label,
                                      ),
                                  ],

                                  onSelected: (val) {
                                    setState(() {
                                      sortBy = val ?? 0;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            contentBuilder.build(context),
          ],
        ),
      ],
    );
  }
}

// enum SortType { totalPoints, autoPoints, telePoints }
