// dart
import 'package:flutter/material.dart';

// app
import 'package:go_router/go_router.dart';

class MapDeletedDialog extends StatelessWidget {
  const MapDeletedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 127,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: AlertDialog(
        icon: const RotatedBox(
            quarterTurns: 2,
            child: Center(
                child: Column(
              children: [
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.error_outline,
                      size: 27,
                    )),
              ],
            ))),
        title: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                '地図データを削除しました。',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            SizedBox(
              height: 24,
              width: 96,
              child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                    // context.go('/login/mypage/setting/detailset');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        '閉じる',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
