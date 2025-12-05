import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/alert.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/results_page/scanner_page.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class ResultsButtons extends ConsumerStatefulWidget {
  const ResultsButtons({super.key});

  @override
  ConsumerState<ResultsButtons> createState() => _ResultsButtonsState();
}

class _ResultsButtonsState extends ConsumerState<ResultsButtons>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 140),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,

      child: Column(
        spacing: 10,
        children: [
          SpeedDial(
            childPadding: EdgeInsets.all(0),
            spaceBetweenChildren: 10,
            buttonSize: Size(54, 54),
            children: [
              // SpeedDialChild(
              //   label: "Export to CSV",
              //   shape: CircleBorder(),
              //   child: Icon(Icons.file_upload, size: 30),
              // ),
              // SpeedDialChild(
              //   label: "Import from CSV",
              //   shape: CircleBorder(),
              //   child: Icon(Icons.file_download, size: 30),
              // ),
              SpeedDialChild(
                label: "Delete all results",
                shape: CircleBorder(),

                child: Icon(Icons.delete_forever, size: 30),
                onTap:
                    () => showConfirmationDialog(
                      ConfirmationInfo(
                        title: "Delete all results",
                        content:
                            "Are you sure you want to delete all stored match results? This action cannot be undone.",
                      ),
                    ).then((confirmed) {
                      if (confirmed) {
                        ref.read(storedResultsProvider.notifier).clearAll();
                      }
                    }),
              ),
            ],
            animationDuration: Duration(milliseconds: 200),
            overlayColor: Theme.of(context).colorScheme.surfaceDim,
            activeChild: Icon(Icons.close, size: 30),
            child: Icon(Icons.more_horiz, size: 30),
          ),
          ElevatedButton(
            onPressed: qrScan,
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(CircleBorder()),
              padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            child: Icon(
              Icons.qr_code_scanner,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 30,
            ),
          ),
        ],
      ),
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
      showAlertDialog("Saving Error", error, "Okay");
      return;
    }
  }
}
