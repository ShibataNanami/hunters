// dart
import 'package:flutter/material.dart';

// third party

// app
import 'package:hunters_app/theme/hunters_appbar.dart';
import 'home_page.dart';

///ニュース詳細画面
class NewsDetailPage extends StatelessWidget {
  final HomePageState homePageState;
  final NewsData newsData;

  // コンストラクタ
  const NewsDetailPage(
      {super.key, required this.homePageState, required this.newsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HuntersAppBar(
          title: 'HUNTERS NEWS',
        ),
        body: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(homePageState.paddingSize),
                  child: Column(children: [
                    Text(
                      newsData.title,
                      style: TextStyle(
                          fontSize: homePageState.labelSize,
                          fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Text(
                      newsData.body,
                      style: TextStyle(fontSize: homePageState.imageSize / 6),
                    ),
                  ])),
            )));
  }
}
