import 'package:flutter/material.dart';

class CreateUnitFab extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateUnitFab({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
