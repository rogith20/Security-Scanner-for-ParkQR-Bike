import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewQR extends StatefulWidget {
  const ViewQR({Key? key}) : super(key: key);

  @override
  State<ViewQR> createState() => _ViewQRState();
}

class _ViewQRState extends State<ViewQR> {
  // Dummy data for the grids, original data add pannanum
  final List<Map<String, String>> dummyData = [
    {
      'bikeModel': 'Royal Enfield Classic 350',
      'vehicleNumber': 'TN06DE1234',
    },
    {
      'bikeModel': 'Bajaj Pulsar NS 200',
      'vehicleNumber': 'KL04AA000',
    },
    {
      'bikeModel': 'Suzuki Access 125',
      'vehicleNumber': 'TN09EF5420',
    },
  ];

  int? selectedGridIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.photos.request();
    Permission.storage.request();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'View your QRs',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedGridIndex = index;
              });
              _showQRPopup(context, dummyData[index]);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: selectedGridIndex == index
                    ? Colors.indigoAccent.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/qr_code.png',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/7,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/280),
                  Flexible(
                    child: Text(
                      dummyData[index]['bikeModel']!,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Flexible(
                    child: Text(
                      dummyData[index]['vehicleNumber']!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showQRPopup(BuildContext context, Map<String, String> data) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 300.0,
                height: 300.0,
                child: Image.asset(
                  'assets/qr_code.png',
                  width: 300.0,
                  height: 300.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Bike Model: ${data['bikeModel']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text('Vehicle Number: ${data['vehicleNumber']}'),
            ],
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(15.0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Disabled color
                      }
                      return const Color.fromRGBO(
                          53, 85, 235, 1); // Enabled color
                    },
                  ),
                ),
                onPressed: () async {
                  try {
                    // Get the QR code image
                    final ByteData? byteData =
                    await rootBundle.load('assets/qr_code.png');
                    if (byteData == null) return;

                    // Get the local directory path
                    final directory = await getApplicationSupportDirectory();
                    final imagePath =
                        '${directory.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';

                    // Save the image to the local directory
                    await File(imagePath)
                        .writeAsBytes(byteData.buffer.asUint8List());

                    // Check permission to access the gallery
                    final PermissionStatus status =
                    await Permission.photos.request();
                    if (status.isGranted) {
                      // Save the image to the gallery
                      final result =
                      await ImageGallerySaver.saveFile(imagePath);
                      print('QR code saved: $result');
                    } else {
                      print('Permission denied');
                    }
                  } catch (e) {
                    print('Error saving QR code: $e');
                  }

                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'Download QR',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
