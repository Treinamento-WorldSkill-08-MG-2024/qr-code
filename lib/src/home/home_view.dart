import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code/src/home/player_view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _qrViewController;

  Barcode? _qrCodeResult;

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await _qrViewController.pauseCamera();
    }

    _qrViewController.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: _qrKey,
                onQRViewCreated: _onQrViewCreated,
                overlay: QrScannerOverlayShape(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: (_qrCodeResult != null)
                    ? Text(
                        'Barcode Type: ${_qrCodeResult!.format.formatName}   Data: ${_qrCodeResult!.code}',
                      )
                    : const Text('Scan a code'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQrViewCreated(QRViewController controller) {
    _qrViewController = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() => _qrCodeResult = scanData);

      if (scanData.code != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlayerView(videoURL: scanData.code!),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
  }
}
