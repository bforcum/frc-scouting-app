import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late AsyncValue<List<MatchResult>> matchResults;

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
                  children: matchResults.when(
                    loading: () => [CircularProgressIndicator()],
                    error:
                        (error, stack) => [
                          Text("Something went wrong: \n$error"),
                        ],
                    data: (results) {
                      if (results.isEmpty) return [Text("No results yet")];
                      return results
                          .map((e) => MatchResultCard(matchResult: e))
                          .toList();
                    },
                  ),
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
              padding: WidgetStatePropertyAll(EdgeInsets.all(25)),
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
        builder: (context) => ScannerPage(onDetect: Navigator.of(context).pop),
      ),
    );
    if (data == null) {
      showAlertDialog(
        "Scanning Failed",
        "Could not get data from the QR code",
        "Okay",
      );
      return;
    }

    final result = MatchResult.fromBin(data);

    ref.read(storedResultsProvider.notifier).addResult(result);

    // TODO fix random crashing after adding match result
  }
}
