// dart_HomeViewState
import 'package:flutter/material.dart';

// app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Center(
          child: Column(
        children: [
          TextButton(onPressed: fetchUserData, child: const Text('ToDo')),
        ],
      )),
    );
  }

  fetchUserData() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userId = firebaseAuth.currentUser?.uid;
    DocumentSnapshot snapshot = await firestore.doc('users/$userId').get();
    return snapshot.data();
  }
}
