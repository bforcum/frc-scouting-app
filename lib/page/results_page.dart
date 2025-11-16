import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/alert.dart';
import 'package:scouting_app/page/results_page/match_result_card.dart';
import 'package:scouting_app/page/results_page/scanner_page.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class ResultsPage extends ConsumerStatefulWidget {
  const ResultsPage({super.key});

  @override
  ConsumerState<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> {
  late AsyncValue<List<MatchResult>> matchResults = AsyncValue.loading();

  String searchText = "";
  bool sortAscending = true;
  SortType sortBy = SortType.values[0];
  List<String> sortOptions = [
    "Match (first to last)",
    "Match (last to first)",
    "Team Num (low to high)",
    "Team Num (high to low)",
  ];

  @override
  Widget build(BuildContext context) {
    var indices = ref.watch(ResultIndicesProvider(sortBy, searchText));

    var contentBuilder = Builder(
      builder: (context) {
        if (indices.hasError) {
          return SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Error encountered: ${indices.error}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }
        if (indices.isLoading) {
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
        if (indices.value!.isEmpty) {
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
            itemCount: indices.value?.length ?? 0,
            itemBuilder: (context, index) {
              MatchResult? result = ref
                  .read(storedResultsProvider.notifier)
                  .getResult(indices.value![index]);
              if (result == null) {
                return SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: MatchResultCard(result: result),
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
                    Text(
                      "Number of Results: ${indices.value?.length ?? 0}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            contentBuilder.build(context),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: ElevatedButton(
            onPressed: qrScan,
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(CircleBorder()),
              padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer,
              ), // <-- Button color
            ),
            child: Icon(Icons.qr_code_scanner, size: 30),
          ),
        ),
      ],
    );
  }

  Future<void> qrScan() async {
    Uint8List? data = await Navigator.of(context).push<Uint8List?>(
      MaterialPageRoute(
        builder:
            (context) => ScannerPage(
              onDetect: (value) {
                debugPrint(context.widget.toString());
                Navigator.pop(context, value);
              },
            ),
      ),
    );
    if (data == null) {
      return;
    }
    late final MatchResult result;
    try {
      result = MatchResult.fromBin(data);
    } catch (error) {
      await showAlertDialog(
        "Invalid code",
        "This QR code probably didn't come from this app",
        "Okay",
      );
      return;
    }

    final error = await ref
        .read(storedResultsProvider.notifier)
        .addResult(result);

    if (error != null) {
      showAlertDialog("Conversion Error", error, "Okay");
      return;
    }
  }
}
