// dart
import 'package:flutter/material.dart';

// third party
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/commons/environment_variables.dart';
import 'package:hunters_app/dialog/pass_reset_dialog.dart';
import 'package:hunters_app/go_router/router.dart';
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/theme/hunters_appbar.dart';

void main() {
  runApp(const LoginPage());
}

///登録済ユーザー用のログイン画面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  // debug 用に、email/password 初期値をセット
  String _email = EnvironmentVariables.userEmail;
  String _password = EnvironmentVariables.userPass;

  void resetPassword() {
    debugPrint(MediaQuery.of(context).size.toString());
    showDialog<void>(
      context: context,
      builder: (_) {
        return PassReset(email: _email);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HuntersAppBar(
        title: 'HUNTERS',
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomAppBar(
          elevation: 1,
          shadowColor: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 17, 0, 23),
                  child: Text(
                    'メールアドレス、パスワードを入力して下さい。',
                    style: blackFont,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'メールアドレス',
                      style: blackBoldFont,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 3, 16, 13),
                  child: SizedBox(
                    height: 27,
                    child: TextFormField(
                      initialValue: _email, // debug 用に、email/password 初期値をセット
                      style: blackFont,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                      ),
                      onChanged: (String value) {
                        setState(
                          () {
                            _email = value;
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'パスワード',
                      style: blackBoldFont,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 3, 16, 13),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 27,
                        child: TextFormField(
                          initialValue:
                              _password, // debug 用に、email/password 初期値をセット
                          style: blackFont,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                          ),
                          obscureText: _isObscure,
                          onChanged: (String value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                      ),
                      Positioned(
                        right: -6,
                        top: -6,
                        bottom: 0,
                        child: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: SizedBox(
                          height: 36,
                          width: 140,
                          child: FloatingActionButton.extended(
                            backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
                            onPressed: () async {
                              try {
                                // メール/パスワードでログイン
                                final User? user = (await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _email, password: _password))
                                    .user;
                                if (user != null) {
                                  debugPrint(
                                      "ログインしました${user.email} , ${user.uid}");
                                  if (context.mounted) {
                                    // ログイン後のアプリ画面に遷移するよう設定にする
                                    context.pushReplacementNamed(
                                        RoutesName.home.name);
                                  }
                                }
                              } catch (e) {
                                debugPrint('$e');
                              }
                            },
                            label: const Text(
                              'ログイン',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 59),
                        child: SizedBox(
                          child: TextButton(
                            onPressed: resetPassword,
                            child: const Text(
                              'パスワードをお忘れの方はこちら',
                              textScaleFactor: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      )
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
