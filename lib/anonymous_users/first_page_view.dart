// dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// third party
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

// app
import 'package:hunters_app/go_router/router.dart';

///AnonymousUserの初期画面
class FirstPageView extends StatelessWidget {
  const FirstPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.black),
      ),
      body: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 100, 40, 0),
            child: GestureDetector(
              onTap: () async {
                if (await Permission.camera.request().isGranted) {
                  if (context.mounted) {
                    context.pushNamed(RoutesName.scanQr.name);
                  }
                } else {
                  if (context.mounted) {
                    await showRequestPermissionDialog(context);
                  }
                }
              },
              child: const Text(
                'QRコードをスキャン',
                style: TextStyle(
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QRコードをスキャンをタップするとカメラが起動します。',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              '紹介者の方の端末からQRコードを読み込んでください。',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                context.pushNamed(RoutesName.login.name);
              },
              child: const Text(
                '既にIDをお持ちの方はこちら',
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> showRequestPermissionDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('カメラを許可してください'),
          content: const Text('QRコードを読み取る為にカメラを利用します'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () async {
                openAppSettings();
              },
              child: const Text('設定'),
            ),
          ],
        );
      },
    );
  }
}
