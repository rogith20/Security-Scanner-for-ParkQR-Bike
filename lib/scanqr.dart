import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:security_scanner/result_screen.dart';

const bgColor = Color(0xfffafafa);

//
// class ScanQR extends StatefulWidget {
//   final CameraController cameraController;
//
//   final Function(String)? storeResult;
//   // Define the storeResult parameter
//
//   const ScanQR(
//       {this.storeResult,
//       Key? key,
//       required this.cameraController,
//       required void Function() resetCamera})
//       : super(key: key);
//   @override
//   State<ScanQR> createState() => _ScanQRState();
// }
//
// class _ScanQRState extends State<ScanQR> {
//   bool isScanCompleted = false;
//
//   void closeScreen() {
//     isScanCompleted = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     color: bgColor,
//                     child: const Column(
//                       children: [
//                         Text('Place the QR Code in the area'),
//                         Text('Scanning will be started automatically'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Container(
//                 decoration:
//                     BoxDecoration(border: Border.all(color: Colors.red)),
//                 child: MobileScanner(
//                   allowDuplicates: true,
//                   onDetect: (barcode, args) {
//                     if (!isScanCompleted) {
//                       String code = barcode.rawValue ?? "---";
//                       isScanCompleted = true;
//                       // widget.storeResult!(code); // Call the storeResult callback
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ResultScreen(
//                             code: code,
//                             closeScreen: closeScreen,
//                             storeResult: widget
//                                 .storeResult, // Pass the storeResult callback to ResultScreen
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: bgColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ScanQR extends StatefulWidget {
  final CameraController? cameraController; // Make it nullable
  final Function(String)? storeResult;
  final Function()? resetCamera; // Pass the resetCamera function

  const ScanQR({
    this.cameraController,
    this.storeResult,
    this.resetCamera,
    Key? key,
  }) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  bool isScanCompleted = false;

  @override
  void initState() {
    super.initState();
    // If the cameraController is null, call the resetCamera function to initialize it
    if (widget.cameraController == null) {
      widget.resetCamera?.call();
    }
  }

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the camera is being initialized
    if (widget.cameraController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                child: MobileScanner(
                  allowDuplicates: true,
                  onDetect: (barcode, args) {
                    if (!isScanCompleted) {
                      String code = barcode.rawValue ?? "---";
                      isScanCompleted = true;
                      // widget.storeResult!(code); // Call the storeResult callback
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            code: code,
                            closeScreen: closeScreen,
                            storeResult: widget
                                .storeResult, // Pass the storeResult callback to ResultScreen
                          ),
                        ),
                      );
                    }
                  },
                ),
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
