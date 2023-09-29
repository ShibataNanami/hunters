// dart
import 'package:flutter/material.dart';

// third party

// app
import 'package:hunters_app/button/white_button.dart';
import 'package:hunters_app/go_router/router.dart';

///QR認証失敗した際に表示するダイアログ画面
class QrcodeError extends StatelessWidget {
  const QrcodeError({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.error_outline,
        color: Colors.grey,
        size: 46,
      ),
      content: const SizedBox(
        width: 350,
        child: Text(
          '認証に失敗しました\n紹介者の端末からQRコードのスキャンを\n試してください。',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.0),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WhiteButton(
              text: '閉じる',
              route: RoutesName.first.name,
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
