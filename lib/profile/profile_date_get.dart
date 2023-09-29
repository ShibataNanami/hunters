// dart
import 'package:flutter/material.dart';

// app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///firestore上のデータを取得する処理一覧のファイル

//firestoreのnameのデータを取得する処理
Future<void> getNameDate(
  TextEditingController nameController,
) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        String name = snapshot.get('name');
        nameController.text = name;
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
}

//firestoreのintroductionのデータを取得する処理
Future<void> getIntroductionDate(
  TextEditingController introductionController,
) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        String introduction = snapshot.get('introduction');
        introductionController.text = introduction;
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
}

//firestoreのanimalsのデータを取得する処理
Future<Map<String, bool>> getAnimalsDate() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> animalCategory = snapshot.get('animalCategory');
        return Map<String, bool>.from(animalCategory['animals']);
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
  return {};
}

///firestoreのareasのデータを取得する処理
Future<Map<String, bool>> getAreasDate() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> areaCategory = snapshot.get('areaCategory');
        return Map<String, bool>.from(areaCategory['areas']);
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
  return {};
}

///firestoreのanimalCategoryのflgPublicのデータを取得する処理
Future<bool> getAnimalFlgPublic() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> animalCategory = snapshot.get('animalCategory');
        bool animalFlgPublic = animalCategory['flgPublic'];
        return animalFlgPublic;
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
  return false;
}

///firestoreのareaCategoryのflgPublicのデータを取得する処理
Future<bool> getAreaFlgPublic() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> animalCategory = snapshot.get('animalCategory');
        bool areaFlgPublic = animalCategory['flgPublic'];
        return areaFlgPublic;
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
  return false;
}
