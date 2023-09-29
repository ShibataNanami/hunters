// dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF006400),
              width: double.infinity,
              height: 220,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: Column(
                children: [
                  const Text(
                    'サーバーのメンテナンス中です。\n申し訳ございませんが、しばらくお待ちください。',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: SizedBox(
                      height: 30,
                      width: 130,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: const Text(
                          'アプリを閉じる',
                          style: TextStyle(
                            color: Colors.black, //テキストの色
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 220,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
