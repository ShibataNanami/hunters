// dart
import 'package:flutter/material.dart';

// third party
import 'package:hunters_app/profile/area_dialog_title.dart';
import 'package:hunters_app/profile/profile_date_get.dart';

///活動エリア選択のリスト部分の設定
class AreaList extends StatefulWidget {
  const AreaList({
    Key? key,
    required this.areas,
    required this.onAreasChanged,
  }) : super(key: key);

  final Map<String, bool> areas;
  final Function(Map<String, bool>) onAreasChanged;

  @override
  AreaListState createState() => AreaListState();
}

class AreaListState extends State<AreaList> {
  Map<String, bool> areas = {};
  Map<String, bool> _areas = {};

  @override
  void initState() {
    super.initState();
    getAreasDate().then((value) {
      setState(() {
        areas = value;
        _areas = Map.from(widget.areas);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 27,
      itemCount: _areas.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const ListTitle(title: '北海道');
        }
        if (index == 2) {
          return const ListTitle(title: '東北');
        }
        if (index == 9) {
          return const ListTitle(title: '関東');
        }
        if (index == 17) {
          return const ListTitle(title: '中部');
        }
        if (index == 27) {
          return const ListTitle(title: '近畿');
        }
        if (index == 35) {
          return const ListTitle(title: '中国');
        }
        if (index == 41) {
          return const ListTitle(title: '四国');
        }
        if (index == 46) {
          return const ListTitle(title: '九州・沖縄');
        } else {
          String areaName = _areas.keys.elementAt(index);
          bool isEnabled = areas.containsKey(areaName);
          //firestoreのareasの中に含まれていないデータの設定
          if (!isEnabled) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 17,
                        height: 17,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(
                      displayNames[areaName] ?? areaName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                _areas[areaName] = !_areas[areaName]!;
                widget.onAreasChanged(_areas);
              });
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: _areas[areaName] == true
                          ? Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(
                      displayNames[areaName] ?? areaName,
                      style: isEnabled
                          ? const TextStyle(fontSize: 12)
                          : const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

///リストの表示名の設定
Map<String, String> displayNames = {
  //北海道
  'area1': 'エリア1',
  'hokkaido': '北海道',
  //東北
  'area2': 'エリア2',
  'aomori': '青森県',
  'iwate': '岩手県',
  'akita': '秋田県',
  'miyagi': '宮城県',
  'yamagata': '山形県',
  'fukushima': '福島県',
  //関東
  'area3': 'エリア3',
  'ibaragi': '茨城県',
  'tochigi': '栃木県',
  'gunma': '群馬県',
  'saitama': '埼玉県',
  'chiba': '千葉県',
  'tokyo': '東京都',
  'kanagawa': '神奈川県',
  //中部
  'area4': 'エリア4',
  'nigata': '新潟県',
  'toyama': '富山県',
  'ishikawa': '石川県',
  'fukui': '福井県',
  'yamanashi': '山梨県',
  'nagano': '長野県',
  'gifu': '岐阜県',
  'shizuoka': '静岡県',
  'aichi': '愛知県',
  //近畿
  'area5': 'エリア5',
  'mie': '三重県',
  'shiga': '滋賀県',
  'kyoto': '京都府',
  'oshaka': '大阪府',
  'hyogo': '兵庫県',
  'nara': '奈良県',
  'wakayama': '和歌山県',
  //中国
  'area6': 'エリア6',
  'tottori': '鳥取県',
  'shimane': '島根県',
  'okayama': '岡山県',
  'hiroshima': '広島県',
  'yamaguchi': '山口県',
  //四国'
  'area7': 'エリア7',
  'tokushima': '徳島県',
  'kagawa': '香川県',
  'ehime': '愛媛県',
  'kouchi': '高知県',
  //九州・沖縄
  'area8': 'エリア8',
  'fukuoka': '福岡県',
  'saga': '佐賀県',
  'nagasaki': '長崎県',
  'kumamoto': '熊本県',
  'oita': '大分県',
  'miyazaki': '宮崎県',
  'kagoshima': '鹿児島県',
  'okinawa': '沖縄県',
};
