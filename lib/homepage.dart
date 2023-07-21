import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'history.dart';
import 'scanqr.dart';

List<String> qrHistory = [];

class HomePage extends StatefulWidget {
  final int initialTabIndex;

  const HomePage({Key? key, required this.initialTabIndex}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String scannedCode = '';
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, initialIndex: widget.initialTabIndex, vsync: this);

    // Initialize the camera controller only once when the HomePage is created
    _initializeCamera();
  }

  void storeResult(String result) {
    setState(() {
      scannedCode = result;
      qrHistory.add(result);
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController!.initialize();
  }

  @override
  void dispose() {
    // Dispose the camera controller only if it is not null
    _cameraController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _resetCamera() {
    // Dispose of the camera controller and reinitialize it
    _cameraController?.dispose();
    _initializeCamera().then((_) {
      setState(() {}); // Trigger a rebuild after reinitialization
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140.0),
          child: AppBar(
            elevation: 0,
            title: const Text(
              'Security Scanner',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width - 35,
                decoration: ShapeDecoration(
                  color: const Color(0xffE5E6EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(75.0),
                  ),
                ),
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: TabBar(
                    controller: _tabController,
                    indicator: null,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 2.0,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner),
                            SizedBox(width: 8.0),
                            Center(child: Text('Scan QR')),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 8.0),
                            Text('History'),
                          ],
                        ),
                      ),
                    ],
                    indicatorColor: const Color(0xff3555eb),
                    labelColor: const Color(0xff3555eb),
                    // unselectedLabelColor: const Color(0xff666791),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ScanQR(
                    cameraController:
                        _cameraController, // Pass the camera controller
                    storeResult: storeResult,
                    resetCamera: _resetCamera, // Pass the resetCamera function
                  ),
                  HistoryPage(qrHistory: qrHistory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
