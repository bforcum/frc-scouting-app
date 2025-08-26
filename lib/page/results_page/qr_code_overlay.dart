import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'package:scouting_app/main.dart';

Future<void> showQRCodeOverlay(Uint8List data) async {
  if (homeKey.currentContext == null) {
    return;
  }

  late OverlayEntry overlayEntry;

  final completer = Completer<void>();

  overlayEntry = OverlayEntry(
    builder:
        (context) => _QrCodeOverlay(
          data: data,
          onDismissed: () {
            overlayEntry.remove();
            completer.complete();
          },
        ),
  );

  Overlay.of(homeKey.currentContext!).insert(overlayEntry);

  return completer.future;
}

class _QrCodeOverlay extends StatelessWidget {
  final Function onDismissed;
  final Uint8List data;
  const _QrCodeOverlay({required this.onDismissed, required this.data});

  @override
  Widget build(BuildContext context) {
    final mainColor =
        (Theme.of(context).brightness == Brightness.light)
            ? Colors.black
            : Colors.white;
    return TapRegion(
      onTapOutside: (tap) => onDismissed(),
      child: Container(
        margin: EdgeInsets.all(40),
        alignment: Alignment.center,

        child: QRCode.withQr(
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          eyeStyle: QREyeStyle(eyeShape: QREyeShape.square, color: mainColor),
          dataModuleStyle: QRDataModuleStyle(
            dataModuleShape: QRDataModuleShape.square,
            color: mainColor,
          ),
          qr: QRCodeGenerate.fromUint8List(
            data: data,
            errorCorrectLevel: QRErrorCorrectLevel.L,
          ),
        ),
      ),
    );
  }
}
