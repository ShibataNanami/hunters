// dart
import 'dart:io';
import 'package:flutter/material.dart';

// app
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';

///プロフィール編集画面のヘッダー設定
class HeaderImage extends StatefulWidget {
  const HeaderImage({Key? key}) : super(key: key);

  @override
  HeaderImageState createState() => HeaderImageState();
  File? get headerImage => HeaderImageState.imageHeader;
}

class HeaderImageState extends State<HeaderImage> {
  final picker = ImagePicker();
  static File? imageHeader;

  //端末のアルバムに保存されている画像を取得し、ヘッダーに設定する処理
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageHeader = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/com_pic_noimage.svg',
                  fit: BoxFit.cover,
                )),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 13),
              child: GestureDetector(
                onTap: getImageFromGallery,
                child: Container(
                  height: 26,
                  width: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                  child: const Icon(
                    Icons.create_outlined,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
