// dart
import 'package:flutter/material.dart';

// third party
import 'package:hunters_app/account/blockuser/block_unblock_function.dart';
import 'package:hunters_app/account/blockuser/block_user_date.dart';
import 'package:hunters_app/theme/font_style.dart';

// app
import 'package:go_router/go_router.dart';

///ブロック解除確認のダイアログの設定
class UnblockDialog extends StatefulWidget {
  const UnblockDialog(
    String name, {
    Key? key,
  }) : super(key: key);

  @override
  State<UnblockDialog> createState() => _UnblockDialogState();
}

class _UnblockDialogState extends State<UnblockDialog> {
  // String name = '';
  // String uid = '';
  // bool onBlock = false;

  Future<void> _checkBlockUser() async {
    List<String> blockUsers = await getBlockUserUidData();
    if (blockUsers.contains('8Bik5WNMb1DyVkwNH6d7EjTB2WWO')) {
      unBlockFunction();
    } else {
      debugPrint('既にブロック解除済');
    }
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    'このユーザーのブロックを解除しますか？',
                    textAlign: TextAlign.center,
                    style: blackFont,
                  ),
                  Text(
                    '解除されたユーザーは日記の閲覧が行えるようになります。',
                    textAlign: TextAlign.center,
                    style: smallBlackFont,
                  ),
                ],
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
                        context.pop(false);
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
                    onPressed: () {
                      _checkBlockUser();
                      context.pop(true);
                    },
                    child: Text(
                      '解除',
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
