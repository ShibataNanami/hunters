// dart
import 'package:flutter/material.dart';

// third party
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/dialog/Sample_dialog.dart';

// app
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

///パスワードリセットのダイアログ表示
class PassReset extends StatefulWidget {
  final String email;

  const PassReset({Key? key, required this.email}) : super(key: key);

  @override
  State<PassReset> createState() => _PassResetState();
}

class _PassResetState extends State<PassReset> {
  Future<void> _passResetDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SampleDialog(
          text: ' 入力されたメールアドレス宛へ\nパスワードを送信しました。',
          myFunction: context.pop,
        );
      },
    );
  }

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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '入力されたメールアドレス宛へ\nパスワードの送信を行いますか？',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
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
                        padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
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
                        'キャンセル',
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
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: widget.email);
                        if (context.mounted) {
                          context.pop();
                        }
                        _passResetDialog();
                        debugPrint("パスワードリセット用のメールを送信しました");
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                    child: Text(
                      '送信',
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
