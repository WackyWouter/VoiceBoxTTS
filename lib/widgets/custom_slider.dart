import 'package:flutter/material.dart';
import 'package:voiceboxtts/constants.dart' as constants;

class CustomSlider extends StatelessWidget {
  final double value;
  final void Function(double) onChanged;
  final String label;
  final double min;
  final double max;
  final int divisions;

  const CustomSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: constants.textStyle,
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                onChanged: onChanged,
                min: min,
                max: max,
                divisions: divisions,
                label: label + ': ' + value.toString(),
                activeColor: constants.primary,
              ),
            ),
            Text(
              value.toString(),
              style: constants.textStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
