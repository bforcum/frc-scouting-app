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
                          .map((e) => MatchResultCard(result: e))
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
