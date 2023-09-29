// dart
import 'package:flutter/material.dart';

// third party
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// app
import 'package:hunters_app/commons/environment_variables.dart';
import 'package:hunters_app/go_router/router.dart';

class HomeButtomAppbar extends StatelessWidget {
  const HomeButtomAppbar({Key? key}) : super(key: key);

  ///ログイン後に表示されるButtomAppbar部分の設定
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 70,
        width: MediaQuery.of(context).size.width * 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //ホーム
            _buttomIconButton(
              context,
              Icons.home,
              'ホーム',
              RoutesName.home.name,
            ),
            //地図
            _buttomIconButton(
              context,
              Icons.map_outlined,
              '地図',
              RoutesName.map.name,
            ),
            //狩る
            _buttomIconButton(
              context,
              Icons.pets,
              '狩る',
              RoutesName.hunt.name,
            ),
            //お知らせ
            _buttomIconButton(
              context,
              Icons.notifications,
              'お知らせ',
              RoutesName.notice.name,
            ),
            //マイページ
            _buttomIconButton(
              context,
              Icons.account_circle,
              'マイページ',
              RoutesName.myPage.name,
            ),
            //debug
            if (EnvironmentVariables.isDebug)
              _buttomIconButton(
                context,
                Icons.android_outlined,
                'for debug',
                RoutesName.debug.name,
              ),
          ],
        ),
      ),
    );
  }

  Expanded _buttomIconButton(
    BuildContext context,
    IconData icon,
    String text,
    String route,
  ) {
    final pathName = GoRouterState.of(context).name ?? '';
    // debugPrint('sssss : $route $path');

    Color iconColor = Colors.grey;
    if (route == pathName) {
      iconColor = Colors.black;
    }
    return Expanded(
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              icon,
              size: 40,
              color: iconColor,
            ),
            padding: const EdgeInsets.only(top: 8.0),
            onPressed: () async {
//              context.pushReplacementNamed(route);
              var connectivityResult = await Connectivity().checkConnectivity();
              debugPrint("------------------- $connectivityResult");
              if (connectivityResult == ConnectivityResult.none) {
                // ignore: use_build_context_synchronously
                context.pushReplacementNamed(RoutesName.noconnection.name);
              } else {
                // ignore: use_build_context_synchronously
                context.pushReplacementNamed(route);
              }
            },
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
