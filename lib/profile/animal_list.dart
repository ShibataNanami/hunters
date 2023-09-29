// dart
import 'package:flutter/material.dart';

// third party

// app
import 'package:hunters_app/profile/profile_date_get.dart';
import 'package:hunters_app/theme/font_style.dart';

///鳥獣区分のリスト部分の設定
class AnimalList extends StatefulWidget {
  const AnimalList({
    super.key,
    required this.animals,
    required this.onAnimalsChanged,
  });

  final Map<String, bool> animals;
  final Function(Map<String, bool>) onAnimalsChanged;

  @override
  AnimalListState createState() => AnimalListState();
}

class AnimalListState extends State<AnimalList> {
  Map<String, bool> animals = {};
  Map<String, bool> _animals = {};

  @override
  void initState() {
    super.initState();
    getAnimalsDate().then(
      (value) {
        setState(
          () {
            animals = value;
            _animals = Map.from(widget.animals);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 28.0,
      itemCount: _animals.length,
      itemBuilder: (BuildContext context, int index) {
        String animalName = _animals.keys.elementAt(index);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(
              () {
                _animals[animalName] = !_animals[animalName]!;
                widget.onAnimalsChanged(_animals);
              },
            );
          },
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Center(
                  child: _animals[animalName] == true
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        )
                      : null,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    displayNames[animalName] ?? animalName,
                    style: blackBoldFont,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

///リストの表示名の設定
const Map<String, String> displayNames = {
  'bear': '熊',
  'boar': '猪',
  'deer': '鹿',
  'duck': '鴨',
  'otherBirds': 'その他獣類',
  'others': 'その他鳥類',
};
