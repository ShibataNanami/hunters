// dart
import 'package:flutter/material.dart';
import 'package:hunters_app/go_router/router.dart';

// third party
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/theme/sample_appbar.dart';
import 'package:hunters_app/dialog/sample_dialog.dart';
import 'package:hunters_app/dialog/sample_dialog_second.dart';

// app
import 'package:go_router/go_router.dart';

///メールアドレス設定画面
class MailSetPage extends StatefulWidget {
  const MailSetPage({super.key});

  @override
  State<MailSetPage> createState() => _MailSetPageState();
}

class _MailSetPageState extends State<MailSetPage> {
  String mail = '';
  String secondMail = '';
  String confirmMail = '';
  bool showErrorMessage = false;

  ///メール送信確認ののダイアログ呼び出し
  Future<void> mailSetDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SampleDialogSecond(
          text: '入力されたメールアドレス宛に認証用メールを\n送信します。よろしいですか？',
          text2: 'キャンセル',
          text3: 'OK',
          route: '/login/mypage/setting/account/mailset',
          myFunction: _secondDialog,
        );
      },
    );
  }

  ///認証用メール送信後のダイアログ呼び出しの処理
  Future<void> _secondDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SampleDialog(
          text: 'メールアドレス当てに認証用メールを送信しました。',
          myFunction: _passInputPage,
        );
      },
    );
  }

  ///ログイン画面に戻る処理
  Future<void> _passInputPage() async {
    context.goNamed(RoutesName.login.name);
    debugPrint('完了');
  }

  ///入力したメールアドレスが不正かどうか確認する処理
  bool validateEmail(String email) {
    if (email.isEmpty) return false;
    final parts = email.split('@');
    if (parts.length != 2) return false;
    final localPart = parts[0];
    final domainPart = parts[1];
    if (localPart.length > 64 || domainPart.length > 253) return false;
    if (email.length > 254) return false;
    if (domainPart.isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SampleAppBar(
        title: 'メールアドレス連携',
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Column(
              children: [
                Text(
                  'メールアドレス連携を行ってください。',
                  style: blackBoldFont,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 7, 24, 0),
                  child: Text(
                    '機種変更や端末の紛失の際、サーバへアップされている過去の記録を新しい端末へ'
                    '復元する事が出来ます。'
                    '\n招待機能が利用できるようになります。'
                    ' \n送信ボタンを押すと、入力されたメールアドレス宛にパスワード設定用リンク付き'
                    'のメールを送信します。'
                    '\nパスワード再設定後、アプリのログイン画面にてログインを行ってください。'
                    '\nパスワード再設定用リンクの有効期限は60分です。',
                    style: TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 3),
                          child: Text(
                            'メールアドレス',
                            style: blackBoldFont,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 27,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              mail = value;
                              showErrorMessage = !validateEmail(mail);
                              if (showErrorMessage) {
                                showErrorMessage = false;
                              }
                            });
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 3),
                          child: Text(
                            'メールアドレス再入力（確認）',
                            style: blackBoldFont,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 27,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              secondMail = value;
                              showErrorMessage = !validateEmail(secondMail);
                              if (showErrorMessage) {
                                showErrorMessage = false;
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 31,
                        child: Center(
                          child: Visibility(
                            visible: showErrorMessage,
                            child: Text(
                              mail.isEmpty || secondMail.isEmpty
                                  ? '文字を入力してください。'
                                  : mail != secondMail
                                      ? '値が一致していません。'
                                      : '不正なメールアドレスです。',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 20,
                          width: 80,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: const Color(0xFFD50000),
                            ),
                            onPressed: () {
                              if (mail.isEmpty ||
                                  secondMail.isEmpty ||
                                  mail != secondMail ||
                                  !validateEmail(mail)) {
                                setState(() {
                                  showErrorMessage = true;
                                });
                              } else {
                                setState(() {
                                  showErrorMessage = false;
                                });
                                mailSetDialog();
                              }
                            },
                            child: Text(
                              '送信',
                              style: whiteFont,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
