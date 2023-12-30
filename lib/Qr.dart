import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class qr extends StatefulWidget {
  @override
  State<qr> createState() => _qrState();
}

class _qrState extends State<qr> {
  var resurt;
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        resurt = scanData.code!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("qrCode scanner"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 5,
              child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated)),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "scan result : $resurt",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      if (resurt.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: resurt));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("copied  to clipboard")),
                        );
                      }
                    },
                    child: Text("copy"),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (resurt.isNotEmpty) {
                        // ignore: no_leading_underscores_for_local_identifiers
                        final Uri _url = Uri.parse(resurt);
                        await launchUrl(_url);
                      }
                    },
                    child: Text("open"),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
