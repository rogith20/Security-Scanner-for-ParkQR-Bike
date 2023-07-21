import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:security_scanner/homepage.dart';

class ResultScreen extends StatefulWidget {
  final String code;
  final Function()? closeScreen;
  final Function(String)? storeResult;

  const ResultScreen({
    Key? key,
    this.code = '',
    this.closeScreen,
    this.storeResult,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Handle the back button press
        return false; // Prevent navigating back
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                  data: widget.code, size: 150, version: QrVersions.auto),
              const Text(
                'Scanned Result',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Text(
                widget.code,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.popUntil(context, ModalRoute.withName('/homepage')); // Go back to the HomePage
                      // Navigator.pop(context); // Go back to the ScanQR page
                      if (widget.storeResult != null) {
                        widget.storeResult!(widget.code);
                        // isScanCompleted = false;
// Call the storeResult function if it's not null
                      }

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(initialTabIndex: 1)),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      fixedSize: MaterialStateProperty.all(Size(150, 80)),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(initialTabIndex: 0)),
                        (Route<dynamic> route) => false,
                      );
                      // Navigator.pop(context); // Go back to the ScanQR page
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      fixedSize: MaterialStateProperty.all(Size(150, 80)),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
