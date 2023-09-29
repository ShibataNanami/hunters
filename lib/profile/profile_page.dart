// dart
import 'package:flutter/material.dart';
import 'package:hunters_app/go_router/router.dart';

// third party
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/profile/animal_dialog.dart';
import 'package:hunters_app/profile/area_dialog.dart';
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/profile/header_image.dart';
import 'package:hunters_app/profile/icon_image.dart';
import 'package:hunters_app/dialog/Sample_dialog.dart';
import 'package:hunters_app/profile/profile_date_get.dart';
import 'package:hunters_app/profile/profile_date_update.dart';
import 'package:hunters_app/profile/profile_update_check.dart';
import 'package:hunters_app/theme/sample_appbar.dart';

///プロフィール編集画面
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String name = '';
  String introduction = '';
  Map<String, bool> animals = {};
  Map<String, bool> areas = {};
  Map<String, bool> modifiedAnimals = {};
  Map<String, bool> modifiedAreas = {};
  final nameController = TextEditingController();
  final introductionController = TextEditingController();
  bool? animalFlgPublic;
  bool? areaFlgPublic;

  @override
  void initState() {
    super.initState();
    getAnimalFlgPublic().then((value) {
      setState(() {
        animalFlgPublic = value;
      });
    });
    getAreaFlgPublic().then((value) {
      setState(() {
        areaFlgPublic = value;
      });
    });
    getAreasDate().then((value) {
      setState(() {
        areas = value;
        debugPrint('$areas');
      });
    });
    getNameDate(nameController);
    getIntroductionDate(introductionController);
  }

  ///プロフィール更新完了のダイアログを表示させる処理
  Future<void> _profileUpdate() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SampleDialog(
          text: 'プロフィールを更新しました',
          myFunction: _backPage,
        );
      },
    );
  }

  ///アカウント設定のページに戻る処理
  Future<void> _backPage() async {
    context.goNamed(RoutesName.account.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SampleAppBar(
        title: 'プロフィール編集',
        leading: IconButton(
          alignment: Alignment.bottomLeft,
          icon: const Icon(
            Icons.arrow_back,
            size: 50,
          ),
          onPressed: () async {
            await dateCheck(
              context,
              animals,
              areas,
              nameController,
              introductionController,
              animalFlgPublic,
              areaFlgPublic,
            );
            if (context.mounted) {
              GoRouter.of(context).pop();
            }
          },
        ),
        //保存ボタンの設定
        actionButton: ElevatedButton(
          onPressed: () async {
            name = nameController.text;
            introduction = introductionController.text;
            final currentUser =
                await FirebaseAuth.instance.authStateChanges().first;
            await updateUserData(
              currentUser,
              introduction,
              name,
            );
            await updateanimalFlgPublic(
              currentUser,
              animalFlgPublic ?? false,
            );
            await updateareaFlgPublic(
              currentUser,
              areaFlgPublic ?? false,
            );
            await updateAnimalData(
              currentUser,
              animalFlgPublic ?? false,
              animals,
            );
            await updateAreaData(
              currentUser,
              areaFlgPublic ?? false,
              areas,
            );
            _profileUpdate();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(70, 20),
            backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('保存'),
        ),
      ),
      // キーボードを閉じる設定
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                //ヘッダー画像の設定
                const Center(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: HeaderImage(),
                  ),
                ),
                //アイコン画像の設定
                const Positioned(
                  top: 180,
                  left: 16,
                  child: IconImage(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 279, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //ニックネームの設定
                      Text(
                        'ニックネーム',
                        style: blackBoldFont,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: SizedBox(
                          height: 27,
                          child: TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (String value) {
                              name = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '入力してください';
                              } else if (value.length > 20) {
                                return '20文字以内で入力してください';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      //自己紹介の設定
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Text(
                          '自己紹介',
                          style: blackBoldFont,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: SizedBox(
                          height: 80,
                          child: TextFormField(
                            controller: introductionController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //活動エリアの公開・非公開の設定
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 436, 16, 0),
                  child: Row(
                    children: [
                      Text(
                        '活動地域',
                        style: blackBoldFont,
                      ),
                      const SizedBox(width: 22),
                      Switch(
                        value: areaFlgPublic ?? false,
                        onChanged: (value) {
                          setState(() {
                            areaFlgPublic = value;
                          });
                        },
                      ),
                      Text(
                        areaFlgPublic == true ? '公開' : '非公開',
                        style: blackFont,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: EreaSetDialog(
                            onAreasChanged: (Map<String, bool> value) {
                              modifiedAreas = Map.from(value);
                              modifiedAreas.removeWhere(
                                  (key, value) => !areas.containsKey(key));
                              areas = Map.from(modifiedAreas);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //鳥獣区分の公開・非公開の設定
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 470, 16, 0),
                  child: Row(
                    children: [
                      Text(
                        '鳥獣区分',
                        style: blackBoldFont,
                      ),
                      const SizedBox(width: 22),
                      Switch(
                        value: animalFlgPublic ?? false,
                        onChanged: (value) {
                          setState(() {
                            animalFlgPublic = value;
                          });
                        },
                      ),
                      Text(
                        animalFlgPublic == true ? '公開' : '非公開',
                        style: blackFont,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AnimalSetDialog(
                            onAnimalsChanged: (Map<String, bool> value) {
                              modifiedAnimals = Map.from(value);
                              animals = Map.from(modifiedAnimals);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
