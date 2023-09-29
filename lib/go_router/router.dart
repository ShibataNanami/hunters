// dart
import 'dart:math';
import 'package:flutter/material.dart';

// third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hunters_app/account/blockuser/block_users_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// app
import 'package:hunters_app/account/account_page.dart';
import 'package:hunters_app/account/mail_set_page.dart';
import 'package:hunters_app/anonymous_users/first_page_view.dart';
import 'package:hunters_app/anonymous_users/launch_anonymous_user.dart';
import 'package:hunters_app/commons/environment_variables.dart';
import 'package:hunters_app/dialog/qrcode_error_dialog.dart';
import 'package:hunters_app/introducer/login_page.dart';
import 'package:hunters_app/pages/error/maintenance_page.dart';
import 'package:hunters_app/pages/error/update_page.dart';
import 'package:hunters_app/pages/error/noconnection_page.dart';
import 'package:hunters_app/pages/home/home_page.dart';
import 'package:hunters_app/pages/hunt/hunt_page.dart';
import 'package:hunters_app/pages/information/notifications_page.dart';
import 'package:hunters_app/pages/init_page.dart';
import 'package:hunters_app/pages/map/map_page.dart';
import 'package:hunters_app/pages/my_page/my_page_view.dart';
import 'package:hunters_app/pages/my_page/follow_follower_page/follow_follower_list_page.dart';
import 'package:hunters_app/pages/my_page/follow_follower_page/other_users_page.dart';
import 'package:hunters_app/profile/profile_page.dart';
import 'package:hunters_app/pages/qr_code/qr_code_scan_page.dart';
import 'package:hunters_app/pages/qr_code/qr_code_view_page.dart';
import 'package:hunters_app/pages/setting/app_information_page.dart';
import 'package:hunters_app/pages/setting/detail_setting_page.dart';
import 'package:hunters_app/pages/setting/setting_page.dart';

// debug
// import 'package:hunters_app/pages/debug/debug_anonymous_customtoken_page.dart';
// import 'package:hunters_app/pages/debug/debug_create_diary_page.dart';
// import 'package:hunters_app/pages/debug/debug_create_notices_page.dart';
// import 'package:hunters_app/pages/debug/debug_followered_notification_page.dart';
// import 'package:hunters_app/pages/debug/debug_router_test_page.dart';

enum RoutesName {
  // 初期Firebase関連設定画面
  init,

  // 初期画面
  first,
  login, // 初期画面> ログイン画面
  scanQr, // 初期画面> QRコード読み込み画面
  launchAnonymous, // 初期画面> QRコード読み込み画面> アノニマスユーザー登録画面
  scanQrError, // 初期画面> QRコード読み込み画面> QRコード認証失敗画面

  // ホーム画面
  home,

  // 地図画面
  map,

  // 狩る画面
  hunt,

  // お知らせ画面
  notice,

  // マイページ画面
  myPage,
  setting, // マイページ画面> 設定画面
  account, // マイページ画面> 設定画面> アカウント設定画面
  linkEmail, // マイページ画面> 設定画面> アカウント設定画面> メールアドレス設定画面
  profileEdit, // マイページ画面> 設定画面> アカウント設定画面> プロフィール編集画面
  blockUserList, // マイページ画面> 設定画面> アカウント設定画面> ブロック中のユーザーの一覧画面

  viewQr, // マイページ画面> 設定画面> 招待画面
  notification, // マイページ画面> 設定画面> 通知設定画面
  detail, // マイページ画面> 設定画面> 詳細設定画面
  help, // マイページ画面> 設定画面> ヘルプ画面
  application, // マイページ画面> 設定画面> アプリについて画面

  // 自身以外のページ画面
  otherUser,

  // フォロー/フォロワーリストページ
  followFollower,

  // メンテナンス画面
  maintenance,

  // アップデート要求画面
  updateRequired,

  // ネットに接続できません画面
  noconnection,

  // DEBUG
  debug,
}

final goRouter = GoRouter(
  initialLocation: '/init',
  routes: [
    // 初期Firebase関連設定画面
    GoRoute(
      name: RoutesName.init.name,
      path: '/${RoutesName.init.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: InitPage());
      },
    ),
    // 初期画面
    GoRoute(
      name: RoutesName.first.name,
      path: '/${RoutesName.first.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: FirstPageView());
      },
      routes: [
        // ログイン画面
        GoRoute(
          name: RoutesName.login.name,
          path: RoutesName.login.name,
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginPage());
          },
        ),
        // QRコード読み込み画面
        GoRoute(
          name: RoutesName.scanQr.name,
          path: RoutesName.scanQr.name,
          pageBuilder: (context, state) {
            return const MaterialPage(child: QRCodeScanPage());
          },
          routes: [
            // アノニマスユーザー登録画面
            GoRoute(
              name: RoutesName.launchAnonymous.name,
              path: RoutesName.launchAnonymous.name,
              pageBuilder: (context, state) {
                return const MaterialPage(
                    child: LaunchAnonymousUser(
                  introducerUid: '',
                  password: '',
                ));
              },
            ),
            // QRコード認証失敗画面
            GoRoute(
              name: RoutesName.scanQrError.name,
              path: RoutesName.scanQrError.name,
              pageBuilder: (context, state) {
                return const MaterialPage(child: QrcodeError());
              },
            ),
          ],
        ),
      ],
    ),

    // ホーム画面
    GoRoute(
      name: RoutesName.home.name,
      path: '/${RoutesName.home.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: HomePage());
      },
    ),

    // 地図画面
    GoRoute(
      name: RoutesName.map.name,
      path: '/${RoutesName.map.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: MapPage());
      },
    ),

    // 狩る画面
    GoRoute(
      name: RoutesName.hunt.name,
      path: '/${RoutesName.hunt.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: HuntPage());
      },
    ),

    // お知らせ画面
    GoRoute(
      name: RoutesName.notice.name,
      path: '/${RoutesName.notice.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: NotificationPage());
      },
    ),

    // マイページ画面
    GoRoute(
      name: RoutesName.myPage.name,
      path: '/${RoutesName.myPage.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: MyPageView());
      },
      routes: [
        // 設定画面
        GoRoute(
          name: RoutesName.setting.name,
          path: RoutesName.setting.name,
          pageBuilder: (context, state) {
            return const MaterialPage(child: SettingPage());
          },
          routes: [
            // アカウント設定画面
            GoRoute(
              name: RoutesName.account.name,
              path: RoutesName.account.name,
              pageBuilder: (context, state) {
                return const MaterialPage(child: AccountSetPage());
              },
              routes: [
                // メールアドレス設定画面
                GoRoute(
                  name: RoutesName.linkEmail.name,
                  path: RoutesName.linkEmail.name,
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: MailSetPage());
                  },
                ),
                // プロフィール編集画面
                GoRoute(
                  name: RoutesName.profileEdit.name,
                  path: RoutesName.profileEdit.name,
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: ProfilePage());
                  },
                ),
                // ブロック中のユーザーの一覧画面
                GoRoute(
                  name: RoutesName.blockUserList.name,
                  path: RoutesName.blockUserList.name,
                  pageBuilder: (context, state) {
                    return const MaterialPage(
                        child: BlockUsersList(
                      name: '',
                    ));
                  },
                ),
              ],
            ),
            // 招待画面
            GoRoute(
              name: RoutesName.viewQr.name,
              path: RoutesName.viewQr.name,
              pageBuilder: (context, state) {
                final auth = FirebaseAuth.instance;
                final introducerId = auth.currentUser?.uid.toString();
                debugPrint(introducerId);
                FirebaseFirestore.instance
                    .collection('usersPrivate')
                    .doc(introducerId)
                    .update(
                  {
                    'oneTime': {
                      'password': generateRandomString(),
                      'timestamp': FieldValue.serverTimestamp(),
                    },
                  },
                );
                return MaterialPage(
                    child: FutureBuilder(
                  future: _wait(1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _loadingWidget(100);
                    } else {
                      return const Center(
                        child: QrCodeViewPage(),
                      );
                    }
                  },
                ));
              },
            ),
            // // 通知設定画面
            // GoRoute(
            //   name: RoutesName.notification.name,
            //   path: RoutesName.notification.name,
            //   pageBuilder: (context, state) {
            //     return const MaterialPage(child: ());
            //   },
            // ),
            // 詳細設定画面
            GoRoute(
              name: RoutesName.detail.name,
              path: RoutesName.detail.name,
              pageBuilder: (context, state) {
                return const MaterialPage(child: DetailSettingPage());
              },
            ),
            // // ヘルプ画面
            // GoRoute(
            //   name: RoutesName.help.name,
            //   path: RoutesName.help.name,
            //   pageBuilder: (context, state) {
            //     return const MaterialPage(child: ());
            //   },
            // ),
            // アプリについて
            GoRoute(
              name: RoutesName.application.name,
              path: RoutesName.application.name,
              pageBuilder: (context, state) {
                return const MaterialPage(child: AppInformationPage());
              },
            ),
          ],
        ),
      ],
    ),

    // 自身以外のユーザ画面
    GoRoute(
      name: RoutesName.otherUser.name,
      path: '/${RoutesName.otherUser.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: OtherUsersPage());
      },
    ),

    // フォロー/フォロワーリストページ
    GoRoute(
      name: RoutesName.followFollower.name,
      path: '/${RoutesName.followFollower.name}',
      pageBuilder: (context, state) {
        return MaterialPage(
            child: FollowFollowerListPage(isFollow: (state.extra as bool?)));
      },
    ),

    // メンテナンス画面
    GoRoute(
      name: RoutesName.maintenance.name,
      path: '/${RoutesName.maintenance.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: MaintenancePage());
      },
    ),

    // アップデート画面
    GoRoute(
      name: RoutesName.updateRequired.name,
      path: '/${RoutesName.updateRequired.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: UpdatePage());
      },
    ),
    //ネットに接続できません画面
    GoRoute(
      name: RoutesName.noconnection.name,
      path: '/${RoutesName.noconnection.name}',
      pageBuilder: (context, state) {
        return const MaterialPage(child: NoconnectionPage());
      },
    ),

    // DEBUG 用 todo: リリース時には消すかコメントアウトすること
    GoRoute(
      name: 'debug',
      path: '/${RoutesName.debug.name}',
      pageBuilder: (context, state) {
        if (EnvironmentVariables.isDebug) {
          // return const MaterialPage(child: DebugAnonymousCustomTokenPage());
          // return const MaterialPage(child: DebugCreateDiaryPage());
          // return const MaterialPage(child: DebugCreateNoticesPage());
          // return const MaterialPage(child: DebugFolloweredNotificationPage());
          // return const MaterialPage(child: DebugRouterTestPage());
        }
        // debug でない場合は表示されないはずなのでとりあえずメンテナンス画面表示
        return const MaterialPage(child: MaintenancePage());
      },
    ),
  ],
);

String generateRandomString([int length = 32]) {
  const String charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  final String randomStr =
      List.generate(length, (_) => charset[random.nextInt(charset.length)])
          .join();
  return randomStr;
}

Widget _loadingWidget(double size) {
  return Center(
    child: LoadingAnimationWidget.beat(color: Colors.grey, size: size),
  );
}

Future _wait(seconds) async {
  return await Future.delayed(Duration(seconds: seconds));
}
