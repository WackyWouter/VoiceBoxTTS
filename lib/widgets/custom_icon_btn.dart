import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voiceboxtts/constants.dart' as constants;

class CustomIconBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final void Function() onTap;

  const CustomIconBtn(
      {Key? key, required this.icon, required this.onTap, this.size = 25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: FaIcon(
          icon,
          color: constants.primary,
          size: size,
        ));
  }
}
