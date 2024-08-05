import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../components/AppBarContainer.dart';
import '../utils/constants.dart';

class BarcodeScannerPage extends StatefulWidget {
  static const String id = 'barcode_scanner_page';

  const BarcodeScannerPage({super.key});

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String scanResult = 'Scanning...';
  String delegateID = '';
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => scanBarcode());
  }

  Future<void> scanBarcode() async {
    try {
      delegateID = '';
      var result = await BarcodeScanner.scan();
      if (!mounted) return;
      setState(() {
        if (result.rawContent.isEmpty) {
          scanResult = 'No barcode detected';
        } else {
          scanResult = result.rawContent;
          int pos = scanResult.indexOf('\t');
          delegateID = scanResult.substring(0, pos);
          fetchQrService(delegateID);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        scanResult = 'Failed to scan the barcode: $e';
      });
    }
  }

  Future<void> fetchQrService(String delegateID) async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";
    String url = 'scan_qr_services.php';
    FormData formData = FormData.fromMap({
      "volunteer_id": glbID,
      "service_id": glbServiceId,
      "user_id": delegateID,
    });
    await dio.post(url, data: formData).then((value) {
      setState(() {
        isSuccess = value.data["status"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (isSuccess) {
      iconWidget = const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 100, color: Colors.green),
          Text("Access Allowed", style: TextStyle(color: Colors.green, fontSize: 16)),
        ],
      );
    } else {
      iconWidget = const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.close, size: 100, color: Colors.red),
          Text("Access Denied", style: TextStyle(color: Colors.red, fontSize: 16)),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Status', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: const AppBarContainer(),
      ),
      body: Center(
        child: iconWidget,
      ),
    );
  }
}
