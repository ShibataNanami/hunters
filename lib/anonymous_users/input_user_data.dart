///後ほど削除

// // dart
// import 'package:flutter/material.dart';

// // app
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// ///firestoreにtimeStamp追加
// class InputUserData extends StatelessWidget {
//   InputUserData({super.key});

//   final name = FirebaseAuth.instance.currentUser?.uid;

//   fetchUserData() async {
//     FirebaseFirestore.instance
//         .collection('test2')
//         .add({'name': 'gombe', 'timeStamp': DateTime});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: TextButton(
//           onPressed: fetchUserData,
//           child: const Text('書き込み'),
//         ),
//       ),
//     );
//   }
// }
