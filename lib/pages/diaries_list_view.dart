import 'package:flutter/material.dart';


// ignore: must_be_immutable
class DiariesListView extends StatelessWidget {
  String diaries = '';

  DiariesListView({super.key});



  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              Text(diaries),
            ],
          ),
          
        ],


      ),
    );
  }
}