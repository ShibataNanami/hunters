
// dart
import 'package:flutter/material.dart';


class IntroductionView extends StatelessWidget {
  const IntroductionView(this.introduction, {Key? key}) : super(key: key);

  final String introduction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          centerTitle: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('自己紹介'),
            ],
          ),
          toolbarHeight: 60,
          backgroundColor: const Color.fromRGBO(22, 106, 30, 1.0),
          automaticallyImplyLeading: true,
          leading: const BackButton(),
       
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8.0, 0),
                  child: Text(
                    introduction,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}