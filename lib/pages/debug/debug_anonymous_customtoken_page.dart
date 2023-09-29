// dart
import 'package:flutter/material.dart';

// third party
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

// app
import 'package:hunters_app/theme/bottom_appbar.dart';

/// debug用> カスタムトークンにて再サインインできるか 動作確認 ページ
/// ※不要になったら削除してください
class DebugAnonymousCustomTokenPage extends StatefulWidget {
  const DebugAnonymousCustomTokenPage({super.key});

  @override
  DebugAnonymousCustomTokenPageState createState() =>
      DebugAnonymousCustomTokenPageState();
}

class DebugAnonymousCustomTokenPageState
    extends State<DebugAnonymousCustomTokenPage> {
  late String displayText = '初期表示';
  late String customToken = '';

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
        debugPrint("error _callCloudFunction(): $e");
      }
    }

    if (mounted) {
      setState(() {
        displayText;
      });
    }
  }

  // cloud function <applyCustomTokenForGetMap> を呼び出し
  Future<void> _callApplyFunction() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      displayText = "カレントユーザが存在しません";
    } else {
      try {
        final functions =
            FirebaseFunctions.instanceFor(region: 'asia-northeast1');
        final result = await functions
            .httpsCallable('applyCustomTokenForGetMap')
            .call(<String, dynamic>{
          'mapId': 'hoge_mapID',
        });

        if (result.data['success'] == true) {
          customToken = result.data['result']['token'];
          displayText = "SUCCESS!! call applyCustomTokenForGetMap";
          debugPrint(customToken);
        } else {
          debugPrint(result.toString());
          customToken = '';
          displayText =
              "ERROR!! call applyCustomTokenForGetMap: ${result.data['error']['code']}";
        }
      } catch (e) {
        customToken = '';
        displayText = "FAILED!! call applyCustomTokenForGetMap";
        debugPrint("error _callApplyFunction(): $e");
      }
    }

    if (mounted) {
      setState(() {
        displayText;
      });
    }
  }

  // cloud function <applyCustomTokenForGetMap> を呼び出し
  Future<void> _resignin() async {
    final auth = FirebaseAuth.instance;

    if (customToken.isEmpty) {
      displayText = "カスタムトークン未取得です";
    } else {
      try {
        await auth.signInWithCustomToken(customToken);
        displayText = "SUCCESS!! 再サインイン";
      } catch (e) {
        customToken = '';
        displayText = "FAILED!! 再サインイン";
        debugPrint("error _resignin(): $e");
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
                _callApplyFunction();
              },
              child: const Text('[CALL] appluCustomTokenForGetMap'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _resignin();
              },
              child: const Text('再サインイン'),
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
