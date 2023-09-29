// dart
import 'package:flutter/material.dart';

// third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

// app
import 'package:hunters_app/go_router/router.dart';
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/theme/sample_appbar.dart';

///招待（QRコード作成）画面
class QrCodeViewPage extends StatefulWidget {
  const QrCodeViewPage({super.key});

  @override
  State<QrCodeViewPage> createState() => _QrCodeViewPageState();
}

class _QrCodeViewPageState extends State<QrCodeViewPage> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  var password = "";
  String? introducerId;

  _fetchUserData() async {
    final auth = FirebaseAuth.instance;
    final introducerId = auth.currentUser?.uid.toString();

    final db = FirebaseFirestore.instance;
    final DocumentReference docRef =
        db.collection('usersPrivate').doc(introducerId);
    final DocumentSnapshot snapshot = await docRef.get();
    // フィールドを取得

    var oneTime = snapshot.get('oneTime');
    var password = oneTime['password'].toString();

    setState(() {
      this.password = password;
      this.introducerId = introducerId!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SampleAppBar(
        title: '招待',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: const Color(0xFF006400),
                width: double.infinity,
                height: 134.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Center(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 204,
                              height: 204,
                              color: Colors.white,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: QrImageView(
                              data: 'introducerId : $introducerId\n'
                                  'password : $password',
                              size: 204.0,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(8.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 80.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                  const Icon(
                                    Icons.pets_outlined, // todo: dummy icon
                                    color: Colors.pink,
                                    size: 40.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'QRコードから未登録のユーザーを招待できます。',
                      style: blackFont,
                      // style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '招待したいユーザーQRコードを提示してください。',
                      style: blackFont,
                    ),
                  ),
                  const SizedBox(
                    height: 52.0,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(RoutesName.viewQr.name);
                        },
                        child: Text(
                          'QRコードの更新',
                          style: blackFont.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
