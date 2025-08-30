import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  final void Function(Uint8List?) onDetect;

  const ScannerPage({super.key, required this.onDetect});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows || Platform.isLinux) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Scan Match Result QR Code"),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Scanning not supported on Windows and Linux",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Scan Match Result QR Code"),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (result) {
          _controller.pause();
          widget.onDetect(result.barcodes.first.rawBytes);
        },
      ),
    );
  }
}
