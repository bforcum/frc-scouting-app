import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
                  data: result.toBin(),
                  errorCorrectLevel: QrErrorCorrectLevel.L,
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
