import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_event.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Mixin containing all business logic for HomePage
mixin HomeMixin<T extends StatefulWidget> on State<T> {
  late final UnitBloc unitBloc;

  @override
  void initState() {
    super.initState();
    unitBloc = sl<UnitBloc>()..add(LoadUnitsEvent());
  }

  @override
  void dispose() {
    unitBloc.close();
    super.dispose();
  }

  /// Refresh units list
  void refreshUnits() {
    unitBloc.add(LoadUnitsEvent());
  }

  /// Navigate to create unit page
  Future<void> navigateToCreateUnit() async {
    await context.push('/create-unit');
    refreshUnits();
  }

  /// Navigate to unit details page
  Future<void> navigateToUnitDetails(dynamic unit) async {
    await context.push('/unit/${unit.id}', extra: unit);
    refreshUnits();
  }

  /// Show delete confirmation dialog
  void showDeleteDialog(dynamic unit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Unit'),
        content: Text(
          'Are you sure you want to delete "${unit.name}"? All words in this unit will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              unitBloc.add(DeleteUnitEvent(unit.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
