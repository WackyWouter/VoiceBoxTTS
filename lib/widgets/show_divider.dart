import 'package:flutter/material.dart';
import 'package:voiceboxtts/constants.dart' as constants;

class ShowDivider extends StatelessWidget {
  final bool show;

  const ShowDivider({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (show) {
      return const Divider(
        thickness: 1.5,
        color: constants.divider,
        height: 1.5,
      );
    } else {
      return const SizedBox();
    }
  }
}
