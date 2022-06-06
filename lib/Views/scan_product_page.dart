import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './fetch_product.dart';

/*
  this page is used to show the scanner on the screen
  once the produced is scanned it is searched for using
  the barcode from the server
 */

class ScanPage extends StatefulWidget {
  static const routeName = 'ScanPage';

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late ScannerController _scannerController;

  bool _isGranted = false;
  String storeName = '';

  @override
  void initState() {
    super.initState();
    //this runs before the ui renders
    _startScan();
  }

  void _startScan() {
    //this starts the scan and waits for the result
    //the result is actually the barcode
    _scannerController = ScannerController(scannerResult: (result) {
      //if the barcode is valid, it is added as an argument in the fetch product page
      //which fetches the product
      if (result.isNotEmpty)
        Navigator.of(context).pushReplacementNamed(FetchProduct.routeName,
            arguments: {'storeName': storeName, 'barCode': result});
    }, scannerViewCreated: () {
      TargetPlatform platform = Theme.of(context).platform;
      if (TargetPlatform.iOS == platform) {
        Future.delayed(Duration(seconds: 2), () {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
      } else {
        _scannerController.startCamera();
        _scannerController.startCameraPreview();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
  }

  void _requestMobilePermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _isGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (storeName.isEmpty)
      storeName = ModalRoute.of(context)!.settings.arguments as String;

    TargetPlatform platform = Theme.of(context).platform;
    if (!kIsWeb) {
      if (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS) {
        _requestMobilePermission();
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    } else {
      setState(() {
        _isGranted = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.deepPurple,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        Column(
          children: <Widget>[
            _isGranted
                ? Expanded(
                    child: _getScanWidgetByPlatform(),
                  )
                : Container()
          ],
        ),
      ]),
    );
  }

  //show scanner on screen
  Widget _getScanWidgetByPlatform() {
    return PlatformAiBarcodeScannerWidget(
      platformScannerController: _scannerController,
    );
  }
}
