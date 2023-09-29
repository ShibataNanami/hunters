// dart
import 'package:flutter/material.dart';

// third party

// app
import 'package:hunters_app/theme/hunters_appbar.dart';
import 'home_page.dart';

///新着日記一覧画面
class NewDiariesListPage extends StatelessWidget {
  final HomePageState homePageState;

  // コンストラクタ
  const NewDiariesListPage({super.key, required this.homePageState});

  @override
  Widget build(BuildContext context) {
    // 新着日記ウィジェット
    List<Widget> diariesWidgets = homePageState.diaryDatas
        .map((diaryData) =>
            homePageState.getDiaryWidget(diaryData, context, isSubPage: true))
        .toList();
    // 空の場合テキスト
    if (diariesWidgets.isEmpty) {
      diariesWidgets.add(const Row(children: [Text('日記を取得できませんでした')]));
    }

    return Scaffold(
        appBar: const HuntersAppBar(
          title: '新着日記',
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(homePageState.paddingSize),
              child: Column(children: diariesWidgets)),
        )));
  }
}
