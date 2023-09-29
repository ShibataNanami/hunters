// dart
import 'package:flutter/material.dart';

// third party
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// app
import 'package:hunters_app/theme/bottom_appbar.dart';

/// debug用> フォローされました通知 動作確認 ページ
/// ※不要になったら削除してください
class DebugFolloweredNotificationPage extends StatefulWidget {
  const DebugFolloweredNotificationPage({super.key});

  @override
  DebugFolloweredNotificationPageState createState() =>
      DebugFolloweredNotificationPageState();
}

class DebugFolloweredNotificationPageState
    extends State<DebugFolloweredNotificationPage> {
  late String displayText = '初期表示';

  // ログアウト
  Future<void> _signOut() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      await auth.signOut();
      displayText = "ログアウトしました!!";
    } else {
      displayText = "ログインしてません";
    }

    if (mounted) {
      setState(() {
        displayText;
      });
    }
  }

  //匿名登録
  Future<void> _signInAnonymous() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        displayText = "SUCCESS!! 匿名ユーザ サインイン";
        debugPrint("newed anonymous user UID: ${userCredential.user!.uid}");
      } catch (e) {
        displayText = "FAILED!! 匿名ユーザ サインイン";
        debugPrint("error _signInAnonymous(): $e");
      }
    } else {
      displayText = "匿名ユーザ 既に存在";
      debugPrint("current Anonymous user UID: ${auth.currentUser!.uid}");
    }

    if (mounted) {
      setState(() {
        displayText;
      });
    }
  }

  // cloud function <createAnonymousUser> を呼び出し
  Future<void> _callCloudFunction() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      displayText = "カレントユーザが存在しません";
    } else {
      try {
        final functions =
            FirebaseFunctions.instanceFor(region: 'asia-northeast1');
        final result = await functions
            .httpsCallable('createAnonymousUser')
            .call(<String, dynamic>{
          'introducerUid': '7jxXcfhD3HAr2eJmi8s0CY5pthor',
          'name': 'hoge',
          'password': 'password',
        });

        if (result.data['success'] == true) {
          displayText = "SUCCESS!! call createAnonymousUser";
        } else {
          debugPrint(result.toString());
          displayText =
              "ERROR!! call createAnonymousUser: ${result.data['error']['code']}";
        }
      } catch (e) {
        displayText = "FAILED!! call createAnonymousUser";
        debugPrint("error _s_callCloudFunction(): $e");
      }
    }

    if (mounted) {
      setState(() {
        displayText;
      });
    }
  }

  // 通知許可 を設定
  Future<void> _permissionNotification() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      displayText = "カレントユーザが存在しません";
    } else {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint(fcmToken);
      displayText = "通知待ち中...";

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('${message.data}');
        if (message.notification != null) {
          displayText =
              '${message.notification!.title}\n${message.notification!.body ?? ''} ';
        }
        if (mounted) {
          setState(() {
            displayText;
          });
        }
      });
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
      bottomNavigationBar: const HomeButtomAppbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _signOut();
              },
              child: const Text('ログアウト'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _signInAnonymous();
              },
              child: const Text('匿名ユーザ作成'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _callCloudFunction();
              },
              child: const Text('[CALL] createAnonymousUser'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _permissionNotification();
              },
              child: const Text('通知 許可'),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(displayText),
          ],
        ),
      ),
    );
  }
}
