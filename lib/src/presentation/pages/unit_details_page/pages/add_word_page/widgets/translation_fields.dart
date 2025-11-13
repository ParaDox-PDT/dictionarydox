import 'package:flutter/material.dart';

class TranslationFields extends StatelessWidget {
  final TextEditingController uzbekController;
  final TextEditingController descriptionController;

  const TranslationFields({
    super.key,
    required this.uzbekController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: uzbekController,
          decoration: const InputDecoration(
            labelText: 'Uzbek Translation',
            hintText: 'Enter the Uzbek translation',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter Uzbek translation';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Add additional notes or context',
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
