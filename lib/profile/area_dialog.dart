// dart
import 'package:flutter/material.dart';

// third party
import 'package:hunters_app/profile/area_list.dart';
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/profile/profile_date_get.dart';

// app
import 'package:go_router/go_router.dart';

///活動エリア選択のダイアログの設定
class EreaSetDialog extends StatefulWidget {
  final Function(Map<String, bool>) onAreasChanged;
  const EreaSetDialog({
    Key? key,
    required this.onAreasChanged,
  }) : super(key: key);

  @override
  EreaSetDialogState createState() => EreaSetDialogState();
}

class EreaSetDialogState extends State<EreaSetDialog> {
  late Map<String, bool> areas;
  late Map<String, bool> modifiedAreas;
  late Map<String, bool> newAreas;

  @override
  void initState() {
    super.initState();
    getAreasDate().then(
      (value) {
        setState(
          () {
            areas = value;
            modifiedAreas = Map.from(areas);
            newAreas = {
              //北海道
              'area1': areas[''] ?? false,
              'hokkaido': areas[''] ?? false,
              //東北
              'area2': areas[''] ?? false,
              'aomori': areas[''] ?? false,
              'iwate': areas[''] ?? false,
              'akita': areas[''] ?? false,
              'miyagi': areas[''] ?? false,
              'yamagata': areas[''] ?? false,
              'fukushima': areas[''] ?? false,
              //関東
              'area3': areas[''] ?? false,
              'ibaragi': areas[''] ?? false,
              'tochigi': areas[''] ?? false,
              'gunma': areas[''] ?? false,
              'saitama': areas['saitama'] ?? false,
              'chiba': areas['chiba'] ?? false,
              'tokyo': areas['tokyo'] ?? false,
              'kanagawa': areas['kanagawa'] ?? false,
              //中部
              'area4': areas[''] ?? false,
              'nigata': areas[''] ?? false,
              'toyama': areas[''] ?? false,
              'ishikawa': areas[''] ?? false,
              'fukui': areas[''] ?? false,
              'yamanashi': areas['yamanashi'] ?? false,
              'nagano': areas[''] ?? false,
              'gifu': areas[''] ?? false,
              'shizuoka': areas[''] ?? false,
              'aichi': areas[''] ?? false,
              //近畿
              'area5': areas[''] ?? false,
              'mie': areas[''] ?? false,
              'shiga': areas[''] ?? false,
              'kyoto': areas[''] ?? false,
              'oshaka': areas[''] ?? false,
              'hyogo': areas[''] ?? false,
              'nara': areas[''] ?? false,
              'wakayama': areas[''] ?? false,
              //中国
              'area6': areas[''] ?? false,
              'tottori': areas[''] ?? false,
              'shimane': areas['shimane'] ?? false,
              'okayama': areas[''] ?? false,
              'hiroshima': areas['hiroshima'] ?? false,
              'yamaguchi': areas['yamaguchi'] ?? false,
              //四国
              'area7': areas[''] ?? false,
              'tokushima': areas[''] ?? false,
              'kagawa': areas[''] ?? false,
              'ehime': areas['ehime'] ?? false,
              'kouchi': areas[''] ?? false,
              //九州・沖縄
              'area8': areas[''] ?? false,
              'fukuoka': areas['fukuoka'] ?? false,
              'saga': areas[''] ?? false,
              'nagasaki': areas[''] ?? false,
              'kumamoto': areas[''] ?? false,
              'oita': areas[''] ?? false,
              'miyazaki': areas[''] ?? false,
              'kagoshima': areas[''] ?? false,
              'okinawa': areas[''] ?? false,
            };
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(70, 20),
      ),
      child: Text(
        '編集',
        style: whiteFont,
      ),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 68.0),
              titlePadding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 4.0),
              title: Center(
                child: Text(
                  '活動地域を選択してください。\n（複数選択可）',
                  style: blackBoldFont,
                  textAlign: TextAlign.left,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 4.0),
              content: SizedBox(
                height: 168,
                width: 212,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return AreaList(
                      areas: newAreas,
                      onAreasChanged: (Map<String, bool> areas) {
                        setState(
                          () {
                            newAreas = areas;
                            modifiedAreas = Map.from(newAreas);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(height: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          side: const BorderSide(color: Colors.black),
                          backgroundColor: Colors.white,
                          fixedSize: const Size(88, 20),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              if (newAreas != areas) {
                                newAreas = Map.from(areas);
                                modifiedAreas = Map.from(areas);
                              } else {
                                areas = Map.from(newAreas);
                              }
                            },
                          );
                          context.pop();
                        },
                        child: Center(
                          child: Text(
                            'キャンセル',
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                            style: blackFont,
                            softWrap: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(height: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 0, 0, 1.0),
                          fixedSize: const Size(80, 20),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          setState(() {
                            areas = Map.from(newAreas);
                          });
                          widget.onAreasChanged(modifiedAreas);
                          context.pop();
                        },
                        child: Text(
                          '変更',
                          style: whiteFont,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
