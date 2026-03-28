import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
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
                label: "Export to Excel",
                shape: CircleBorder(),
                child: Icon(Icons.file_upload, size: 30),
                onTap: () => exportToExcel(),
              ),
              SpeedDialChild(
                label: "Import from Excel",
                shape: CircleBorder(),
                child: Icon(Icons.file_download, size: 30),
                onTap: importFromExcel,
              ),
              SpeedDialChild(
                label: "Delete listed results",
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
                  ref.read(storedResultsProvider.notifier).deleteByUuid(uuids);
                },
              ),
            ],
            animationDuration: Duration(milliseconds: 200),
            overlayColor: ColorScheme.of(context).surfaceDim,
            activeChild: Icon(Icons.close, size: 30),
            child: Icon(Icons.more_horiz, size: 30),
          ),
          ElevatedButton(
            onPressed: qrScan,
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(CircleBorder()),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              backgroundColor: WidgetStatePropertyAll(
                ColorScheme.of(context).primaryContainer,
              ),
            ),
            child: SizedBox(
              width: 54,
              height: 54,
              child: Icon(
                Icons.qr_code_scanner,
                color: ColorScheme.of(context).onPrimaryContainer,
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
                Navigator.pop(context, value);
              },
            ),
      ),
    );
    if (data == null) {
      return;
    }
    final List<MatchResult> results = MatchResult.fromQR(data);
    if (results.isEmpty) {
      await showAlertDialog(
        title: "Invalid code",
        content: "This QR code probably didn't come from this app",
        closeMessage: "Okay",
      );
      return;
    }

    final error = await ref
        .read(storedResultsProvider.notifier)
        .addAllResults(results);

    if (error != null) {
      showSnackBarMessage(error);
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
      IntCellValue(gameFormat.id),
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
    var file = File(filePath);
    file.writeAsBytes(fileBytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath)],
        fileNameOverrides: ["$fileName.xlsx"],
      ),
    );
  }

  Future<void> importFromExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Select a spreadsheet that came from this app",
      type: FileType.custom,
      allowedExtensions: ["xlsx"],
    );
    if (result == null) {
      showSnackBarMessage("No file recieved");
      return;
    }
    if (!result.xFiles[0].name.endsWith(".xlsx")) {
      showSnackBarMessage("Incorrect file type");
      return;
    }
    Excel excel = Excel.decodeBytes(await result.xFiles[0].readAsBytes());
    Sheet sheet = excel.tables.values.first;

    int id = (sheet.rows[0][4]?.value as IntCellValue?)?.value ?? -1;
    GameFormat? gameFormat = GameFormat.values.singleWhereOrNull(
      (f) => f.id == id,
    );
    if (gameFormat == null) {
      showSnackBarMessage("No game format decoded");
      return;
    }
    String? eventCode = (sheet.rows[0][1]?.value as TextCellValue?)?.value.text;
    if (eventCode == null) {
      showSnackBarMessage("No event code decoded");
      return;
    }
    if (eventCode.toLowerCase() == "all events") {
      eventCode = null;
    }

    List<MatchResult> results = [];
    int failures = 0;
    for (List<Data?> row in sheet.rows.skip(2)) {
      try {
        results.add(MatchResult.fromExcel(row, gameFormat, eventCode));
      } catch (e) {
        debugPrint(e.toString());
        failures++;
      }
    }
    String? error = await ref
        .read(storedResultsProvider.notifier)
        .addAllResults(results);
    if (error == null) {
      showSnackBarMessage("Failures: $failures");
    } else {
      showSnackBarMessage("Failures: $failures, error: $error");
    }
  }
}
