// dart
import 'package:flutter/material.dart';

// third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_svg/svg.dart';

// app
import 'package:hunters_app/theme/hunters_appbar.dart';
import 'package:hunters_app/theme/bottom_appbar.dart';
import 'package:hunters_app/profile/area_list.dart';
import 'new_diaries_list_page.dart';
import 'news_list_page.dart';
import 'news_detail_page.dart';
import 'dummy_user_page.dart';

///ホーム画面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

///登録完了後及びログイン完了後のHome画面
class HomePageState extends State<HomePage> {
  // 日記データ
  final List<DiaryData> _diaryDatas = [];
  List<DiaryData> get diaryDatas => _diaryDatas;
  // ニュースデータ
  final List<NewsData> _newsDatas = [];
  List<NewsData> get newsDatas => _newsDatas;

  // データ初期化フラグ
  bool _isDataInited = false;

  // 画面幅
  double _width = 512;
  double get imageSize => _width / 4;
  double get labelSize => _width / 16;
  double get spaceSize => _width / 24;
  double get paddingSize => _width / 20;

  @override
  void initState() {
    _fetchDiaryData();
    super.initState();
  }

  _fetchDiaryData() async {
    final db = FirebaseFirestore.instance;

    // diariesはlist取得できないので、filterDiaryからID取得
    final filterDiaryColRef = db
        .collectionGroup('filterDiary')
        .where('restrictedByAdmin', isEqualTo: false)
        .orderBy('createDate', descending: true)
        .limit(10);

    // 日記データを取得
    final filterDiarySnapshot = await filterDiaryColRef.get();
    try {
      for (var filterDiaryDoc in filterDiarySnapshot.docs) {
        final createUserUid = filterDiaryDoc.get('createUserUid');
        final user = db.collection('usersPublic').doc(createUserUid);
        await user
            .collection('diaries')
            .doc(filterDiaryDoc.id)
            .get()
            .then((diary) async {
          // ユーザデータ
          final userSnapshot = await user.get();
          // 日記データインスタンス
          DiaryData diaryData = DiaryData();

          // ユーザ名
          diaryData.name = userSnapshot.get('name');
          // 地域
          if (diary.get('areaFlg')) {
            // 日本語で取得
            diaryData.areas = getKeysOfTrue(filterDiaryDoc.get('areas'))
                .map((area) => displayNames[area] ?? area)
                .toList();
          }
          // 鳥獣
          if (diary.get('animalFlg')) {
            // アイコンで取得
            diaryData.animals = getKeysOfTrue(filterDiaryDoc.get('animals'))
                .map((animal) => displayAnimalIcons[animal] ?? animal)
                .toList();
          }
          // 日記本文
          diaryData.body = diary.get('body');
          // ユーザアイコン
          final iconUrl =
              await getImageUrl("thumbnails/low/$createUserUid.png");
          final iconSize = imageSize / 2;
          diaryData.thumbnail = iconUrl == ''
              ? SvgPicture.asset(
                  'assets/com_user_noimage.svg',
                  width: iconSize,
                  height: iconSize,
                )
              : Image.network(
                  iconUrl,
                  width: iconSize,
                  height: iconSize,
                );
          // 投稿画像
          final imagePaths = diary.get('imagePaths');
          diaryData.image = imagePaths == null
              ? SvgPicture.asset(
                  'assets/com_pic_noimage.svg',
                  width: imageSize,
                  height: imageSize,
                )
              : Image.network(
                  await getImageUrl(imagePaths[0]),
                  width: imageSize,
                  height: imageSize,
                );
          // ユーザID
          diaryData.userUid = createUserUid;

          // リストに追加
          _diaryDatas.add(diaryData);
        });
      }
    } on FirebaseException catch (_, e) {
      debugPrint(e.toString());
    }

    // ニュースデータを取得
    final noticesColRef = db
        .collection('notices')
        .orderBy('createDate', descending: true)
        .limit(10);
    final noticesSnapshot = await noticesColRef.get();
    try {
      for (var noticeDoc in noticesSnapshot.docs) {
        // ニュースカテゴリのみ処理
        if (noticeDoc.get('category') != 'news') {
          continue;
        }
        // 日記データインスタンス
        NewsData newsData = NewsData();
        newsData.title = noticeDoc.get('title');
        newsData.body = noticeDoc.get('body');

        // リストに追加
        _newsDatas.add(newsData);
      }
    } on FirebaseException catch (_, e) {
      debugPrint(e.toString());
    }

    _isDataInited = true;
  }

  @override
  Widget build(BuildContext context) {
    // 画面幅取得
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: const HuntersAppBar(
          title: 'ホーム画面',
        ),
        bottomNavigationBar: const HomeButtomAppbar(),
        body: FutureBuilder(
            future: _wait(2),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !_isDataInited) {
                // 接続するまでローディング画面
                return _loadingWidget(100);
              } else {
                _isDataInited = false;
                // 新着日記ウィジェット
                List<Widget> diariesWidgets = _diaryDatas
                    .take(4)
                    .map((diaryData) => getDiaryWidget(diaryData, context))
                    .toList();
                // 空の場合テキスト
                if (diariesWidgets.isEmpty) {
                  diariesWidgets
                      .add(const Row(children: [Text('日記を取得できませんでした')]));
                }

                // ニュースウィジェット
                List<Widget> newsWidgets = _newsDatas
                    .take(4)
                    .map((newsData) => getNewsWidget(newsData, context))
                    .toList();
                // 空の場合テキスト
                if (newsWidgets.isEmpty) {
                  newsWidgets
                      .add(const Row(children: [Text('ニュースを取得できませんでした')]));
                }

                // ページ本体
                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(paddingSize, 0, paddingSize, 0),
                    child: Column(children: [
                      // 新着日記ラベル
                      Row(children: [
                        Text(
                          '新着日記',
                          style: TextStyle(
                              fontSize: labelSize, fontWeight: FontWeight.bold),
                        ),
                        // もっと見るボタン
                        Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: getSeeMoreButton(
                                  NewDiariesListPage(homePageState: this))),
                        ),
                      ]),
                      // 新着日記一覧
                      Column(children: diariesWidgets),
                      SizedBox(height: spaceSize),

                      // ニュースラベル
                      Row(children: [
                        Text(
                          'HUNTERS NEWS',
                          style: TextStyle(
                              fontSize: labelSize, fontWeight: FontWeight.bold),
                        ),
                        // もっと見るボタン
                        Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: getSeeMoreButton(
                                  NewsListPage(homePageState: this))),
                        ),
                      ]),
                      // ニュース一覧
                      Column(children: newsWidgets),
                      SizedBox(height: spaceSize),

                      // おすすめラベル
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'おすすめ',
                          style: TextStyle(
                              fontSize: labelSize, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // おすすめ一覧
                      const Column(
                        // todo: バックエンド未対応
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.question_mark,
                                color: Colors.grey, size: 96),
                          ),
                        ],
                      ),
                    ]),
                  ),
                );
              }
            }));
  }

  Widget _loadingWidget(double size) {
    return Center(
      child: LoadingAnimationWidget.beat(color: Colors.black, size: size),
    );
  }

  Future _wait(seconds) async {
    return await Future.delayed(Duration(seconds: seconds));
  }

  ///Mapから値がTrueのキーをリストとして取得
  List<String> getKeysOfTrue(Map<String, dynamic>? map) {
    if (map == null) {
      return [];
    }
    return map.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
  }

  ///日記ウィジェット取得
  Widget getDiaryWidget(DiaryData diaryData, BuildContext context,
      {bool isSubPage = false}) {
    return GestureDetector(
      child: Row(
        children: [
          // 投稿画像
          Padding(
            padding: EdgeInsets.all(imageSize / 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(imageSize / 6),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: FittedBox(fit: BoxFit.cover, child: diaryData.image),
              ),
            ),
          ),
          Expanded(
              child: Column(
            // 画像の右のUIは左寄せ
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // ユーザアイコン
                  Padding(
                    padding: EdgeInsets.all(imageSize / 16),
                    child: ClipOval(child: diaryData.thumbnail),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ユーザ名
                      Text(
                        diaryData.name,
                        style: TextStyle(fontSize: imageSize / 4),
                      ),
                      // 地域
                      Text(
                        diaryData.areas.join(' / '),
                        style: TextStyle(fontSize: imageSize / 8),
                      ),
                    ],
                  ),
                  // 鳥獣
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          diaryData.animals.join(' '),
                          style: TextStyle(fontSize: imageSize / 8),
                        )),
                  )
                ],
              ),
              // 日記本文
              SizedBox(
                  height: imageSize / 2,
                  child: Text(
                    diaryData.body,
                    style: TextStyle(fontSize: imageSize / 6),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ))
            ],
          )),
        ],
      ),
      // todo: タップしたら日記ページに移動
      onTap: () {
        if (isSubPage) {
          // 新着日記一覧ページでは以下の処理をしないと遷移しない
          Navigator.pop(context);
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DummyUserPage(
                userUid: diaryData.userUid,
              ),
            ));
      },
    );
  }

  ///ニュースウィジェット取得
  Widget getNewsWidget(NewsData newsData, BuildContext context) {
    return GestureDetector(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "・${newsData.title}",
          style: TextStyle(
            fontSize: imageSize / 6,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      // タップしたらニュースページに移動
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(
                homePageState: this,
                newsData: newsData,
              ),
            ));
      },
    );
  }

  ///もっと見るボタン取得
  ElevatedButton getSeeMoreButton(Widget newPage) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => newPage,
            ));
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const StadiumBorder(),
          side: const BorderSide(),
          minimumSize: Size(imageSize, imageSize / 4)),
      child: Text(
        'もっと見る',
        style: TextStyle(color: Colors.black, fontSize: imageSize / 8),
      ),
    );
  }

  ///画像URL取得
  Future<String> getImageUrl(String path) async {
    String downloadUrl = '';
    try {
      // Firebase Storageから画像をダウンロード
      Reference ref = FirebaseStorage.instance.ref().child(path);
      downloadUrl = await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error downloading image: $e');
    }
    return downloadUrl;
  }
}

// 日記データ
class DiaryData {
  // ユーザアイコン
  Widget? thumbnail;
  // ユーザ名
  String name = '';
  // 地域
  List<String> areas = [];
  // 鳥獣
  List<String> animals = [];
  // 日記本文
  String body = '';
  // 投稿画像
  Widget? image;

  // ユーザID
  String userUid = '';
}

// ニュースデータ
class NewsData {
  // タイトル
  String title = '';
  // 本文
  String body = '';
}

// 鳥獣アイコン（仮）
const Map<String, String> displayAnimalIcons = {
  'bear': '🐻',
  'boar': '🐗',
  'deer': '🦌',
  'duck': '🦆',
  'otherBirds': '🐦‍',
  'others': '🐒',
};
