import 'dart:io';

import 'package:flutter/material.dart';
import 'package:masterwifi/qr_action_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Qrcodescreen extends StatefulWidget {
  const Qrcodescreen({super.key});

  @override
  State<Qrcodescreen> createState() => _QrcodescreenState();
}

class _QrcodescreenState extends State<Qrcodescreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  @override
  void reassemble() {
    super.reassemble();
    if (qrController != null) {
      if (Platform.isAndroid) {
        qrController!.pauseCamera();
      }
      qrController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });

    bool navigationTriggered = false;

    controller.scannedDataStream.listen((scanData) {
      if (!navigationTriggered && scanData.code != null) {
        navigationTriggered = true;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrActionScreen(qrCodeData: scanData.code!),
          ),
        ).then((_) {
          navigationTriggered = false;
        });
      }
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
