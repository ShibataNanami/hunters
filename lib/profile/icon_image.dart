// dart
import 'dart:io';
import 'package:flutter/material.dart';

// app
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';

///プロフィール編集画面のアイコン設定
class IconImage extends StatefulWidget {
  const IconImage({Key? key}) : super(key: key);

  @override
  IconImageState createState() => IconImageState();
}

class IconImageState extends State<IconImage> {
  File? imageIcon;
  final picker = ImagePicker();

  //端末のアルバムに保存されている画像を取得し、アイコンに設定する処理
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageIcon = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      width: 85,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[600],
        image: imageIcon != null
            ? DecorationImage(
                image: FileImage(imageIcon!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          if (imageIcon == null)
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/com_user_noimage.svg',
                width: 85,
                height: 85,
              ),
            ),
          Positioned(
            top: 59,
            left: 59,
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
        ],
      ),
    );
  }
}
