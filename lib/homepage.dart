import 'package:flutter/material.dart';

import 'history.dart';
import 'scanqr.dart';

String scannedCode = '';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, initialIndex: widget.initialTabIndex, vsync: this);
  }

  void storeResult(String result) {
    setState(() {
      scannedCode = result;
      qrHistory.add(result);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  ScanQR(storeResult: storeResult),
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
