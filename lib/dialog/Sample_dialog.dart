import 'package:flutter/material.dart';
import 'package:hunters_app/theme/font_style.dart';

///ダイアログの設定（ボタン１つ）
class SampleDialog extends StatelessWidget {
  final String text;
  final Function myFunction;

  const SampleDialog({
    super.key,
    required this.text,
    required this.myFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 299,
        height: 127,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 13),
              child: Icon(
                Icons.error_outline,
                color: Colors.grey,
                size: 27,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Align(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: blackFont,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
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
                    myFunction();
                  },
                  child: Text(
                    '閉じる',
                    style: blackFont,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
