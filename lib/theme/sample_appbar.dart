import 'package:flutter/material.dart';

class SampleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final ElevatedButton? actionButton;

  const SampleAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      // leading: const ImageIcon(
      //   AssetImage(''),
      //   size: 5,
      // ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      backgroundColor: const Color(0xFF006400),
      actions: [
        if (actionButton != null) actionButton!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
