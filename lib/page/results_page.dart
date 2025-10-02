import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/alert.dart';
import 'package:scouting_app/page/results_page/match_result_card.dart';
import 'package:scouting_app/page/results_page/scanner_page.dart';
import 'package:scouting_app/provider/match_result_provider.dart';

class ResultsPage extends ConsumerStatefulWidget {
  const ResultsPage({super.key});

  @override
  ConsumerState<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> {
  late AsyncValue<List<MatchResult>> matchResults = AsyncValue.loading();

  String filterText = "";
  bool sortAscending = true;
  int sortBy = 0;

  List<Widget> get matchResultCards {
    return matchResults.when(
      data: (results) {
        if (results.isEmpty) return [Text("No results yet")];
        return results.map((e) => MatchResultCard(result: e)).toList();
      },
      error: (error, stack) => [Text("Error loading results: $error")],
      loading: () => [CircularProgressIndicator()],
    );
  }

  @override
  Widget build(BuildContext context) {
    matchResults = ref.watch(storedResultsProvider);

    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              spacing: 20,
              children: [
                Row(
                  children: [
                    Text("Sort by: ", style: TextStyle(fontSize: 16)),
                    DropdownButton(
                      value: sortBy,
                      items: [
                        DropdownMenuItem(
                          value: 0,
                          child: Text("Time", style: TextStyle(fontSize: 16)),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            "Match Number",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text(
                            "Team Number",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        sortBy = val ?? 0;
                        setState(() {});
                      },
                    ),
                    Spacer(),
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primaryContainer,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimaryContainer,
                        ),

                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                        ),

                      ),
                      onPressed: () {
                        sortAscending = !sortAscending;
                        setState(() {});
                      },
                      child: Transform.flip(
                        flipY: sortAscending,
                        child: Icon(Icons.filter_list),
                      ),
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Filter team number",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: matchResultCards,
                ),
              ],
            ),
          ),
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
