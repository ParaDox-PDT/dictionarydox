import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmButton extends StatelessWidget {
  final String? selectedImage;

  const ConfirmButton({
    super.key,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DdButton.primary(
        text: 'Confirm Selection',
        onPressed:
            selectedImage != null ? () => context.pop(selectedImage) : null,
      ),
    );
  }
}
