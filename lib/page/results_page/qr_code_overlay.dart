import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/main.dart';
import 'package:scouting_app/model/match_result.dart';

void showQRCodeOverlay(MatchResult result) {
  if (homeKey.currentContext == null) {
    return;
  }

  showDialog(
    context: homeKey.currentContext!,
    builder: (context) {
      final mainColor =
          (Theme.of(context).brightness == Brightness.light)
              ? Colors.black
              : Colors.white;
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QRCode.withQr(
                eyeStyle: QREyeStyle(
                  eyeShape: QREyeShape.square,
                  color: mainColor,
                ),
                dataModuleStyle: QRDataModuleStyle(
                  dataModuleShape: QRDataModuleShape.square,
                  color: mainColor,
                ),
                qr: QRCodeGenerate.fromUint8List(
                  data: result.toBin(),
                  errorCorrectLevel: QRErrorCorrectLevel.L,
                ),
              ),
              Text(
                "Team ${result.teamNumber} - Match ${result.matchNumber}",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
    },
  );
}
