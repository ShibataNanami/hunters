// dart
import 'package:flutter/material.dart';

// third party

// app
import 'package:hunters_app/theme/hunters_appbar.dart';
import 'home_page.dart';

///ニュース一覧画面
class NewsListPage extends StatelessWidget {
  final HomePageState homePageState;

  // コンストラクタ
  const NewsListPage({super.key, required this.homePageState});

  @override
  Widget build(BuildContext context) {
    // ニュースウィジェット
    List<Widget> newsWidgets = homePageState.newsDatas
        .map((newsData) => homePageState.getNewsWidget(newsData, context))
        .toList();
    // 空の場合テキスト
    if (newsWidgets.isEmpty) {
      newsWidgets.add(const Row(children: [Text('ニュースを取得できませんでした')]));
    }

    return Scaffold(
        appBar: const HuntersAppBar(
          title: 'HUNTERS NEWS',
        ),
        body: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(homePageState.paddingSize),
                  child: Column(children: newsWidgets)),
            )));
  }
}
