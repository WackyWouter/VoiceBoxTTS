import 'package:flutter/material.dart';
import 'package:voiceboxtts/constants.dart' as constants;

class CustomCard extends StatelessWidget {
  final Widget child;

  const CustomCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
