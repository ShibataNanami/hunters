// dart
import 'package:flutter/material.dart';

// app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///firestoreのblockUserの名前を取得する処理
Future<List<String>> getBlockUserNameData() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .collection('blockUsers')
          .doc(currentUser.uid)
          .get();
      if (snapshot.exists) {
        List<String> blockUsers = [];
        List<dynamic> data = snapshot.get('blockUsers');
        for (var element in data) {
          blockUsers.add(element['name']);
        }
        return blockUsers;
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
  return [];
}

///blockUsersのuidのデータを取得する処理
Future<List<String>> getBlockUserUidData() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usersPrivate')
          .doc(currentUser.uid)
          .collection('blockUsers')
          .doc(currentUser.uid)
          .get();
      if (snapshot.exists) {
        List<String> blockUsers = [];
        List<dynamic> data = snapshot.get('blockUsers');
        for (var element in data) {
          blockUsers.add(element['uid']);
        }
        return blockUsers;
      } else {
        debugPrint('ドキュメントが存在しません');
      }
    } catch (e) {
      debugPrint('値の取得中にエラーが発生: $e');
    }
  }
  return [];
}
