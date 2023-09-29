// dart
import 'package:flutter/material.dart';

// third party
import 'package:hunters_app/profile/animal_list.dart';
import 'package:hunters_app/theme/font_style.dart';
import 'package:hunters_app/profile/profile_date_get.dart';

// app
import 'package:go_router/go_router.dart';

///鳥獣区分選択のダイアログの設定
class AnimalSetDialog extends StatefulWidget {
  final Function(Map<String, bool>) onAnimalsChanged;
  const AnimalSetDialog({
    Key? key,
    required this.onAnimalsChanged,
  }) : super(key: key);

  @override
  AnimalSetDialogState createState() => AnimalSetDialogState();
}

class AnimalSetDialogState extends State<AnimalSetDialog> {
  late Map<String, bool> animals;
  late Map<String, bool> modifiedAnimals;
  late Map<String, bool> newAnimals;

  @override
  void initState() {
    super.initState();
    getAnimalsDate().then((value) {
      setState(() {
        animals = value;
        modifiedAnimals = Map.from(animals);
        newAnimals = {
          'bear': animals['bear'] ?? false,
          'boar': animals['boar'] ?? false,
          'deer': animals['deer'] ?? false,
          'duck': animals['duck'] ?? false,
          'otherBirds': animals['otherBirds'] ?? false,
          'others': animals['others'] ?? false,
        };
      });
    });
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
                  '普段から捕獲している鳥獣の種類を\n選択してください。（複数選択可）',
                  style: blackBoldFont,
                  textAlign: TextAlign.center,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 4.0),
              content: SizedBox(
                height: 168,
                width: 212,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return AnimalList(
                      animals: newAnimals,
                      onAnimalsChanged: (Map<String, bool> animals) {
                        setState(
                          () {
                            newAnimals = animals;
                            modifiedAnimals = Map.from(newAnimals);
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
                              newAnimals = Map.from(animals);
                              modifiedAnimals = Map.from(animals);
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
                            softWrap: false, // 折り返さない
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
                            animals = Map.from(newAnimals);
                          });
                          widget.onAnimalsChanged(modifiedAnimals);
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
