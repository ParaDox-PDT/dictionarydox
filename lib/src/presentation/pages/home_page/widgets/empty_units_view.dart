import 'package:dictionarydox/src/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';

class EmptyUnitsView extends StatelessWidget {
  final VoidCallback onCreateUnit;

  const EmptyUnitsView({
    super.key,
    required this.onCreateUnit,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.folder_open,
      title: 'No Units Yet',
      message: 'Create your first unit to start learning vocabulary',
      action: ElevatedButton(
        onPressed: onCreateUnit,
        child: const Text('Create Unit'),
      ),
    );
  }
}
