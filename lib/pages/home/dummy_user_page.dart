// dart
import 'package:flutter/material.dart';

// third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/go_router/router.dart';
import 'package:hunters_app/pages/my_page/introduction_view.dart';
import 'package:hunters_app/theme/hunters_appbar.dart';

class DummyUserPage extends StatefulWidget {
  final String userUid;
  const DummyUserPage({super.key, required this.userUid});

  @override
  // ignore: no_logic_in_create_state
  DummyUserPageState createState() => DummyUserPageState(userUid: userUid);
}

class DummyUserPageState extends State<DummyUserPage> {
  final String userUid;
  DummyUserPageState({required this.userUid});

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // コンストラクタ
  var followCount = '';
  var followerCount = '';
  String name = '';
  String introduction = '';
  Map<String, dynamic>? huntsHistory;
  Map<int, dynamic>? animals;

  bool isVisible = true;
  List<String> animalsName = [];
  var animalList = '';
  var diaries = '';

  // ↓これでfirebaseからデータを取得しています。
  Future _fetchUserData() async {
    final db = FirebaseFirestore.instance;
    // late DocumentReference docRef;
    // try {
    //   docRef = db.collection('usersPublic').doc(introducerId);
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
    final DocumentReference docRef = db.collection('usersPublic').doc(userUid);

    late DocumentSnapshot snapshot;

    try {
      snapshot = await docRef.get();
    } catch (e) {
      debugPrint(e.toString());
    }

    // フィールドを取得
    final followCount = snapshot.get('followCount').toString();
    final followerCount = snapshot.get('followerCount').toString();
    final String name = snapshot.get('name').toString();
    final String introduction = snapshot.get('introduction').toString();
    var huntsHistory = snapshot.get('huntsHistory');

    var bear = huntsHistory['bear'];
    var boar = huntsHistory['boar'];
    var deer = huntsHistory['deer'];
    var duck = huntsHistory['duck'];
    var otherBirds = huntsHistory['otherBirds'];
    var others = huntsHistory['others'];

    Map animals = {
      bear: '🐻   ',
      boar: '🐗   ',
      deer: '🫎   ',
      duck: '🦆   ',
      otherBirds: '🐦‍⬛   ',
      others: '🐒   ',
    };

    var animalList = animals.toString();
    animalList = animalList.replaceAll(",", "");
    animalList = animalList.replaceAll(":", "");
    animalList = animalList.replaceAll("{", "");
    animalList = animalList.replaceAll("}", "");

    // コンストラクタに、取得したfirebaseのデータを入れて画面を更新
    setState(() {
      this.followCount = followCount;
      this.followerCount = followerCount;
      this.name = name;
      this.introduction = introduction;
      this.animalList = animalList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HuntersAppBar(
        title: '日記',
      ),
      body: FutureBuilder(
        // 1秒待機させて画面描画を待ちます
        future: _wait(1),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: 270,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Container(
                        color: Colors.grey,
                        height: 230,
                      ),
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 240,
                            color: Colors.black,
                            child: _imageView(),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 350, bottom: 180.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: _settingIcon(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 16.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          height: 21,
                          width: 96,
                          child: ElevatedButton(
                            onPressed: () => debugPrint("$nameをフォローする"),
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'フォローする',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 100.0),
                            child: Text(name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Align(
                          alignment: Alignment.bottomLeft, child: _ovalIcon()),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 16.0, bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (followCount == '0') {
                                  () {}; // 何もしない
                                }
                                if (followCount != '0') {
                                  if (context.mounted) {
                                    context.pushNamed(
                                        RoutesName.followFollower.name,
                                        extra: true);
                                  }
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: SizedBox(
                                        height: 17,
                                        width: 12,
                                        child: Text(
                                          followCount,
                                          style: const TextStyle(fontSize: 12),
                                        )),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.account_circle,
                                    color: Colors.blue,
                                    // size:
                                  ),
                                  const SizedBox(width: 2.0),
                                  const Text(
                                    'フォロー',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () async {
                                if (followerCount == '0') {
                                  () {}; // 何もしない
                                }
                                if (followerCount != '0') {
                                  if (context.mounted) {
                                    context.pushNamed(
                                        RoutesName.followFollower.name,
                                        extra: false);
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: SizedBox(
                                        height: 17,
                                        width: 12,
                                        child: Text(
                                          followerCount,
                                          style: const TextStyle(fontSize: 12),
                                        )),
                                  ),
                                  const SizedBox(width: 2),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Color.fromARGB(237, 246, 3, 100),
                                      // size:
                                    ),
                                  ),
                                  const SizedBox(width: 2.0),
                                  const Text(
                                    'フォロワー',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '自己紹介',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Visibility(
                      visible: introduction.length > 140
                          ? isVisible
                          : isVisible = true,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0, right: 16.0),
                          child: SizedBox(
                            height: 21,
                            width: 96,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          IntroductionView(introduction)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'もっと見る',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Column(
                  children: [
                    if (introduction == '')
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 19,
                        ),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                              '自己紹介が入力されていません',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 100,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text(
                          introduction,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ダッシュボード',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (animalList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          '情報がまだありません',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: SizedBox(
                        height: 17,
                        child: Text(animalList),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 19),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '日記',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Visibility(
                      visible: isVisible = false,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0, right: 16.0),
                          child: SizedBox(
                            height: 21,
                            width: 96,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          IntroductionView(introduction)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'もっと見る',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '投稿がまだありません',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      // GridView.count(
                      //   shrinkWrap: true,
                      //   crossAxisCount: 2,
                      //   children: [

                      //     SizedBox(
                      //       height: 138,
                      //       width: 180,
                      //       child: const Align(
                      //         alignment: Alignment.topLeft,
                      //         child: FittedBox(
                      //             alignment: Alignment.centerLeft,
                      //             fit: BoxFit.contain,
                      //             child: Text(
                      //               '投稿がまだありません',
                      //               style: TextStyle(
                      //                   fontSize: 14, fontWeight: FontWeight.bold),
                      //             )),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _imageView() {
    return const FittedBox(
      fit: BoxFit.fill,
      // child: Image.asset(
      //     ''),
    );
  }

  Widget _ovalIcon() {
    return MaterialButton(
      color: Colors.blueGrey,
      shape: const CircleBorder(),
      onPressed: () async {
        // ToDo
      },
      child: const Opacity(
        opacity: 1,
        child: Icon(
          Icons.account_circle,
          color: Colors.grey,
          size: 85,
        ),
      ),
    );
  }

  Widget _settingIcon() {
    return MaterialButton(
      height: 27,
      shape: const CircleBorder(),
      color: const Color.fromRGBO(22, 106, 30, 1.0),
      onPressed: () async {
        context.pushNamed(RoutesName.setting.name);
      },
      child: const Icon(Icons.settings, color: Colors.white, size: 21),
    );
  }

  Future _wait(seconds) async {
    return await Future.delayed(Duration(seconds: seconds));
  }
}
