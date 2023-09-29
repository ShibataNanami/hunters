// app
import 'package:flutter/material.dart';

// third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///firestore上のデータ更新を行う処理一覧のファイル

//プロフィールの変更内容を更新する処理
Future<void> updateUserData(
  User? currentUser,
  String introduction,
  String name,
) async {
  if (currentUser != null) {
    debugPrint('User ID: ${currentUser.uid}');
    debugPrint('User Email: ${currentUser.email}');
    try {
      final privateRef = FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid);
      final publicRef = FirebaseFirestore.instance
          .collection('usersPublic')
          .doc(currentUser.uid);
      final batch = FirebaseFirestore.instance.batch();
      batch.update(
        privateRef,
        {
          'introduction': introduction,
          'name': name,
          'oneTime': null,
        },
      );
      batch.update(
        publicRef,
        {
          'introduction': introduction,
          'name': name,
        },
      );
      await batch.commit();
    } catch (e) {
      debugPrint('更新中にエラー発生: $e');
    }
  } else {
    debugPrint('現在ログインしているユーザーなし');
  }
}

// //鳥獣区分選択の変更内容を更新する処理
Future<void> updateAnimalData(
  User? currentUser,
  bool animalFlgPublic,
  Map<String, bool> animals,
) async {
  if (currentUser != null) {
    if (animals.isEmpty) {
      final privateSnapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();
      final animalCategory = privateSnapshot.get('animalCategory');
      animals = Map<String, bool>.from(animalCategory['animals']);
    }
    try {
      final privateRef = FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid);
      final publicRef = FirebaseFirestore.instance
          .collection('usersPublic')
          .doc(currentUser.uid);
      final batch = FirebaseFirestore.instance.batch();
      if (animalFlgPublic == true) {
        batch.update(privateRef, {
          'animalCategory.animals': animals,
          'oneTime': null,
        });
        batch.update(publicRef, {
          'animals': animals,
        });
      } else {
        batch.update(privateRef, {
          'animalCategory.animals': animals,
          'oneTime': null,
        });
        batch.update(publicRef, {
          'animals': null,
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint('更新中にエラー発生: $e');
    }
  } else {
    debugPrint('現在ログインしているユーザーなし');
  }
}

//エリア選択の変更内容を更新する処理
Future<void> updateAreaData(
  User? currentUser,
  bool areaFlgPublic,
  Map<String, bool> areas,
) async {
  if (currentUser != null) {
    if (areas.isEmpty) {
      final privateSnapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();
      final areaCategory = privateSnapshot.get('areaCategory');
      final areaFromFirestore = Map<String, bool>.from(areaCategory['areas']);
      areas = areaFromFirestore;
    }
    try {
      final privateRef = FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid);
      final publicRef = FirebaseFirestore.instance
          .collection('usersPublic')
          .doc(currentUser.uid);
      final batch = FirebaseFirestore.instance.batch();
      if (areaFlgPublic == true) {
        batch.update(privateRef, {
          'areaCategory.areas': areas,
          'oneTime': null,
        });
        batch.update(publicRef, {
          'areas': areas,
        });
      } else {
        batch.update(privateRef, {
          'areaCategory.areas': areas,
          'oneTime': null,
        });
        batch.update(publicRef, {
          'areas': null,
        });
      }

      await batch.commit();
    } catch (e) {
      debugPrint('更新中にエラー発生: $e');
    }
  } else {
    debugPrint('現在ログインしているユーザーなし');
  }
}

//鳥獣区分の公開・非公開の設定変更を更新する処理
Future<void> updateanimalFlgPublic(
  User? currentUser,
  bool animalFlgPublic,
) async {
  if (currentUser != null) {
    try {
      final privateRef = FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid);
      final publicRef = FirebaseFirestore.instance
          .collection('usersPublic')
          .doc(currentUser.uid);
      final batch = FirebaseFirestore.instance.batch();
      if (animalFlgPublic == true) {
        DocumentSnapshot snapshot = await privateRef.get();
        Map<String, dynamic> animalCategory = snapshot.get('animalCategory');
        Map<String, bool> animals =
            Map<String, bool>.from(animalCategory['animals']);
        batch.update(
          privateRef,
          {
            'animalCategory.flgPublic': true,
            'oneTime': null,
          },
        );
        batch.update(
          publicRef,
          {
            'animals': animals,
          },
        );
      } else {
        batch.update(
          privateRef,
          {
            'animalCategory.flgPublic': false,
            'oneTime': null,
          },
        );
        batch.update(
          publicRef,
          {
            'animals': null,
          },
        );
      }
      await batch.commit();
    } catch (e) {
      debugPrint('更新中にエラー発生: $e');
    }
  } else {
    debugPrint('現在ログインしているユーザーなし');
  }
}

//活動エリアの公開・非公開の設定変更を更新する処理
Future<void> updateareaFlgPublic(
  User? currentUser,
  bool areaFlgPublic,
) async {
  if (currentUser != null) {
    try {
      final privateRef = FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid);
      final publicRef = FirebaseFirestore.instance
          .collection('usersPublic')
          .doc(currentUser.uid);
      final batch = FirebaseFirestore.instance.batch();
      if (areaFlgPublic == true) {
        DocumentSnapshot snapshot = await privateRef.get();
        Map<String, dynamic> areaCategory = snapshot.get('areaCategory');
        Map<String, bool> areas = Map<String, bool>.from(areaCategory['areas']);
        batch.update(
          privateRef,
          {
            'areaCategory.flgPublic': true,
            'oneTime': null,
          },
        );
        batch.update(
          publicRef,
          {
            'areas': areas,
          },
        );
      } else {
        batch.update(
          privateRef,
          {
            'areaCategory.flgPublic': false,
            'oneTime': null,
          },
        );
        batch.update(
          publicRef,
          {
            'areas': null,
          },
        );
      }
      await batch.commit();
    } catch (e) {
      debugPrint('更新中にエラー発生: $e');
    }
  } else {
    debugPrint('現在ログインしているユーザーなし');
  }
}
