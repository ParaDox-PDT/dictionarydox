import 'package:flutter/material.dart';

class EnglishWordField extends StatelessWidget {
  final TextEditingController controller;

  const EnglishWordField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'English Word',
        hintText: 'Enter the English word',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an English word';
        }
        return null;
      },
    );
  }
}
