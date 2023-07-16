import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final List<String> qrHistory;

  const HistoryPage({Key? key, required this.qrHistory}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void deleteQRCode(int index) {
    setState(() {
      widget.qrHistory.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.qrHistory.length,
        itemBuilder: (context, index) {
          String code = widget.qrHistory[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(15,2,15,2),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: ListTile(
                tileColor: Color(0xffF2F4FF),
                title: Text(
                  code,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => deleteQRCode(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
