// dart
import 'package:flutter/material.dart';
import 'package:hunters_app/theme/bottom_appbar.dart';

// third party
import 'package:hunters_app/theme/hunters_appbar.dart';

// app

///狩り画面（Sample）
class HuntPage extends StatelessWidget {
  const HuntPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HuntersAppBar(
        title: '狩り画面（Sample）',
      ),
      bottomNavigationBar: HomeButtomAppbar(),
    );
  }
}
