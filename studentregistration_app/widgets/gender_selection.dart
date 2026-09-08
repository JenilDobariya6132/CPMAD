import 'package:flutter/material.dart';

class GenderSelection extends StatelessWidget {
  final String? gender;
  final Function(String?) onChanged;

  const GenderSelection({
    super.key,
    required this.gender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        RadioGroup<String>(
          groupValue: gender,
          onChanged: (value) => onChanged(value),
          child: Column(
            children: const [
              RadioListTile<String>(title: Text('Male'), value: 'Male'),
              RadioListTile<String>(title: Text('Female'), value: 'Female'),
              RadioListTile<String>(title: Text('Other'), value: 'Other'),
            ],
          ),
        ),
      ],
    );
  }
}
