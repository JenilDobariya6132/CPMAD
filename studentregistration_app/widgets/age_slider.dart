import 'package:flutter/material.dart';

class AgeSlider extends StatelessWidget {
  final double age;
  final Function(double) onChanged;

  const AgeSlider({super.key, required this.age, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age: ${age.round()}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        Slider(
          value: age,
          min: 15,
          max: 60,
          divisions: 45,
          label: age.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
