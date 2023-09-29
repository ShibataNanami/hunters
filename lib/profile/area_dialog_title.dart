// dart
import 'package:flutter/material.dart';

///活動エリアダイアログのエリアタイトルの設定
class ListTitle extends StatelessWidget {
  final String title;
  const ListTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 5, 0, 5),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
