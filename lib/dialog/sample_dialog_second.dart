// dart
import 'package:flutter/material.dart';

// app
import 'package:hunters_app/theme/font_style.dart';
import 'package:go_router/go_router.dart';

///ダイアログの設定（ボタン2つ）
class SampleDialogSecond extends StatefulWidget {
  final String text;
  final String text2;
  final String text3;
  final String route;
  final Function myFunction;

  const SampleDialogSecond({
    Key? key,
    required this.text,
    required this.text2,
    required this.text3,
    required this.route,
    required this.myFunction,
  }) : super(key: key);

  @override
  State<SampleDialogSecond> createState() => _SampleDialogSecondState();
}

class _SampleDialogSecondState extends State<SampleDialogSecond> {
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
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: blackFont,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 27, 0),
                  child: SizedBox(
                    height: 20,
                    width: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(10, 1, 10, 3),
                        side: const BorderSide(color: Colors.black),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        widget.text2,
                        style: blackFont,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
                      backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      widget.myFunction();
                      widget.route.isNotEmpty
                          ? context.pushReplacementNamed(widget.route)
                          : context.pop();
                    },
                    child: Text(
                      widget.text3,
                      style: whiteFont,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
