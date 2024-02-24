import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class GridExample extends StatefulWidget {
  const GridExample({Key? key}) : super(key: key);

  @override
  _GridExampleState createState() => _GridExampleState();
}

class _GridExampleState extends State<GridExample> {
  late SharedPreferences _prefs;
  List<String> visitedProvinces = [];

  @override
  void initState() {
    super.initState();
    _loadVisitedProvinces();
  }

  Future<void> _loadVisitedProvinces() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      visitedProvinces = _prefs.getStringList('visitedProvinces') ?? [];
    });
  }

  Future<void> _saveVisitedProvinces() async {
    await _prefs.setStringList('visitedProvinces', visitedProvinces);
  }

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
    setState(() {
      visitedProvinces.add(provinceCode);
      _saveVisitedProvinces();
    });

    // Show toast
    switch (provinceCode) {
      case '001':
        Fluttertoast.showToast(msg: "Bạn vừa đến Hà Nội");
        break;
      case '068':
        Fluttertoast.showToast(msg: "Bạn vừa đến Lâm Đồng");
        break;
      case '079':
        Fluttertoast.showToast(msg: "Bạn vừa đến TP.Hồ Chí Minh");
        break;
      default:
        Fluttertoast.showToast(msg: "Mã chưa được hỗ trợ");
        break;
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
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          GridItemWidget(
            'hn.jpg',
            'Hà Nội',
            visitedProvinces.contains('001'),
          ),
          GridItemWidget(
            'ld.jpg',
            'Lâm Đồng',
            visitedProvinces.contains('068'),
          ),
          GridItemWidget(
            'hcm.jpg',
            'TP.Hồ Chí Minh',
            visitedProvinces.contains('079'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scanQR();
        },
        backgroundColor: const Color(0xFF436850),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
        ),
      ),
    );
  }
}

class GridItemWidget extends StatelessWidget {
  final String imagePath, name;
  final bool isScanned;

  const GridItemWidget(this.imagePath, this.name, this.isScanned, {super.key});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        isScanned ? Colors.green.withOpacity(0.3) : Colors.transparent;
    return Container(
      decoration: BoxDecoration(
        border: isScanned ? Border.all(color: Colors.green, width: 2.0) : null,
        color: backgroundColor,
      ),
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image(
                image: AssetImage('assets/images/$imagePath'),
                height: 93,
                width: 93,
                fit: BoxFit.cover,
              ),
            ),
            if (isScanned)
              const Flexible(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
