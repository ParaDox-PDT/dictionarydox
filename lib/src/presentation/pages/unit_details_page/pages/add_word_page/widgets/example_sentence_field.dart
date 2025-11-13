import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExampleSentenceField extends StatelessWidget {
  final TextEditingController controller;

  const ExampleSentenceField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWordBloc, AddWordState>(
      builder: (context, state) {
        if (state is AddWordValidated && state.includeExample) {
          return Column(
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Example Sentence',
                  hintText: 'Enter an example sentence',
                ),
                maxLines: 3,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
