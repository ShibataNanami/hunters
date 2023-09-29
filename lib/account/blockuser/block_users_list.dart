// dart
import 'package:flutter/material.dart';

// third party
import 'package:hunters_app/account/blockuser/block_user_date.dart';
import 'package:hunters_app/go_router/router.dart';
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/theme/hunters_appbar.dart';
import 'package:hunters_app/account/blockuser/unblock_dialog.dart';

// app
import 'package:go_router/go_router.dart';

///ブロック中のユーザーの一覧表示画面
class BlockUsersList extends StatefulWidget {
  final String name;
  const BlockUsersList({super.key, required this.name});

  @override
  State<BlockUsersList> createState() => _BlockUsersListState();
}

class _BlockUsersListState extends State<BlockUsersList> {
  List<String> names = [];

  @override
  void initState() {
    super.initState();
    getBlockUserNameData().then((value) {
      setState(() {
        names = value;
      });
    });
  }

  ///ブロック解除確認のダイアログ呼び出し
  Future<void> unBlockDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return UnblockDialog(widget.name);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HuntersAppBar(
        title: 'ブロック中のユーザー',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 13.0, 16.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: names
                  .map((name) => GestureDetector(
                        onTap: () {
                          context.pushNamed(RoutesName.otherUser.name);
                        },
                        child: SizedBox(
                          height: 33,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_circle,
                                size: 33,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  name.toString(),
                                  style: blackBoldFont,
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  unBlockDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(90, 20),
                                ),
                                child: Text(
                                  'ブロック中',
                                  style: whiteFont,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
