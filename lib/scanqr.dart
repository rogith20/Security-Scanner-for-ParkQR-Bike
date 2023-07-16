import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:security_scanner/result_screen.dart';

const bgColor = Color(0xfffafafa);

class ScanQR extends StatefulWidget {
  final Function(String)? storeResult; // Define the storeResult parameter

  const ScanQR({this.storeResult, Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  bool isScanCompleted = false;

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: bgColor,
                    child: const Column(
                      children: [
                        Text('Place the QR Code in the area'),
                        Text('Scanning will be started automatically'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: MobileScanner(
                allowDuplicates: true,
                onDetect: (barcode, args) {
                  if (!isScanCompleted) {
                    String code = barcode.rawValue ?? "---";
                    isScanCompleted = true;
                    widget.storeResult!(code); // Call the storeResult callback
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          code: code,
                          closeScreen: closeScreen,
                          storeResult: widget.storeResult, // Pass the storeResult callback to ResultScreen
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                color: bgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
