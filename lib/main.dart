// dart
import 'package:flutter/material.dart';

// third party
import 'package:flutter_riverpod/flutter_riverpod.dart';

// app
import 'go_router/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ///goRouter設定
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: goRouter.routeInformationParser,
      routerDelegate: goRouter.routerDelegate,
      routeInformationProvider: goRouter.routeInformationProvider,
      theme: ThemeData(fontFamily: 'NotoSansJP'),
    );
  }
}
