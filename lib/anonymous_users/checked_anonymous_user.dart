// dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// third party

// app
import 'package:firebase_auth/firebase_auth.dart';

class CheckedAnonymousUser extends StatefulWidget {
  const CheckedAnonymousUser({super.key});

  @override
  RegistrationAnonymousUserState createState() =>
      RegistrationAnonymousUserState();
}

class RegistrationAnonymousUserState extends State<CheckedAnonymousUser> {
  final String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.black),
      ),
      body: Center(
        child: Column(children: [
          const Text('結果'),
          Text(_result),
        ]),
      ),
    );
  }

  Future<void> onCreateAnonymousUser() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      debugPrint("hid: ${userCredential.user!.uid}");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          debugPrint("Unknown error");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    onCreateAnonymousUser();
  }
}
