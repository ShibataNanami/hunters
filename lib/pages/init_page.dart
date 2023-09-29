// dart

// third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hunters_app/go_router/router.dart';

// app
import '../firebase_options.dart';
import 'package:hunters_app/commons/environment_variables.dart';
import 'package:hunters_app/remote_config.dart';

enum _Phase {
  initialize,
  initializing,
  noCurrentUser,
  initialized,
  inTransition,
}

/// 初期化専用ページ<br>
/// 基本的にアプリ実行の最初のみの動作を想定
class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  _Phase _phase = _Phase.initialize;
  String message = '';

  bool isRunning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isRunning) {
      return;
    }
    isRunning = true;
    didChangeDependenciesAsync();
  }

  void didChangeDependenciesAsync() async {
    _phase = _Phase.initializing;
    setMessage('Initialize Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (EnvironmentVariables.isEmulator) {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseFunctions.instanceFor(region: 'asia-northeast1')
          .useFunctionsEmulator('localhost', 5001);
      setMessage('FirebaseAuth use auth emulator.');
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      setMessage('FirebaseAppCheck activate.');
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
      );
      FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    }

    final auth = FirebaseAuth.instance;
    if (EnvironmentVariables.doSignout) {
      // debug 用に起動前にsignout したい場合ここでsignout
      await auth.signOut();
      setState(() => _phase = _Phase.noCurrentUser);
      return;
    }

    if (auth.currentUser == null) {
      setMessage('currentUser == null');
      setState(() => _phase = _Phase.noCurrentUser);
      return;
    } else {
      await auth.currentUser!.getIdToken(true);
    }

    setMessage('Initialize FirebaseRemoteConfig...');
    await RemoteConfig.initialize();

    setMessage('All initialize complete.');
    setState(() => _phase = _Phase.initialized);
  }

  void setMessage(String message) {
    debugPrint(message);
    setState(() => this.message = message);
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == _Phase.initialized) {
      _phase = _Phase.inTransition;
      // 初期化終了後の画面遷移先
      Future(() =>
          GoRouter.of(context).pushReplacementNamed(RoutesName.home.name));
    } else if (_phase == _Phase.noCurrentUser) {
      // currentUser がいない(未ログイン時)場合の画面遷移先
      Future(() =>
          GoRouter.of(context).pushReplacementNamed(RoutesName.first.name));
    }
    return Scaffold(body: Center(child: Text(message)));
  }
}
