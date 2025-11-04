import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search by team number",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() => searchText = value),
                  ),
                  DropdownMenu<SortType>(
                    width: MediaQuery.of(context).size.width,
                    label: Text("Sort by"),
                    initialSelection: sortBy,
                    requestFocusOnTap: false,
                    keyboardType: TextInputType.none,
                    enableSearch: false,
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
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                if (stats.hasError) {
                  return Text("Error encountered: ${stats.error}");
                }
                if (stats.isLoading) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  );
                }
                if (stats.value!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("No results"),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 90),
                    itemCount: stats.value?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: TeamStatsCard(data: stats.value![index]),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// enum SortType { totalPoints, autoPoints, telePoints }
