import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_event.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_state.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveWordButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController englishController;
  final TextEditingController uzbekController;
  final TextEditingController exampleController;
  final TextEditingController descriptionController;
  final String unitId;
  final bool hasValidated;

  const SaveWordButton({
    super.key,
    required this.formKey,
    required this.englishController,
    required this.uzbekController,
    required this.exampleController,
    required this.descriptionController,
    required this.unitId,
    required this.hasValidated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWordBloc, AddWordState>(
      builder: (context, state) {
        return DdButton.primary(
          text: 'Save Word',
          isLoading: state is AddWordSaving,
          onPressed: (state is AddWordValidated && hasValidated)
              ? () {
                  if (formKey.currentState!.validate()) {
                    context.read<AddWordBloc>().add(
                          SaveWordEvent(
                            english: englishController.text.trim(),
                            uzbek: uzbekController.text.trim(),
                            example: exampleController.text.isNotEmpty
                                ? exampleController.text.trim()
                                : null,
                            description: descriptionController.text.isNotEmpty
                                ? descriptionController.text.trim()
                                : null,
                            unitId: unitId,
                          ),
                        );
                  }
                }
              : null,
        );
      },
    );
  }
}
