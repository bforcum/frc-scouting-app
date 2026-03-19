import 'package:buffer/buffer.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scouting_app/main.dart';
import 'package:scouting_app/model/match_result.dart';

void showQRCode(List<MatchResult> results) {
  if (homeKey.currentContext == null || results.isEmpty) {
    return;
  }
  final writer = ByteDataWriter();
  writer.write([results.length]);
  for (MatchResult result in results) {
    writer.write(result.toBin());
  }

  showDialog(
    context: homeKey.currentContext!,
    builder: (context) {
      final mainColor =
          (Theme.of(context).brightness == Brightness.light)
              ? Colors.black
              : Colors.white;
      return LayoutBuilder(
        builder: (context, constraints) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainerHigh,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QrImageView.withQr(
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: mainColor,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: mainColor,
                    ),
                    qr: QrCode.fromUint8List(
                      data: writer.toBytes(),
                      errorCorrectLevel: QrErrorCorrectLevel.L,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children:
                          results
                              .map(
                                (result) => Text(
                                  "Team ${result.teamNumber} - Match ${result.matchNumber}",
                                  style: TextTheme.of(context).bodyLarge,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
