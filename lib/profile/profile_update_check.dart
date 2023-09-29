// dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/dialog/sample_dialog_second.dart';
import 'package:hunters_app/go_router/router.dart';

///未更新データの確認ダイアログを表示させる処理
Future<void> updateCheck(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SampleDialogSecond(
        text: 'プロフィールが編集中です。\n変更を破棄しますか？',
        text2: 'キャンセル',
        text3: '破棄',
        route: RoutesName.account.name,
        myFunction: () {},
      );
    },
  );
}

///データに相違あるか確認
Future<Map<String, bool>> dateCheck(
  BuildContext context,
  Map<String, bool> animals,
  Map<String, bool> areas,
  TextEditingController nameController,
  TextEditingController introductionController,
  bool? animalFlgPublic,
  bool? areaFlgPublic,
) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();
      if (snapshot.exists) {
        String nameFromFirestore = snapshot.get('name');
        String introductionFromFirestore = snapshot.get('introduction');
        Map<String, bool> animalFromFirestore =
            Map<String, bool>.from(snapshot.get('animalCategory.animals'));
        Map<String, bool> areaFromFirestore =
            Map<String, bool>.from(snapshot.get('areaCategory.areas'));
        bool animalFlgFromFirestore =
            snapshot.get('animalCategory.flgPublic') ?? false;
        bool areaFlgFromFirestore =
            snapshot.get('areaCategory.flgPublic') ?? false;
        if (animals.isEmpty) {
          animals = animalFromFirestore;
        }
        if (areas.isEmpty) {
          areas = areaFromFirestore;
        }
        if (nameFromFirestore == nameController.text &&
            introductionFromFirestore == introductionController.text &&
            animalFlgFromFirestore == animalFlgPublic &&
            areaFlgFromFirestore == areaFlgPublic &&
            (mapEquals(animalFromFirestore, animals)) &&
            mapEquals(areaFromFirestore, areas)) {
          if (context.mounted) {
            context.pushNamed(RoutesName.account.name);
            debugPrint('OK');
          }
        } else {
          if (context.mounted) {
            updateCheck(context);
          }
          debugPrint('エラー');
        }
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
  return {};
}
