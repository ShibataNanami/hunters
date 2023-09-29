// dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hunters_app/theme/bottom_appbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//import 'package:latlong2/latlong.dart' as latLng;
import 'dart:async';
import 'dart:math';

// third party
import 'package:cloud_functions/cloud_functions.dart';

// app
import 'package:hunters_app/commons/environment_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> maptileSample = [
  '17670817', // 福岡/山口
  '17680815', // 山口
  '17680816', // 山口
  '17680817', // 山口
  '17680818', // 福岡/山口
  '17690812', // 山口
  '17690815', // 山口
  '17690816', // 山口
  '17690817', // 山口
  '17690818', // 福岡/山口
  '17700812', // 山口
  '17700814', // 山口
  '17700815', // 山口
  '17700816', // 山口
  '17700817', // 山口
  '17700818', // 山口
  '17710814', // 山口
  '17710815', // 山口
  '17710816', // 山口
  '17710817', // 山口
  '17710818', // 山口
  '17720813', // 山口
  '17720814', // 山口
  '17720815', // 山口
  '17720816', // 山口
  '17720817', // 山口
  '17720818', // 山口
  '17730813', // 山口/島根
  '17730814', // 山口/島根
  '17730815', // 山口/島根
  '17730816', // 山口/島根
  '17730817', // 山口
  '17730818', // 山口
  '17740815', // 山口/島根
  '17740816', // 山口/島根
  '17740817', // 山口
  '17740818', // 山口
  '17740819', // 山口
  '17750814', // 山口/島根/広島
  '17750815', // 山口/島根/広島
  '17750816', // 山口/広島
  '17750817', // 山口
  '17750818', // 山口
  '17750819', // 山口
  '17750820', // 山口
  '17760816', // 山口/広島
  '17760817', // 山口
  '17760818', // 山口
  '17760819', // 山口
  '17770817', // 山口/広島
  '17770818', // 山口/愛媛
  '17770819', // 山口/愛媛
  '18140804', // 埼玉/東京
  '18140805', // 山梨/埼玉/東京
  '18140806', // 山梨/東京
  '18150805', // 埼玉/東京
  '18150806', // 山梨/東京/神奈川
  '18160805', // 埼玉/東京
  '18160806', // 東京/神奈川
  '18160807', // 東京/神奈川
  '18170805', // 埼玉/東京
  '18170806', // 東京/神奈川
  '18170807', // 東京/神奈川
  '18180805', // 埼玉/東京
  '18180806', // 東京/神奈川
  '18180807', // 東京/神奈川
  '18190805', // 埼玉/東京/千葉
  '18190806', // 東京/千葉
  '18190807', // 東京/神奈川
];

///地図画面（Sample）
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapPage> {
  late StreamController<double> _downloadProgress;
  late String displayText = '初期表示';
  late String customToken = '';
//		String mapIdValue = "17670817";
//		String mapIdValue = "17680815";
//  String mapIdValue = "17720817";
  String mapIdValue = "-1";

  bool _showStack = false; // Stackの表示管理

  List<DocumentSnapshot> havemaps = []; // 取得済みマップ
  late DocumentSnapshot mapshot; // マップタイルのデータ（タップするとDL）
  bool functionCalled = false;

  @override
  void initState() {
    super.initState();
    // 回転を縦に固定
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _downloadProgress = StreamController<double>.broadcast();
    //			fetchData();

    // cashクリア
//FirebaseFirestore.instance.terminate().then((_) {
//  FirebaseFirestore.instance.clearPersistence();
//});

    fetchDataHavemap();
/*
			Future.delayed(Duration.zero, () async {
				await _callGetMapFunction();
			});
*/
  }

  @override
  void dispose() {
    // 固定した回転を元に戻す
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _downloadProgress.close();
    super.dispose();
  }

/*
  // 自分が取得しているマップデータを参照する
  // firebaseのDBを直接参照する(tableに何もないと例外エラーになる？
  fetchData() async {
//  Firebaseのキャッシュをクリアしないと前データが残る？
//				FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

    final auth = FirebaseAuth.instance;
    final introducerId = auth.currentUser?.uid.toString();
    final db = FirebaseFirestore.instance;
    final Query haveMapsQuery = db
        .collection('usersPrivate')
        .doc(introducerId)
        .collection('haveMaps')
        .limit(10);
    QuerySnapshot snapshot = await haveMapsQuery.get();
    havemaps = snapshot.docs;
    debugPrint("----------------------------------->>>");
    for (var doc in havemaps) {
      debugPrint(doc.data().toString());
    }
    debugPrint("----------------------------------->>>");

    // マップ取得
    final DocumentReference mapRef = db.collection('maps').doc('17670817'); //
    mapshot = await mapRef.get();
    if (mapshot.exists) {
      debugPrint("-----------------------------------");
      debugPrint(mapshot.data().toString());
      debugPrint("-----------------------------------");
    } else {
      debugPrint("-----------------------------------");
      debugPrint('Document does not exist');
      debugPrint("-----------------------------------");
    }
  }
*/
  // ----------------------------------------
  // firestore のユーザデータから havemapsを取得
  // ----------------------------------------
  fetchDataHavemap() async {
//				FirebaseFirestore.instance.clearPersistence();
    final auth = FirebaseAuth.instance;
    final introducerId = auth.currentUser?.uid.toString();
    final db = FirebaseFirestore.instance;
    final Query haveMapsQuery = db
        .collection('usersPrivate')
        .doc(introducerId)
        .collection('haveMaps')
        .limit(10);
//			QuerySnapshot snapshot = await haveMapsQuery.get();
    QuerySnapshot? snapshot;
    if (EnvironmentVariables.isEmulator) {
      snapshot =
          await haveMapsQuery.get(const GetOptions(source: Source.server));
    } else {
      snapshot = await haveMapsQuery.get();
    }

    setState(() {
      havemaps = snapshot?.docs ?? [];
//      havemaps = snapshot.docs;
    });
    debugPrint("-----------------    fetchDataHavemap    ------------------");
    for (var doc in havemaps) {
      debugPrint(doc.data().toString());
    }
    debugPrint("-----------------    fetchDataHavemap    ------------------");
  }

  // ----------------------------------------
  // firestore のmapsから該当idのmap情報を取得
  // ----------------------------------------
  fetchDataMaps(String mapId) async {
    // マップ取得
//				final DocumentReference mapRef = db.collection('maps').doc('17670817'); //
    final db = FirebaseFirestore.instance;
    final DocumentReference mapRef = db.collection('maps').doc(mapId); //
    mapshot = await mapRef.get();
    debugPrint("--------------------    fetchDataMaps    ---------------");
    if (mapshot.exists) {
      debugPrint(mapshot.data().toString());
    } else {
      debugPrint('Document does not exist');
    }
    debugPrint("--------------------    fetchDataMaps    ---------------");
  }

  // ----------------------------------------
  // cloud function <applyCustomTokenForGetMap> を呼び出し
  // 取得したマップをユーザデータに書き込み
  // ----------------------------------------
  Future<void> _callGetMapFunction() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      debugPrint("..........................................カレントユーザが存在しません");
      return; //
    } else {
      debugPrint("..........................................ユーザOK");
      try {
        final functions =
            FirebaseFunctions.instanceFor(region: 'asia-northeast1');
        final result = await functions
            .httpsCallable('applyCustomTokenForGetMap')
            .call(<String, dynamic>{
          'mapId': mapIdValue,
        });

        debugPrint("Result data: ${result.data}");

        if (result.data['success'] == true) {
          customToken = result.data['result']['token'];
          displayText =
              "......................SUCCESS!! call applyCustomTokenForGetMap";
          debugPrint(customToken);
        } else {
          debugPrint(result.toString());
          customToken = '';
          displayText =
              "........................ERROR!! call applyCustomTokenForGetMap: ${result.data['error']['code']}";
        }
      } catch (e) {
        customToken = '';
        displayText =
            "..................FAILED!! call applyCustomTokenForGetMap";
        debugPrint("...................error _callGetMapFunction(): $e");
      }
    }
  }

  // ----------------------------------------
  // ダウンロードしますかダイアログ
  // ----------------------------------------
  // ダイアログを閉じるのにcallGetMapFunctionをまつ
  Future<void> handleAsyncPart() async {
    if (!functionCalled) {
      functionCalled = true;
      await _callGetMapFunction();
      await fetchDataHavemap();
    }
  }

  void handleUIUpdate(BuildContext dialogContext) {
    setState(() {
      _showStack = false;
    });
    Navigator.of(dialogContext, rootNavigator: true).pop();
  }

  // ダイアログ本体
  _showMyDialog() {
    Timer? timer;
    double progress = 0.0;
    final completer = Completer<void>(); // Completerのインスタンスを作成

    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      progress += 0.05;
      if (progress >= 1.0) {
        progress = 1.0;
        _downloadProgress.add(progress);
        timer.cancel();

        await handleAsyncPart();
        completer.complete(); // 非同期操作が完了したのでCompleterを完了させる
      } else {
        _downloadProgress.add(progress);
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        completer.future.then((_) {
          // 非同期操作が完了したことを検知
          handleUIUpdate(dialogContext); // UIの更新を行う
        });

        return AlertDialog(
          title: const Icon(
            Icons.map,
            size: 40.0,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "地図をダウンロードしています",
                style: TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ダウンロード中… 2/4",
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              const SizedBox(height: 16.0),
              StreamBuilder<double>(
                stream: _downloadProgress.stream,
                initialData: 0.0,
                builder: (context, snapshot) {
                  return LinearProgressIndicator(value: snapshot.data ?? 0.0);
                },
              ),
              const SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  "キャンセル",
                  style: TextStyle(fontSize: 12.0),
                ),
              ), /*													Container(
															height: 20.0,
															child: OutlinedButton(
																	onPressed: () {
																			Navigator.of(context).pop();
																	},
																	child: Text(
																			"キャンセル",
																			style: TextStyle(fontSize: 12.0),
																	),
																	style: OutlinedButton.styleFrom(
																			side: BorderSide(color: Colors.grey),
																			shape: RoundedRectangleBorder(
																					borderRadius: BorderRadius.circular(50),
																			),
																	),
															),
													),*/
            ],
          ),
        );
      },
    ).then((value) => timer?.cancel());
  }

  // ----------------------------------------
  // 地図タイル
  // ----------------------------------------
  final bool grid = true;
//  ValueNotifier<MapPosition> _mapPosition = ValueNotifier<MapPosition>(MapPosition(center: LatLng(35.652832, 139.839478), zoom: 11.0));

  final Set<SetTileCoordinates> tappedTiles = {};
  // タップされた地点
  final ValueNotifier<LatLng> _tappedPosition =
      ValueNotifier<LatLng>(const LatLng(35.652832, 139.839478));
  String _tappedMapId = "";
  String _tappedMapName = "";
  String _tappedMapGet = "未取得";
  bool _tappedMapFlag = false;

  Widget tileBuilder(BuildContext context, Widget tileWidget, TileImage tile) {
    final coords = tile.coordinates;
//    bool isTappedTile = tappedTiles.contains(SetTileCoordinates(coords.x, coords.y, coords.z));

    // タップされたタイルの境界を取得
    LatLngBounds bounds = tileToBounds(coords);
    // タイルの中心座標を計算
    LatLng center = LatLng(
      (bounds.northEast.latitude + bounds.southWest.latitude) / 2,
      (bounds.northEast.longitude + bounds.southWest.longitude) / 2,
    );
    String mapid = '${coords.x.toString().padLeft(4, '0')}'
        '${coords.y.toString().padLeft(4, '0')}';
    // havemapsからmapidを取得して新しいセットに格納します。
    Set<String> mapIdsInHaveMaps = havemaps.map((doc) => doc.id).toSet();

    // 現在のmapidがセットに存在するかどうかを確認します。
    bool isMapIdInHaveMaps = mapIdsInHaveMaps.contains(mapid);

    // 山口県がこのタイルに含まれているかどうかの確認
//    bool containsYamaguchi = isTileInYamaguchi(coords);
    int tileState = 0; // 取得不可能
    if (isMapIdInHaveMaps) {
      tileState = 1; // 取得済み
    } else if (maptileSample.map((e) => e.toString()).contains(mapid)) {
      tileState = 2; // 取得可能
    }

    return Container(
      decoration: BoxDecoration(
        // zoom11だけグリッドとアイコンを表示
        border: (grid && coords.z == 11) ? Border.all(color: Colors.red) : null,
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          tileWidget,

          // 透過のカラーを追加
          Positioned.fill(
            child: Container(
              color: isMapIdInHaveMaps
                  ? Colors.green.withOpacity(0.5) // 緑
                  : Colors.transparent, // その他は透明
            ),
          ),

          if (coords.z == 11) // zoom11だけグリッドとアイコンを表示
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await fetchDataMaps(
                        mapid); // ここでawaitキーワードを使用してfetchDataを呼び出す
                    setState(() {
                      _showStack = true;
                      tappedTiles.add(SetTileCoordinates(
                          coords.x, coords.y, coords.z)); // タップされた座標をSetに追加
//                      _tappedPosition.value = tileToLatLng(coords.x, coords.y, coords.z); // タップされた地点を計算して保存
                      _tappedPosition.value = center; // タップされた地点を計算して保存
                      _tappedMapId = mapid;
                      mapIdValue = mapid;
                      if (mapshot.exists) {
                        _tappedMapName = mapshot.get('name');
                        _tappedMapFlag = true;
                        _tappedMapGet = "未取得";

                        for (var doc in havemaps) {
                          debugPrint(doc.data().toString());
                          debugPrint(
                              "Document ID: ${doc.id}"); // ここでドキュメントIDを出力
                          if (doc.id == mapid) {
                            _tappedMapGet = "取得済み";
                            _tappedMapFlag = false;
                            debugPrint("Name contains mapId!");
                            break;
                          }
                        }
                      } else {
                        _tappedMapName = "非対応地区";
                        _tappedMapFlag = false;
                        _tappedMapGet = "";
                      }
                    });
                    debugPrint(
                        'タイルをタップ: ${coords.z}/${coords.x}/${coords.y} >>>>>>>>> $mapid');
                  },
                  /*
                  child: Icon(
                    // 1度押されているアイコンはアイコンを変える
//                    isTappedTile ? Icons.map : Icons.check_circle_outline,
                    // tileStateでアイコンを変更
  tileState == 1
    ? Icons.check_circle
    : tileState == 2
        ? Icons.map
        : Icons.help, // デフォルト

											color: (mapid == mapIdValue)
								? Colors.black
								: Colors.white,
                    size: 40.0,
                  ),
										*/
                  child: Opacity(	// 1,2 以外は透過0で見えなく
                    opacity: tileState == 1 || tileState == 2 ? 1.0 : 0.0,
                    child: Icon(
                      tileState == 1
                          ? Icons.check_circle
                          : tileState == 2
                              ? Icons.map
                              : Icons.help, // デフォルト

                      color:
                          (mapid == mapIdValue) ? Colors.black : Colors.white,
                      size: 50.0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ----------------------------------------
  // マップ画面本体
  // ----------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地図画面（Sample）'),
      ),
      body: Column(
        children: [
          // テキスト1
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
              child: const Text(
                '地図',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              child: const Text(
                'アイコンをタップすると地図のダウンロードが行えます。',
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ),
          // ここにボタンを追加
//    ElevatedButton(
//      onPressed: _callGetMapFunction,  // ボタンが押されたときに実行する関数
//      child: Text('_callGetMapFunctionを実行'),
//    ),
          // Map placeholder
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Transform.scale(
                scale: 1,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 2,
                  height: MediaQuery.of(context).size.width * 2,
                  child: FlutterMap(
                    options: MapOptions(
                      center: const LatLng(34.1864, 131.4705), // 山口県
                      zoom: 11.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                        tileBuilder: tileBuilder,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 現在のダウンロード数
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: Text(
                '現在のダウンロード数 ${havemaps.length}/4',
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
          ),
          // 下部マップ詳細
          _showStack
              ? Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FlutterMapを表示 このなかはの表示が2倍
                          SizedBox(
                            width: 100.0, // ここでマップの幅を調整
                            height: 100.0, // ここでマップの高さを調整

                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Transform.scale(
                                scale: 1,
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: ValueListenableBuilder<LatLng>(
                                    valueListenable: _tappedPosition,
                                    builder: (BuildContext context,
                                        LatLng tappedPosition, Widget? child) {
                                      debugPrint(
                                          'Tapped position: $tappedPosition');
                                      return FlutterMap(
                                        key: ValueKey(
                                            tappedPosition), // tappedPositionをキーとして設定　キャッシュを強制クリアする
                                        options: MapOptions(
                                          center: tappedPosition,
                                          zoom: 11.0,
                                          interactiveFlags: 0,
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName:
                                                'dev.fleaflet.flutter_map.example',
                                            tileBuilder: tileBuilder,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // 詳細テキスト
                          const SizedBox(width: 10.0), // FlutterMapの後のスペースを確保
//                          Text( '$_tappedMapName\nID $_tappedMapId\n$_tappedMapGet\n${tappedTiles.length}\n${_tappedPosition.value.latitude},${_tappedPosition.value.longitude}'),
                          Text(
                              '$_tappedMapName\nID $_tappedMapId\n$_tappedMapGet'),
                        ],
                      ),
                    ),
                    // 対応マップでダウンロードしてないものはボタンを表示
                    if (_tappedMapFlag)
                      Positioned(
                        bottom: 10.0,
                        right: 10.0,
                        child: SizedBox(
                          height: 20.0,
                          child: ElevatedButton(
                            onPressed: _showMyDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text(
                              'ダウンロード',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : Container(),
        ],
      ),
      bottomNavigationBar: const HomeButtomAppbar(),
    );
  }
}

// タイルが押されたかのチェック
class SetTileCoordinates {
  final int x, y, z;

  SetTileCoordinates(this.x, this.y, this.z);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SetTileCoordinates &&
        other.x == x &&
        other.y == y &&
        other.z == z;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}

// タイルからlatlangを
double sinh(double x) {
  return (exp(x) - exp(-x)) / 2;
}

LatLng tileToLatLng(int x, int y, int z) {
  double n = pow(2.0, z).toDouble();
  double lonDeg = x / n * 360.0 - 180.0;
  double latRad = atan(sinh(pi * (1 - 2 * y / n)));
  double latDeg = latRad * 180.0 / pi;
  return LatLng(latDeg, lonDeg);
}

// タイル座標から境界（左上と右下）を計算する関数
LatLngBounds tileToBounds(TileCoordinates coords) {
  double n = pow(2, coords.z).toDouble();
  double lonDeg1 = coords.x / n * 360.0 - 180.0;
  double latRad1 = atan(sinh(pi * (1 - 2 * coords.y / n)));
  double latDeg1 = latRad1 * 180.0 / pi;

  double lonDeg2 = (coords.x + 1) / n * 360.0 - 180.0;
  double latRad2 = atan(sinh(pi * (1 - 2 * (coords.y + 1) / n)));
  double latDeg2 = latRad2 * 180.0 / pi;

  return LatLngBounds(
    LatLng(latDeg1, lonDeg1),
    LatLng(latDeg2, lonDeg2),
  );
}
/*
bool isTileInYamaguchi(TileCoordinates coords) {
  LatLngBounds yamaguchiBounds = LatLngBounds(
      const LatLng(33.7, 130.6), // 南西端
      const LatLng(34.6, 132.1) // 北東端
      );

  LatLngBounds tileBounds = tileToBounds(coords);

  return yamaguchiBounds.contains(tileBounds.southWest) &&
      yamaguchiBounds.contains(tileBounds.northEast);
}
*/
