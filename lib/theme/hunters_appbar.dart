import 'package:flutter/material.dart';

class HuntersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HuntersAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: const ImageIcon(
      //   AssetImage(''),
      //   size: 5,
      // ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      backgroundColor: const Color.fromRGBO(22, 106, 30, 1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
