// dart
import 'package:flutter/material.dart';

// third party
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/go_router/router.dart';
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/theme/sample_appbar.dart';

///設定画面
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SampleAppBar(
        title: '設定',
      ),
      body: SizedBox(
        child: Center(
          child: ListView(
            // itemExtent: 40,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _customListTile(
                  context,
                  Icons.account_circle,
                  'アカウント',
                  RoutesName.account.name,
                ),
              ),
              _customListTile(
                context,
                Icons.qr_code_2,
                '招待',
                RoutesName.viewQr.name,
              ),
              _customListTile(
                context,
                Icons.notifications,
                '通知設定',
                '', //RoutesName.notification.name,
              ),
              _customListTile(
                context,
                Icons.settings_rounded,
                '詳細設定',
                RoutesName.detail.name,
              ),
              _customListTile(
                context,
                Icons.help_outline,
                'ヘルプ',
                '', //RoutesName.help.name,
              ),
              _customListTile(
                context,
                Icons.error_outline,
                'アプリについて',
                RoutesName.application.name,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///リストの設定
  SizedBox _customListTile(
    BuildContext context,
    IconData icon,
    String text,
    String route,
  ) {
    return SizedBox(
      height: 33,
      child: InkWell(
        onTap: () {
          context.pushNamed(route);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconTheme(
                data: const IconThemeData(
                  size: 20,
                ),
                child: Icon(
                  icon,
                  color: Colors.black38,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
              child: Text(
                text,
                style: blackBoldFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
