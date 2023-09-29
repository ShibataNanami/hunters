// dart
import 'package:flutter/material.dart';

// third party
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/theme/bottom_appbar.dart';

// debug用> router 動作確認用ページ
// ※不要になったら削除してください
class DebugRouterTestPage extends StatefulWidget {
  const DebugRouterTestPage({super.key});

  @override
  DebugRouterTestPageState createState() => DebugRouterTestPageState();
}

class DebugRouterTestPageState extends State<DebugRouterTestPage> {
  late String displayText = '初期表示';
  // goNamed
  Future<void> _goNamed() async {
    displayText = "test goNamed";
    context.goNamed('maintenance');
  }

  // pushNamed
  Future<void> _pushNamed() async {
    displayText = "test pushNamed";
    context.pushNamed('maintenance');
  }

  // pushReplacementNamed
  Future<void> _pushReplacementNamed() async {
    displayText = "test pushReplacementNamed";
    context.pushReplacementNamed('maintenance');
  }

  // replacementNamed
  Future<void> _replacementNamed() async {
    displayText = "test replacementNamed";
    context.replaceNamed('maintenance');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: const HomeButtomAppbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _goNamed();
              },
              child: const Text('goNamed'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _pushNamed();
              },
              child: const Text('pushNamed'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _pushReplacementNamed();
              },
              child: const Text('pushReplacementNamed'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                _replacementNamed();
              },
              child: const Text('replacementNamed'),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(displayText),
          ],
        ),
      ),
    );
  }
}
