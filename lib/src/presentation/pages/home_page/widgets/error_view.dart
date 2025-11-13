import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<UnitBloc>().add(LoadUnitsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
