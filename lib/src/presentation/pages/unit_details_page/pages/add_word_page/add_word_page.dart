import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_state.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/add_word_page/mixin/add_word_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/add_word_page/widgets/english_word_field.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/add_word_page/widgets/example_sentence_field.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/add_word_page/widgets/save_word_button.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/add_word_page/widgets/translation_fields.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/add_word_page/widgets/validation_section.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddWordPage extends StatefulWidget {
  final String unitId;

  const AddWordPage({super.key, required this.unitId});

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> with AddWordMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddWordBloc>(),
      child: Builder(
        builder: (context) => BlocListener<AddWordBloc, AddWordState>(
          listener: (context, state) {
            if (state is AddWordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Word added successfully!')),
              );
              context.pop();
            } else if (state is AddWordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add Word'),
            ),
            body: ResponsiveWrapper(
              maxWidth: 800,
              child: SingleChildScrollView(
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EnglishWordField(controller: englishController),
                      const SizedBox(height: 16),
                      DdButton.secondary(
                        text: 'Validate Word',
                        onPressed: () => validateWord(context),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AddWordBloc, AddWordState>(
                        builder: (context, state) {
                          return ValidationSection(
                            unitId: widget.unitId,
                            englishWord: englishController.text.trim(),
                            hasValidated: hasValidated,
                            onSpeakWord: () =>
                                speakWord(englishController.text.trim()),
                          );
                        },
                      ),
                      ExampleSentenceField(controller: exampleController),
                      const SizedBox(height: 24),
                      TranslationFields(
                        uzbekController: uzbekController,
                        descriptionController: descriptionController,
                      ),
                      const SizedBox(height: 32),
                      SaveWordButton(
                        formKey: formKey,
                        englishController: englishController,
                        uzbekController: uzbekController,
                        exampleController: exampleController,
                        descriptionController: descriptionController,
                        unitId: widget.unitId,
                        hasValidated: hasValidated,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
