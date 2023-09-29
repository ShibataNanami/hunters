// dart
import 'package:flutter/material.dart';

// app
import 'package:hunters_app/theme/sample_appbar.dart';

///アプリについての画面
class AppInformationPage extends StatelessWidget {
  final _font1 = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  const AppInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SampleAppBar(
        title: 'アプリについて',
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 14,
          ),
          SizedBox(
            height: 24,
            child: GestureDetector(
                onTap: () {
                  // 外部サイトへ
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '利用規約',
                      style: _font1,
                    ),
                  ),
                )),
          ),
          const SizedBox(
            height: 14,
          ),
          SizedBox(
            height: 24,
            child: GestureDetector(
                onTap: () {
                  // 外部サイトへ
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'ライセンス',
                      style: _font1,
                    ),
                  ),
                )),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 24,
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'アプリケーションバージョン',
                      style: _font1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '0.0.00',
                        style: _font1,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
