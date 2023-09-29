// dart
import 'package:flutter/material.dart';

// third party
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/dialog/qrcode_error_dialog.dart';
import 'package:hunters_app/go_router/router.dart';
import 'package:hunters_app/remote_config.dart';

///アノニマスユーザー登録画面
class LaunchAnonymousUser extends StatefulWidget {
  final String introducerUid;
  final String password;
  const LaunchAnonymousUser({
    super.key,
    required this.introducerUid,
    required this.password,
  });

  @override
  LaunchAnonymousUserState createState() => LaunchAnonymousUserState();
}

class LaunchAnonymousUserState extends State<LaunchAnonymousUser> {
  String name = '';
  bool showErrorMessage = false;
  bool isMaintenance = false;
  double appMinimumVersion = 0;
  String displayText = '初期表示';

  ///RemoteConfigの値を呼び出し
  void handleStartButtonPressed() {
    setState(() {
      isMaintenance = FirebaseRemoteConfig.instance.getBool('is_maintenance');
      appMinimumVersion =
          FirebaseRemoteConfig.instance.getDouble('app_minimum_ver');
      initRemoteConfig();
    });
  }

  ///匿名登録
  Future<void> signInAnonymous(
    String introducerUid,
    String password,
  ) async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      if (!auth.currentUser!.isAnonymous) {
        await auth.signOut();
      }
    }
    if (auth.currentUser == null) {
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        displayText = "SUCCESS!! 匿名ユーザ サインイン";
        debugPrint("newed anonymous user UID: ${userCredential.user!.uid}");
        //cloud function呼び出し
        callCloudFunction(
          introducerUid,
          password,
        );
      } catch (e) {
        displayText = "FAILED!! 匿名ユーザ サインイン";
        debugPrint("error signInAnonymous(): $e");
        qrcodeErrorDialog();
      }
    } else {
      displayText = "匿名ユーザ 既に存在";
      debugPrint("current Anonymous user UID: ${auth.currentUser!.uid}");
      qrcodeErrorDialog();
    }
    if (mounted) {
      setState(() {
        displayText;
      });
    }
  }

  ///ホーム画面へ遷移する処理呼び出し
  Future<void> signInComplete() async {
    context.pushReplacementNamed(RoutesName.home.name);
  }

  ///QRコードエラーダイアログを呼び出し
  Future<void> qrcodeErrorDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const QrcodeError();
      },
    );
  }

  /// cloud function <createAnonymousUser> を呼び出し
  Future<void> callCloudFunction(
    String introducerUid,
    String password,
  ) async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      debugPrint("カレントユーザが存在しません");
    } else {
      try {
        final functions =
            FirebaseFunctions.instanceFor(region: 'asia-northeast1');

        final result = await functions
            .httpsCallable('createAnonymousUser')
            .call(<String, dynamic>{
          'introducerUid': introducerUid,
          'name': name,
          'password': password,
        });
        debugPrint('$introducerUid\n$name\n$password');
        if (result.data['success'] == true) {
          debugPrint("SUCCESS!! call createAnonymousUser");
          // idToken強制再取得
          await auth.currentUser!.getIdToken(true);
          signInComplete();
        } else {
          debugPrint(result.toString());
          debugPrint(
              "ERROR!! call createAnonymousUser: ${result.data['error']}");
          qrcodeErrorDialog();
        }
      } catch (e) {
        debugPrint("error _s_callCloudFunction(): $e");
        qrcodeErrorDialog();
      }
    }
    if (mounted) {
      setState(() {
        displayText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Container(
                    color: const Color(0xFF006400),
                    width: double.infinity,
                    height: 220,
                  ),
                  const Positioned(
                    top: 70,
                    child: Text(
                      'HUNTERSへようこそ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              const Text(
                'ニックネームを決めてHUNTERSを開始してください。',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: const Text(
                    'ニックネーム',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                        showErrorMessage = value.isEmpty || value.length > 20;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Visibility(
                  visible: showErrorMessage,
                  child: const Text(
                    'ニックネームは20文字以内で入力してください。',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFD50000),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 48,
                      width: 160,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          backgroundColor: const Color(0xFFD50000),
                        ),
                        onPressed: () async {
                          handleStartButtonPressed();
                          if (isMaintenance) {
                            context.pushReplacementNamed(
                                RoutesName.maintenance.name);
                          } else if (appMinimumVersion > 2) {
                            context.pushReplacementNamed(
                                RoutesName.updateRequired.name);
                          } else {
                            signInAnonymous(
                              widget.introducerUid,
                              widget.password,
                            );
                          }
                        },
                        child: const Text(
                          '開始する',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
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
