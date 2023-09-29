// dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// third party
import 'package:firebase_auth/firebase_auth.dart';

// app
import 'package:hunters_app/theme/bottom_appbar.dart';

// debug用> notices(NEWS/お知らせ)ドキュメント作成 ページ
// ※不要になったら削除してください
class DebugCreateNoticesPage extends StatefulWidget {
  const DebugCreateNoticesPage({super.key});

  @override
  DebugCreateNoticesPageState createState() => DebugCreateNoticesPageState();
}

enum Notice {
  advertisement('広告'),
  news('ニュース');

  final String displayName;
  const Notice(this.displayName);
}

class DebugCreateNoticesPageState extends State<DebugCreateNoticesPage> {
  late String displayText = '初期表示';
  Notice? _notice = Notice.news;

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

  // admin ユーザでログイン
  Future<void> _signInAdmin() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      // サインアウト
      await _signOut();
    }

    // 管理者ユーザのアカウントをテストしてください
    const email = 'hoge@hoge.co.jp';
    const pass = 'xxxxxx';

    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      displayText = "SUCCESS!! 管理者ユーザ サインイン";
    } catch (e) {
      displayText = "FAILED!! 管理者ユーザ サインイン";
    }

    if (mounted) {
      setState(() {
        displayText;
      });
    }
  }

  // notices ドキュメント create
  Future<void> _createNotice() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      displayText = "カレントユーザが存在しません";
    } else {
      try {
        final db = FirebaseFirestore.instance;
        final noticesColRef = db.collection('notices');

        final noticeData = {
          'body': 'notice body',
          'category': _notice == null ? 'news' : _notice!.name,
          'createDate': FieldValue.serverTimestamp(),
          'imagePathRef': '',
          'notification': {
            'animals': {
              'bear': false,
              'boar': false,
              'deer': false,
              'duck': false,
              'otherBirds': false,
              'others': false,
            },
            'areas': {
              'chiba': false,
              'ehime': false,
              'fukuoka': false,
              'hiroshima': false,
              'kanagawa': false,
              'saitama': false,
              'shimane': false,
              'tokyo': false,
              'yamaguchi': false,
              'yamanashi': false,
            },
          },
          'title': 'notice title',
        };

        await noticesColRef.add(noticeData);
        displayText = "SUCCESS!! call _createNotice";
      } catch (e) {
        displayText = "FAILED!! call _createNotice";
        debugPrint("error _createNotice(): $e");
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
            ListTile(
              title: Text(Notice.advertisement.displayName),
              leading: Radio<Notice>(
                value: Notice.advertisement,
                groupValue: _notice,
                onChanged: (Notice? value) {
                  setState(() {
                    _notice = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(Notice.news.displayName),
              leading: Radio<Notice>(
                value: Notice.news,
                groupValue: _notice,
                onChanged: (Notice? value) {
                  setState(() {
                    _notice = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _signInAdmin();
              },
              child: const Text('管理者ユーザでログイン'),
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
                _createNotice();
              },
              child: const Text('Noticeを作成'),
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
