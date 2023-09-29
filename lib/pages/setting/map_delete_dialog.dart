// dart
import 'package:flutter/material.dart';

// third party
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/pages/setting/map_deleted_dialog.dart';

class MapDeleteDialog extends StatelessWidget {
  const MapDeleteDialog({super.key});

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
            child: Icon(
              Icons.error_outline,
              size: 27,
            )),
        title: Center(
          child: Column(
            children: [
              const Text(
                '地図データを削除しますか？',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const Text(
                '削除した場合、地図データを再ダウンロードする必要があります。',
                style: TextStyle(fontSize: 8.0),
              ),
              const SizedBox(
                height: 13.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 24,
                    width: 96,
                    child: ElevatedButton(
                        onPressed: () {
                          context.pop();
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
                        child: const Text(
                          'キャンセル',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        )),
                  ),
                  SizedBox(
                    height: 24,
                    width: 96,
                    child: ElevatedButton(
                        onPressed: () {
                          context.pop();
                          showDialog(
                              context: context,
                              builder: (_) {
                                return const MapDeletedDialog();
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
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
