// dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// app
import 'package:hunters_app/anonymous_users/launch_anonymous_user.dart';
import 'package:hunters_app/dialog/qrcode_error_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

///QRコードスキャン画面
class QRCodeScanPage extends StatefulWidget {
  const QRCodeScanPage({super.key});

  @override
  QRCodeScanPageState createState() => QRCodeScanPageState();
}

class QRCodeScanPageState extends State<QRCodeScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  ///QRコードエラーダイアログを呼び出し
  void _qrcodeErrorDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const QrcodeError();
      },
    );
  }

  ///QRコードのデータの読み込み及び、データが一致しているか確認する処理
  String qrData = '';
  bool isProcessing = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    String qrData = '';
    bool isProcessing = false;
    String introducerUid = '';
    String password = '';
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) {
        return;
      }
      isProcessing = true;
      setState(() {
        qrData = scanData.code!;
        controller.dispose();
        debugPrint(qrData);
      });
      if (qrData.isEmpty) {
        _qrcodeErrorDialog();
      } else {
        final List<String> qrValues = qrData.split('\n');
        if (qrValues.length == 2) {
          introducerUid = qrValues[0].split(':')[1].trim();
          password = qrValues[1].split(':')[1].trim();
          if (introducerUid.isNotEmpty && password.isNotEmpty) {
            final String combinedData =
                'introducerId : $introducerUid\npassword : $password';
            if (combinedData == qrData) {
              controller.dispose();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LaunchAnonymousUser(
                    introducerUid: introducerUid,
                    password: password,
                  ),
                ),
              );
            } else {
              _qrcodeErrorDialog();
            }
          } else {
            _qrcodeErrorDialog();
          }
        } else {
          _qrcodeErrorDialog();
        }
      }
      isProcessing = false;
      controller.pauseCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.black),
      ),
      bottomNavigationBar: const BottomAppBar(
        height: 50,
        elevation: 5,
        shape: AutomaticNotchedShape(Border(
            bottom: BorderSide(
                color: Color.fromARGB(255, 101, 100, 100), width: 5))),
        color: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('QRコードをスキャンしてHUNTERSを開始してください。'),
            ),
          )
        ],
      ),
    );
  }
}
