import 'package:flutter/material.dart';
import 'package:voiceboxtts/constants.dart' as constants;

class SectionBtn extends StatelessWidget {
  final String name;
  final bool activeSection;
  final void Function() onPressed;

  const SectionBtn(
      {Key? key,
      required this.name,
      required this.activeSection,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: name == 'History'
            ? const BorderRadius.only(
                topLeft: Radius.circular(constants.borderRadius))
            : const BorderRadius.only(
                topRight: Radius.circular(constants.borderRadius)),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: activeSection ? constants.primaryDark : constants.primary,
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              primary: constants.buttonText,
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: onPressed,
            child: Text(name),
          ),
        ),
      ),
    );
  }
}
