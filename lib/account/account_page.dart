// dart
import 'package:flutter/material.dart';

// third party
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/dialog/sample_dialog_second.dart';
import 'package:hunters_app/go_router/router.dart';
import 'package:hunters_app/theme/sample_appbar.dart';

///アカウント設定画面
class AccountSetPage extends StatelessWidget {
  const AccountSetPage({super.key});

  ///ログアウトのダイアログ呼び出し
  Future<void> logoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SampleDialogSecond(
          text: 'ログアウトしますか？',
          text2: 'キャンセル',
          text3: 'ログアウト',
          route: RoutesName.login.name,
          myFunction: _signOut,
        );
      },
    );
  }

  ///サインインしている場合はfirebaseをログアウトする処理
  Future<void> _signOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      debugPrint('ログアウトしました${user.email}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SampleAppBar(
        title: 'アカウント',
      ),
      body: SizedBox(
        child: Center(
          child: ListView(
            children: [
              //「未登録」のテキストを入れているが、登録されたら表示を変えるように後ほど設定
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _customListTile(
                  context,
                  'メールアドレス連携',
                  RoutesName.linkEmail.name,
                  '未登録',
                ),
              ),
              _customListTile(
                context,
                'プロフィール編集',
                RoutesName.profileEdit.name,
                '',
              ),
              _customListTile(
                context,
                'ブロック中のユーザー',
                RoutesName.blockUserList.name,
                '',
              ),
              _customListTile(
                context,
                'ログアウト',
                '',
                '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///リストの設定
  SizedBox _customListTile(
    BuildContext context,
    String text,
    String route,
    String text2,
  ) {
    Color textColor = Colors.black;
    if (text == 'ログアウト') {
      textColor = Colors.black38;
    }
    return SizedBox(
      height: 33,
      child: InkWell(
        onTap: () {
          if (text == 'ログアウト') {
            logoutDialog(context);
          } else {
            context.pushNamed(route);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
            ),
            const Spacer(),
            if (text != 'ログアウト')
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  text2,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 12,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
