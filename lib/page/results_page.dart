import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    "Match number (ascending)",
    "Match number (descending)",
    "Team number (ascending)",
    "Team number (descending)",
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
              child: Text("Error encountered: ${indices.error}"),
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
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("No results"),
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
