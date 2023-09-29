// dart
import 'dart:io';

import 'package:flutter/material.dart';

// third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hunters_app/account/blockuser/block_unblock_function.dart';
import 'package:hunters_app/account/blockuser/unblock_dialog.dart';

// app
import 'package:hunters_app/pages/my_page/introduction_view.dart';
import 'package:hunters_app/theme/font_style.dart';
import 'package:image_picker/image_picker.dart';

class OtherUsersPage extends StatefulWidget {
  const OtherUsersPage({super.key});

  @override
  OtherUsersPageState createState() => OtherUsersPageState();
}

class OtherUsersPageState extends State<OtherUsersPage> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _checkBlockUser();
  }

  // コンストラクタ
  String followCount = '';
  String followerCount = '';
  String name = '';
  String introduction = '';
  Map<String, dynamic>? huntsHistory;
  Map<int, dynamic>? animals;
  bool _isBlocked = false;
  final picker = ImagePicker();
  static File? imageHeader;

  bool isVisible = true;
  List<String> animalsName = [];
  var animalList = '';
  var diaries = '';
  String followYou = 'あなたをフォローしています';

  // ↓これでfirebaseからデータを取得しています。
  _fetchUserData() async {
    final auth = FirebaseAuth.instance;
    final introducerId = auth.currentUser?.uid.toString();
    debugPrint(introducerId);
    final db = FirebaseFirestore.instance;
    final DocumentReference docRef =
        db.collection('usersPublic').doc(introducerId);
    final DocumentSnapshot snapshot = await docRef.get();
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

    if (bear == 0) animals.remove(bear);
    if (boar == 0) animals.remove(boar);
    if (deer == 0) animals.remove(deer);
    if (duck == 0) animals.remove(duck);
    if (otherBirds == 0) animals.remove(otherBirds);
    if (others == 0) animals.remove(others);

    var animalList = animals.toString();
    animalList = animalList.replaceAll(",", "");
    animalList = animalList.replaceAll(":", "");
    animalList = animalList.replaceAll("{", "");
    animalList = animalList.replaceAll("}", "");
    debugPrint(animalList);

    // コンストラクタに、取得したfirebaseのデータを入れて画面を更新
    setState(() {
      this.followCount = followCount;
      this.followerCount = followerCount;
      this.name = name;
      this.introduction = introduction;
      this.animalList = animalList;
    });
  }

  //端末のアルバムに保存されている画像を取得し、ヘッダーに設定する処理
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageHeader = File(pickedFile.path);
      }
    });
  }

  ///ブロック解除確認のダイアログ呼び出し
  Future<bool> unBlockDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return UnblockDialog(name);
      },
    ).then((value) {
      if (value == true) {
        setState(() {
          onBlock = false;
        });
      }
      return value ?? false;
    });
  }

  ///ブロック中のユーザーか確認する処理
  //TODO:後ほど''内にそのユーザーのuidを入れるように修正する
  Future<void> _checkBlockUser() async {
    List<String> blockUsers = await getBlockUserUidData();
    if (blockUsers.contains('8Bik5WNMb1DyVkwNH6d7EjTB2WWO')) {
      setState(() {
        onBlock = true;
      });
    } else {
      setState(() {
        onBlock = false;
      });
    }
  }

  ///blockUsersのuidのデータを取得する処理
  Future<List<String>> getBlockUserUidData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('usersPrivate')
            .doc(currentUser.uid)
            .collection('blockUsers')
            .doc(currentUser.uid)
            .get();
        if (snapshot.exists) {
          List<String> blockUsers = [];
          List<dynamic> data = snapshot.get('blockUsers');
          for (var element in data) {
            blockUsers.add(element['uid']);
          }
          return blockUsers;
        } else {
          debugPrint('ドキュメントが存在しません');
        }
      } catch (e) {
        debugPrint('値の取得中にエラーが発生: $e');
      }
    }
    return [];
  }

  bool onBlock = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: onBlock,
      replacement: _buildUnblockedUserScreen(),
      child: _buildBlockUserScreen(),
    );
  }

  Widget _buildBlockUserScreen() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 223,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: imageHeader != null
                          ? DecorationImage(
                              image: FileImage(imageHeader!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        if (imageHeader == null)
                          SvgPicture.asset(
                            'assets/com_pic_noimage.svg',
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _backButtonIcon(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 181, 0, 0),
                    child: _ovalIcon(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 230, 16, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(height: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: const Size(88, 20),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () async {
                            bool success = await unBlockDialog();
                            if (success) {
                              setState(() {
                                onBlock = false;
                              });
                            }
                          },
                          child: Text(
                            'ブロック中',
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                            softWrap: false,
                            style: whiteFont,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(108, 230, 0, 0),
                    child: Text(
                      name,
                      style: blackBoldFont,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 279),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$nameさんをブロック中です',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              'ブロックしているユーザのプロフィールを閲覧したい場合、'
                              '\nブロックを解除する必要があります。',
                              textAlign: TextAlign.center,
                              style: blackFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnblockedUserScreen() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isBlocked = false;
        });
      },
      child: Scaffold(
        body: FutureBuilder(
            // 1秒待機させて画面描画を待ちます
            future: _wait(1),
            builder: (context, snapshot) {
              return SafeArea(
                child: SingleChildScrollView(
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
                              color: Colors.pink,
                              height: 220,
                            ),
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 50.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 220,
                                    color: Colors.black,
                                    child: _imageView(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 220.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: _dotIcon(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 220.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: _backButtonIcon(),
                            ),
                          ),
                          Stack(
                            children: [
                              const SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 24.0, left: 120.0),
                                      child: Text('hanako',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    )),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 120.0),
                                      child: Text(followYou,
                                          style: const TextStyle(
                                            fontSize: 9,
                                          )),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, right: 16.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 21,
                                    width: 120,
                                    child: FilledButton(
                                      onPressed: () async {
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>

                                        //               ),
                                        // );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        'フォローする',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: _ovalIcon()),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 16.0, bottom: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (followCount == '0') {
                                        // await Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           NoFollowPage(name)),
                                        // );
                                      }
                                      if (followCount != '0') {
                                        if (context.mounted) {
                                          // await Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const FollowListPage()));
                                        }
                                      }
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(
                                              height: 17,
                                              width: 12,
                                              child: Text(
                                                followCount,
                                                style: const TextStyle(
                                                    fontSize: 12),
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
                                        // await Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             NoFollowersPage(name)));
                                      }
                                      if (followerCount != '0') {
                                        if (context.mounted) {
                                          // await Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const FollowersListPage()));
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(
                                              height: 17,
                                              width: 12,
                                              child: Text(
                                                followerCount,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(
                                          Icons.favorite,
                                          color:
                                              Color.fromARGB(237, 246, 3, 100),
                                          // size:
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Visibility(
                            visible: introduction.length > 140
                                ? isVisible
                                : isVisible = true,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 6.0, right: 16.0),
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
                      Row(
                        children: [
                          if (introduction == '')
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 19,
                              ),
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, right: 16.0),
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
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
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
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ダッシュボード',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                      const SizedBox(height: 17),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Visibility(
                            visible: isVisible = false,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 6.0, right: 16.0),
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
                ),
              );
            }),
      ),
    );
  }

  Widget _imageView() {
    return const FittedBox(
      fit: BoxFit.fill,
      // child: Image.asset(
      //     'assets/images/reflection-garden-landscape-lawn-abstract-background-blue-sky-and-white-clouds_1417-1030.jpg'),
    );
  }

  Widget _dotIcon() {
    return MaterialButton(
      shape: const CircleBorder(),
      color: const Color.fromRGBO(22, 106, 30, 1.0),
      onPressed: () {
        setState(() {
          _isBlocked = true;
        });
      },
      height: 27,
      minWidth: 27,
      child: _isBlocked
          ? GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SizedBox(
                  height: 27,
                  width: 95,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    // ToDo 押下すると「ブロックする」に変化してfirebaseでブロック
                    onPressed: () async {
                      bool success = await blockFunction();
                      if (success) {
                        setState(() {
                          onBlock = true;
                          _isBlocked = false;
                        });
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ブロックする',
                        style: smallBlackFont,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
    );
  }

  Widget _backButtonIcon() {
    return MaterialButton(
      shape: const CircleBorder(),
      color: const Color.fromRGBO(22, 106, 30, 1.0),
      height: 27,
      minWidth: 27,
      onPressed: () async {
        context.pop();
      },
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
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

  Future _wait(seconds) async {
    return await Future.delayed(Duration(seconds: seconds));
  }

  Future<void> addCloudFunctions(
      String followerUid, String followUid, String createDate) async {
    final followerUid = FirebaseAuth.instance;
    final functions = FirebaseFunctions.instance;
    final results = await functions
        .httpsCallable('followUnfollowAppUser')
        .call(<String, dynamic>{
      'followerUid': followerUid,
      'followUid': followUid,
      'createDate': FieldValue.serverTimestamp(),
    });
    debugPrint('$followerUid, $followUid, $createDate');
  }
}
