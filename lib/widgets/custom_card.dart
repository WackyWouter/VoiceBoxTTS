import 'package:flutter/material.dart';
import 'package:voiceboxtts/constants.dart' as constants;

class CustomCard extends StatelessWidget {
  final Widget child;
  final double botPadding;

  const CustomCard({Key? key, required this.child, this.botPadding = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, botPadding),
        child: SizedBox(
          width: double.maxFinite,
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(constants.borderRadius),
              ),
              child: child),
        ));
  }
}
