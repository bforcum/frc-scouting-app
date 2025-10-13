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
  late AsyncValue<List<MatchResult>> matchResults = AsyncValue.loading();

  String filterText = "";
  bool sortAscending = true;
  int sortBy = 0;
  List<String> sortOptions = [
    "New to old",
    "Old to new",
    "Match number (ascending)",
    "Match number (descending)",
    "Team number (ascending)",
    "Team number (descending)",
  ];

  @override
  Widget build(BuildContext context) {
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
                      hintText: "Filter team number",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  DropdownMenu<int>(
                    width: MediaQuery.of(context).size.width,
                    label: Text("Sort by"),
                    initialSelection: sortBy,
                    requestFocusOnTap: false,
                    keyboardType: TextInputType.none,
                    enableSearch: false,
                    dropdownMenuEntries: [
                      for (int i = 0; i < sortOptions.length; i++)
                        DropdownMenuEntry(value: i, label: sortOptions[i]),
                    ],

                    onSelected: (val) {
                      setState(() {
                        sortBy = val ?? 0;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 90),
                itemCount: ref.read(storedResultsProvider).value?.length ?? 0,
                itemBuilder: (context, index) {
                  MatchResult? result = ref
                      .read(storedResultsProvider.notifier)
                      .getResult(index);
                  if (result == null) {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: MatchResultCard(result: result)
                  );
                },
              ),
            ),
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
