// dart
import 'package:flutter/material.dart';

// third party
import 'package:go_router/go_router.dart';

// app

// app

///白ボタンの設定（「閉じる・キャンセル」等のボタン設定時に使用）
class WhiteButton extends StatelessWidget {
  final String text;
  final String route;

  const WhiteButton({
    super.key,
    required this.text,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
          side: const BorderSide(color: Colors.black),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          context.pushReplacementNamed(route);
        },
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
