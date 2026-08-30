import 'package:flutter/material.dart';

class MarkInput extends StatelessWidget {
  final String subject;
  final TextEditingController controller;

  const MarkInput({
    super.key,
    required this.subject,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: '$subject Marks',
          hintText: 'Enter marks out of 100',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}