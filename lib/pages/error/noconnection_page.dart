import 'package:flutter/material.dart';
import 'package:hunters_app/theme/bottom_appbar.dart';

class NoconnectionPage extends StatelessWidget {
  const NoconnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 290,
              child: Container(
                color: Colors.green,
              ),
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 160.0),
                child: Column(
                  children: [
                    Text(
                      'ネットに接続できません\ncan\'t connect to internet',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const HomeButtomAppbar(),
    );
  }
}
