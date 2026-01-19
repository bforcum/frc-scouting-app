import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/model/game_format.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/common/alert.dart';
import 'package:scouting_app/page/common/confirmation.dart';
import 'package:scouting_app/page/common/snack_bar_message.dart';
import 'package:scouting_app/page/results_page/scanner_page.dart';
import 'package:scouting_app/provider/database_provider.dart';
import 'package:scouting_app/provider/settings_provider.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';
import 'package:share_plus/share_plus.dart';

class ResultsButtons extends ConsumerStatefulWidget {
  final List<MatchResult>? results;

  const ResultsButtons({super.key, required this.results});

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
              SpeedDialChild(
                label: "Export to CSV",
                shape: CircleBorder(),
                child: Icon(Icons.file_upload, size: 30),
                onTap: () => exportToExcel(),
              ),
              // SpeedDialChild(
              //   label: "Import from CSV",
              //   shape: CircleBorder(),
              //   child: Icon(Icons.file_download, size: 30),
              // ),
              SpeedDialChild(
                label: "Delete selected results",
                shape: CircleBorder(),

                child: Icon(Icons.delete_forever, size: 30),
                onTap: () async {
                  if (widget.results == null) {
                    showSnackBarMessage("Nothing to delete");
                  }
                  if (!await showConfirmationDialog(
                    ConfirmationInfo(
                      title: "Delete visible results",
                      content:
                          "Are you sure you want to delete all match results currently on this page? This action cannot be undone.",
                    ),
                  )) {
                    return;
                  }
                  List<BigInt> uuids =
                      widget.results!.map((e) => e.id).toList();
                  ref
                      .read(databaseProvider)
                      .managers
                      .matchResults
                      .filter((e) => e.uuid.isIn(uuids))
                      .delete();
                  ref.invalidate(storedResultsProvider);
                },
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
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            child: SizedBox(
              width: 54,
              height: 54,
              child: Icon(
                Icons.qr_code_scanner,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 30,
              ),
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
    final MatchResult? result = MatchResult.fromBin(data);
    if (result == null) {
      await showAlertDialog(
        title: "Invalid code",
        content: "This QR code probably didn't come from this app",
        closeMessage: "Okay",
      );
      return;
    }

    final error = await ref
        .read(storedResultsProvider.notifier)
        .addResult(result);

    if (error != null) {
      showAlertDialog(
        title: "Error with Saving",
        content: error,
        closeMessage: "Okay",
      );
      return;
    }
  }

  Future<void> exportToExcel() async {
    if (widget.results == null) {
      showAlertDialog(
        title: "Failed to export",
        content: "No results yet",
        closeMessage: "Ok",
      );
      return;
    }

    String? selectedEvent = ref.read(settingsProvider).selectedEvent;
    GameFormat gameFormat = ref.read(settingsProvider).gameFormat;

    Excel excel = Excel.createExcel();
    final String sheetName =
        "${gameFormat.name}-${selectedEvent ?? "All Events"}";
    excel.rename("Sheet1", sheetName);
    Sheet sheetObject = excel[sheetName];

    sheetObject.appendRow([
      TextCellValue("Event:"),
      TextCellValue(selectedEvent ?? "All Events"),
      TextCellValue("Game format:"),
      TextCellValue(gameFormat.name),
    ]);
    sheetObject.appendRow([
      if (selectedEvent == null) TextCellValue("Event"),
      TextCellValue("Team #"),
      TextCellValue("Match #"),
      TextCellValue("Time"),
      TextCellValue("Scout name"),
      ...gameFormat.questions.map((q) => TextCellValue(q.label)),
    ]);

    for (MatchResult result in widget.results!) {
      // Include event if this sheet doesn't correspond to a specific event
      sheetObject.appendRow(result.toExcel(withEvent: selectedEvent == null));
    }

    String fileName =
        "Scouting_Results_"
        "${DateTime.now().year.toString()}_"
        "${DateTime.now().month.toString().padLeft(2, '0')}_"
        "${DateTime.now().day.toString().padLeft(2, '0')}_"
        "${DateTime.now().hour.toString().padLeft(2, '0')}"
        "${DateTime.now().minute.toString().padLeft(2, '0')}";
    List<int> fileBytes = excel.save()!;

    final Directory dir = await getTemporaryDirectory();
    String filePath = p.join(dir.path, "$fileName.xlsx");
    if (Platform.isWindows) filePath = filePath.replaceAll("/", r"\");
    debugPrint(filePath);
    var file = File(filePath);
    file.writeAsBytes(fileBytes);
    // await xFile.saveTo("${dir.path}/$fileName.xlsx");
    // XFile savedFile = XFile("${dir.path}/$fileName.xlsx");
    ShareResult result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath)],
        fileNameOverrides: ["$fileName.xlsx"],
      ),
    );
    debugPrint(result.status.toString());
    debugPrint(result.raw);
  }
}
