// dart
import 'package:flutter/material.dart';

// app
import 'package:hunters_app/pages/setting/map_delete_dialog.dart';
import 'package:hunters_app/theme/sample_appbar.dart';

///詳細設定画面
class DetailSettingPage extends StatelessWidget {
  final _font1 = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  const DetailSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SampleAppBar(
        title: '詳細設定',
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 17,
          ),
          Stack(
            children: [
              Container(
                height: 17,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    '地図データを削除',
                    style: _font1,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    height: 24,
                    width: 96,
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return const MapDeleteDialog();
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          side: const BorderSide(
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          '削除',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 17,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'ストレージ内の地図データを全て削除いたします。',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
