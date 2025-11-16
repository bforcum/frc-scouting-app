import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/team_data.dart';
import 'package:scouting_app/page/analysis_page/team_stats_card.dart';
import 'package:scouting_app/provider/statistics_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({super.key});

  @override
  ConsumerState<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  String searchText = "";
  SortType sortBy = SortType.values[0];
  List<String> sortOptions = [];

  AsyncValue<List<TeamData>> stats = AsyncValue.loading();

  @override
  Widget build(BuildContext context) {
    setState(() {
      stats = ref.watch(teamStatisticsProvider);
    });

    var contentBuilder = Builder(
      builder: (context) {
        if (stats.hasError) {
          return SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Error encountered: ${stats.error}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }
        if (stats.isLoading) {
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
        if (stats.value!.isEmpty) {
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

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 90),
          sliver: SliverList.builder(
            itemCount: stats.value!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: TeamStatsCard(data: stats.value![index]),
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
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    kBorderRadius,
                                  ),
                                ),
                                hintText: "Search teams",
                                hintStyle: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                              keyboardType: TextInputType.number,
                              onChanged:
                                  (value) => setState(() => searchText = value),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return DropdownMenu<SortType>(
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
                                    for (int i = 0; i < sortOptions.length; i++)
                                      DropdownMenuEntry(
                                        value: SortType.values[i],
                                        label: sortOptions[i],
                                      ),
                                  ],

                                  onSelected: (val) {
                                    setState(() {
                                      sortBy = val ?? SortType.values[0];
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
