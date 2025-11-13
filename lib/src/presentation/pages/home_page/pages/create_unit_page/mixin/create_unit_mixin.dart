import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_event.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Mixin containing all business logic for CreateUnitPage
mixin CreateUnitMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? selectedIcon;

  late final UnitBloc unitBloc;

  @override
  void initState() {
    super.initState();
    unitBloc = sl<UnitBloc>();
  }

  @override
  void dispose() {
    nameController.dispose();
    unitBloc.close();
    super.dispose();
  }

  /// Handle icon selection
  void handleIconSelection(String? icon) {
    setState(() {
      selectedIcon = icon;
    });
  }

  /// Handle form submission
  void handleCreateUnit() {
    if (formKey.currentState!.validate()) {
      unitBloc.add(
        CreateUnitEvent(
          name: nameController.text.trim(),
          icon: selectedIcon,
        ),
      );
    }
  }

  /// Handle navigation back on success
  void handleSuccess() {
    context.pop();
  }

  /// Handle error display
  void handleError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Listen to bloc state changes
  void handleBlocListener(BuildContext context, UnitState state) {
    if (state is UnitsLoaded) {
      handleSuccess();
    } else if (state is UnitError) {
      handleError(state.message);
    }
  }
}
