import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 290,
              child: Container(
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 160.0),
                child: Column(
                  children: [
                    const Text(
                      'アプリケーションに新しいバージョンがあります。\n更新後、再起動してください。',
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: SizedBox(
                        height: 30,
                        width: 130,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text(
                            'アプリストアへ',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
