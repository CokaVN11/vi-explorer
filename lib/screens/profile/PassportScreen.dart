import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Grid Example',
      home: GridExample(),
    );
  }
}

class GridExample extends StatelessWidget {
  const GridExample({super.key});

  Future<void> _scanQR() async {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    List<String> parts = qrCode.split('\n');
    log(qrCode);
    if (parts.length != 2) {
      log('Invalid QR code');
      return;
    }
    String provinceCode = parts[0].substring(9, 12);
    log(provinceCode);
    if (provinceCode == '001') {
      Fluttertoast.showToast(msg: "Bạn vừa đến Hà Nội");
    } else if (provinceCode == '068') {
      Fluttertoast.showToast(msg: "Bạn vừa đến Lâm Đồng");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Hộ chiếu ảo',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          backgroundColor: const Color(0xFF12372A),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          // Number of columns
          crossAxisSpacing: 10.0,
          // Spacing between columns
          mainAxisSpacing: 10.0,
          // Spacing between rows
          padding: const EdgeInsets.all(10.0),
          children: const <Widget>[
            GridItemWidget('hn.jpg', 'Hà Nội'),
            GridItemWidget('ld.jpg', 'Lâm Đồng'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            _scanQR();
          },
          backgroundColor: const Color(0xFF436850),
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
          ),
        ));
  }
}

class GridItemWidget extends StatelessWidget {
  final String imagePath, name;

  const GridItemWidget(this.imagePath, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              // Adjust the radius as needed
              child: Image(
                image: AssetImage('assets/images/$imagePath'),
                height: 93,
                width: 93,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ));
  }
}
