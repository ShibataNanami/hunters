// dart
import 'dart:async';
import 'dart:math';

// third party
import 'package:flutter/material.dart';
import 'package:hunters_app/theme/bottom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// app
import '../../notifications/notification_item.dart';

/// SharedPreferences Key
const String notificationVersionKey = 'NotificationVersion';

/// SharedPreferences Key
const String notificationDataKey = 'NotificationData';

// todo: 通知ページ 機能とデザインはほぼ NotificationWidget 側で実装されているので前提が整備されたら調整して下さい。
class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);
  static Route<NotificationPage> route() {
    return MaterialPageRoute<NotificationPage>(
      builder: (_) => const NotificationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: const HomeButtomAppbar(),
        body: const NotificationWidget(),
        persistentFooterButtons: [
          TextButton(
            child: const Text('Clear'),
            onPressed: () => _clearDummyData(),
          )
        ],
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addDummyData(),
          child: const Icon(Icons.add),
        ));
  }

  // ダミー通知データを追加
  void _addDummyData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int version = prefs.getInt(notificationVersionKey) ?? -1;
    List<String> list = version != -1
        ? prefs.getStringList(notificationDataKey) ?? <String>[]
        : <String>[];

    final rand = Random();
    final userUid = rand.nextBool() ? '(ID)鹿肉専門店 鹿島' : '(ID)HANAKO';
    final documentId = (rand.nextDouble() * 2147483647).toInt();
    switch (rand.nextInt(5)) {
      case 1: // フォローされた
        list.add(
            NotificationItem(100, AdditionalData(userUid: userUid)).toJson());
        break;
      case 2: // フォローユーザが日記を新規投稿
        list.add(NotificationItem(200,
                AdditionalData(userUid: userUid, documentId: '{$documentId}'))
            .toJson());
        break;
      case 3: // 自身の投稿にコメントされた
        list.add(
            NotificationItem(300, AdditionalData(documentId: '{$documentId}'))
                .toJson());
        break;
      case 4: // 自身の投稿にコメントされた
        list.add(
            NotificationItem(310, AdditionalData(documentId: '{$documentId}'))
                .toJson());
        break;
      case 5: // 運営からの通知ありNEWS投稿
        list.add(
            NotificationItem(400, AdditionalData(documentId: '{$documentId}'))
                .toJson());
        break;
      default: // 運営からの通知あり広告投稿
        list.add(
            NotificationItem(500, AdditionalData(documentId: '{$documentId}'))
                .toJson());
        break;
    }

    prefs.setStringList(notificationDataKey, list);
    prefs.setInt(notificationVersionKey, 0);
  }

  // ダミー通知データを削除
  void _clearDummyData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(notificationDataKey, <String>[]);
    prefs.setInt(notificationVersionKey, 0);
  }
}

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  NotificationWidgetState createState() => NotificationWidgetState();
}

class NotificationWidgetState extends State<NotificationWidget> {
  List<String> _data = <String>[];

  Size size = const Size(0, 0);

  static const Color _iconColor = Color(0xFF808080);
  static const Color _borderColor = Color(0xFF8b8b8b);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizeRate = size.width / 1080;

    return RefreshIndicator(
        onRefresh: () async {
          await _getData();
          setState(() => {});
        },
        child: ListView.custom(
          padding:
              EdgeInsets.symmetric(vertical: 0.0, horizontal: 50 * sizeRate),
          childrenDelegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20 * sizeRate),
                child: Text("お知らせ", style: TextStyle(fontSize: 60 * sizeRate)),
              );
            }
            index -= 1;
            if (index < _data.length) {
              return buildListItem(_data[index], sizeRate);
            } else {
              return null;
            }
          }),
        ));
  }

  Widget buildListItem(String src, double sizeRate) {
    final item = NotificationItem.fromJson(src);

    String message = '';
    switch (item.nId) {
      case 100: // フォローされた
        message = '${item.additionalData.userUid} さんにフォローされました';
        break;
      case 200: // フォローユーザが日記を新規投稿
        message = '${item.additionalData.userUid} さんが狩猟日記を投稿しました';
        break;
      case 300: // 自身の投稿にコメントされた
        message = '${item.additionalData.userUid} さんがあなたの狩猟日記にコメントしました';
        break;
      case 310: // 他者の投稿にコメント（返信）された
        message = '${item.additionalData.userUid} さんがあなたのコメントに返信しました';
        break;
      case 400: // 運営からの通知ありNEWS投稿
        message = 'title';
        break;
      case 500: // 運営からの通知あり広告投稿
        message = 'title';
        break;
      default:
        // 不正なデータ
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10 * sizeRate, horizontal: 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: _borderColor)),
      ),
      child: Row(children: [
        Container(
          width: 80 * sizeRate,
          height: 80 * sizeRate,
          color: _iconColor,
          margin: EdgeInsets.fromLTRB(0, 0, 20 * sizeRate, 0),
        ),
        Text(message),
      ]),
    );
  }

  Future<void> _getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int version = prefs.getInt(notificationVersionKey) ?? -1;
    _data = version != -1
        ? prefs.getStringList(notificationDataKey) ?? <String>[]
        : <String>[];
  }
}
