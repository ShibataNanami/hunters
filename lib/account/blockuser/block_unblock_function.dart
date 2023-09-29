// dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

// app
import 'package:firebase_auth/firebase_auth.dart';

///ユーザーをブロックする処理
Future<bool> blockFunction() async {
  final auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    return false;
  } else {
    try {
      final functions =
          FirebaseFunctions.instanceFor(region: 'asia-northeast1');
      final data = await functions.httpsCallable('blockUnblockAppUser').call(
        <String, dynamic>{
          'blockUserName': 'shibata',
          'blockUserUid': '8Bik5WNMb1DyVkwNH6d7EjTB2WWO',
          'onBlock': true,
        },
      );
      debugPrint("ブロック完了\n$data");
      debugPrint("onBlock: true");
      return true;
    } catch (e) {
      debugPrint("error _s_callCloudFunction(): $e");
      return false;
    }
  }
}

///ブロック解除する処理
Future<bool> unBlockFunction() async {
  final auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    return false;
  } else {
    try {
      final functions =
          FirebaseFunctions.instanceFor(region: 'asia-northeast1');
      final data = await functions.httpsCallable('blockUnblockAppUser').call(
        <String, dynamic>{
          'blockUserName': 'shibata',
          'blockUserUid': '8Bik5WNMb1DyVkwNH6d7EjTB2WWO',
          'onBlock': false,
        },
      );
      debugPrint("ブロック解除完了\n$data");
      debugPrint("onBlock: false");
      return true;
    } catch (e) {
      debugPrint("error _s_callCloudFunction(): $e");
      return false;
    }
  }
}
