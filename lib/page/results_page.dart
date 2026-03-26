import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/model/settings.dart';
import 'package:scouting_app/page/results_page/match_result_card.dart';
import 'package:scouting_app/page/results_page/qr_code_overlay.dart';
import 'package:scouting_app/page/results_page/results_buttons.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class ResultsPage extends ConsumerStatefulWidget {
  const ResultsPage({super.key});

  @override
  ConsumerState<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> {
  late AsyncValue<List<MatchResult>> matchResults = AsyncValue.loading();

  late GameFormat gameFormat;
  String? selectedEvent;
  String searchText = "";
  SortType sortBy = SortType.timeDescending;
  List<BigInt> selectedResults = [];
  final List<DropdownMenuEntry<SortType>> sortOptions = [
    DropdownMenuEntry(
      value: SortType.timeDescending,
      label: "Time (new to old)",
    ),
    DropdownMenuEntry(
      value: SortType.timeAscending,
      label: "Time (old to new)",
    ),
    DropdownMenuEntry(
      value: SortType.matchNumAscending,
      label: "Match (ascending)",
    ),
    DropdownMenuEntry(
      value: SortType.matchNumDescending,
      label: "Match (descending)",
    ),
    DropdownMenuEntry(
      value: SortType.teamNumAscending,
      label: "Team Num (ascending)",
    ),
    DropdownMenuEntry(
      value: SortType.teamNumDescending,
      label: "Team Num (descending)",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = ref.watch(settingsProvider);
    gameFormat = settings.gameFormat;
    selectedEvent = settings.selectedEvent;

    ref.listen(storedResultsProvider, (prev, next) => selectedResults.clear());

    final AsyncValue<List<MatchResult>> newResults = ref.watch(
      FilteredResultsProvider(
        sort: sortBy,
        teamFilter: searchText,
        eventCode: selectedEvent,
        gameFormat: gameFormat,
      ),
    );
    if (!newResults.isLoading) {
      matchResults = newResults;
    }
    var contentBuilder = Builder(
      builder: (context) {
        if (matchResults.hasError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                spacing: 10,
                children: [
                  Text(
                    "Error encountered: ${matchResults.error}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }
        if (matchResults.isLoading) {
          return SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: BoxConstraints.tight(Size(60, 60)),
                width: 40,
                padding: const EdgeInsets.all(10.0),
                child: CircularProgressIndicator(
                  constraints: BoxConstraints.tight(Size(40, 40)),
                ),
              ),
            ),
          );
        }
        if (matchResults.value!.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "No results",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 90),
          sliver: SliverList.builder(
            itemCount: matchResults.requireValue.length,
            itemBuilder: (context, index) {
              MatchResult? result = matchResults.valueOrNull?[index];
              return result == null
                  ? null
                  : Padding(
                    padding: const EdgeInsets.all(5),
                    child: MatchResultCard(
                      result: result,
                      selectMode: selectedResults.isNotEmpty,
                      selected: selectedResults.contains(result.id),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (selectedResults.length < kMaxResultSelection) {
                              selectedResults.add(result.id);
                            }
                          } else {
                            selectedResults.remove(result.id);
                          }
                        });
                      },
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
                color: ColorScheme.of(context).surfaceContainerHigh,
                padding: const EdgeInsets.all(12),
                child: Column(
                  spacing: 8,
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
                                fillColor:
                                    ColorScheme.of(context).surfaceContainerLow,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    kBorderRadius,
                                  ),
                                ),
                                hintText: "Team",
                                hintStyle: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                                  dropdownMenuEntries: sortOptions,

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
                    Visibility(
                      visible: selectedResults.isNotEmpty,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed:
                                matchResults.hasValue
                                    ? () => showQRCode(
                                      matchResults.requireValue
                                          .where(
                                            (element) => selectedResults
                                                .contains(element.id),
                                          )
                                          .toList(),
                                    )
                                    : null,
                            child: Text("QR Code"),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed:
                                () => setState(() => selectedResults.clear()),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: ColorScheme.of(context).primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverVisibility(
              visible: matchResults.valueOrNull?.isNotEmpty ?? false,
              sliver: SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    selectedResults.isEmpty
                        ? "Number of Results: ${matchResults.hasError ? "error" : matchResults.value?.length ?? 0}"
                        : "Results Selected: ${selectedResults.length} / $kMaxResultSelection",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            contentBuilder.build(context),
          ],
        ),
        ResultsButtons(results: matchResults.valueOrNull),
      ],
    );
  }
}
