// dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// third party
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

// app
import 'package:hunters_app/theme/bottom_appbar.dart';

// debug用> 日記作成 動作確認 ページ
// ※不要になったら削除してください
class DebugCreateDiaryPage extends StatefulWidget {
  const DebugCreateDiaryPage({super.key});

  @override
  DebugCreateDiaryPageState createState() => DebugCreateDiaryPageState();
}

class DebugCreateDiaryPageState extends State<DebugCreateDiaryPage> {
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
          // idToken強制再取得
          await auth.currentUser!.getIdToken(true);
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

  // usersPrivate/{userUid}/editDiaries/{docId} ドキュメント create
  // todo: usersPublic/{userUid}/diaries/{docId} ドキュメント create
  // todo: usersPublic/{userUid}/diaries/{docId}/filterDiary/{docId} ドキュメント create
  Future<void> _createDiary() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      displayText = "カレントユーザが存在しません";
    } else {
      try {
        final db = FirebaseFirestore.instance;
        final editDiariesColRef = db
            .collection('usersPrivate')
            .doc(auth.currentUser!.uid)
            .collection('editDiaries');
        final createDocId = editDiariesColRef.doc().id;

        final diariesColRef = db
            .collection('usersPublic')
            .doc(auth.currentUser!.uid)
            .collection('diaries');

        final filterDiaryColRef =
            diariesColRef.doc(createDocId).collection('filterDiary');

        final huntDate = DateTime(2023, 8, 8, 12, 34, 56);
        final createDataEditDiary = {
          'animalCategoryCount': {
            'animalsCount': {
              'bear': 0,
              'boar': 1,
              'deer': 2,
              'duck': 3,
              'otherBirds': 4,
              'others': 5,
            },
            'flgPublic': true
          },
          'areaCategory': {
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
            'flgPublic': false
          },
          'body': 'diary body',
          'createDate': FieldValue.serverTimestamp(),
          'huntDate': {
            'end': Timestamp.fromDate(huntDate.add(const Duration(hours: 1))),
            'start': Timestamp.fromDate(huntDate),
          },
          'imageHeaderPath': 'diary imageHeaderPath',
          'images': null,
          'map': {
            'flgPublic': false,
            'mapPairId': {
              'latitude': 1,
              'longitude': 2,
            },
          },
          'registeredPoint': {
            'datas': [],
            'flgPublic': false,
          },
          'remarks': 'diary remarks',
          'root': {
            'datas': [],
            'flgPublic': false,
          },
          'title': 'diary title',
          'updateDate': FieldValue.serverTimestamp(),
        };
        final createDataDiary = {
          'animalFlg': true,
          'areaFlg': false,
          'body': 'diary body',
          'createDate': FieldValue.serverTimestamp(),
          'huntDate': {
            'end': Timestamp.fromDate(huntDate.add(const Duration(hours: 1))),
            'start': Timestamp.fromDate(huntDate),
          },
          'imageHeaderPath': 'diary imageHeaderPath',
          'imagePaths': null,
          'mapPairId': null,
          'registeredPointDatas': null,
          'remarks': 'diary remarks',
          'restrictedByAdmin': false,
          'rootDatas': null,
          'title': 'diary title',
          'updateDate': FieldValue.serverTimestamp(),
        };
        final createDataFilterDiary = {
          'animals': {
            'bear': false,
            'boar': true,
            'deer': true,
            'duck': true,
            'otherBirds': true,
            'others': true,
          },
          'animalsCount': {
            'bear': 0,
            'boar': 1,
            'deer': 2,
            'duck': 3,
            'otherBirds': 4,
            'others': 5,
          },
          'areas': null,
          'createDate': FieldValue.serverTimestamp(),
          'createUserUid': auth.currentUser!.uid,
          'restrictedByAdmin': false,
        };

        final batch = db.batch();
        batch.set(editDiariesColRef.doc(createDocId), createDataEditDiary);
        batch.set(diariesColRef.doc(createDocId), createDataDiary);
        batch.set(filterDiaryColRef.doc(createDocId), createDataFilterDiary);
        await batch.commit();

        displayText = "SUCCESS!! call _createDiary";
      } catch (e) {
        displayText = "FAILED!! call _createDiary";
        debugPrint("error _s_createDiary(): $e");
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
                _createDiary();
              },
              child: const Text('日記を作成'),
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
