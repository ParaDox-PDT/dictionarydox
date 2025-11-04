import 'package:audioplayers/audioplayers.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_event.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_state.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_banner.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_checkbox_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

class AddWordPage extends StatefulWidget {
  final String unitId;

  const AddWordPage({super.key, required this.unitId});

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final _formKey = GlobalKey<FormState>();
  final _englishController = TextEditingController();
  final _uzbekController = TextEditingController();
  final _exampleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _audioPlayer = AudioPlayer();
  final _flutterTts = FlutterTts();

  bool _hasValidated = false;

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage('en-US');
  }

  @override
  void dispose() {
    _englishController.dispose();
    _uzbekController.dispose();
    _exampleController.dispose();
    _descriptionController.dispose();
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }

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
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _englishController,
                      decoration: const InputDecoration(
                        labelText: 'English Word',
                        hintText: 'Enter the English word',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an English word';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DdButton.secondary(
                      text: 'Validate Word',
                      onPressed: () {
                        if (_englishController.text.trim().isNotEmpty) {
                          context.read<AddWordBloc>().add(
                                ValidateEnglishWordEvent(
                                    _englishController.text.trim()),
                              );
                          setState(() => _hasValidated = true);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<AddWordBloc, AddWordState>(
                      builder: (context, state) {
                        if (state is AddWordValidating) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is AddWordValidated) {
                          if (!state.isValid) {
                            return Column(
                              children: [
                                DdBanner.error(
                                  'Word not found. You cannot use pronunciation or images for invalid words.',
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state.phonetic != null) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Pronunciation: ${state.phonetic}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ),
                                    if (state.audioUrl != null)
                                      IconButton(
                                        icon: const Icon(Icons.volume_up),
                                        onPressed: () =>
                                            _playPronunciation(state.audioUrl!),
                                      )
                                    else
                                      IconButton(
                                        icon: const Icon(Icons.volume_up),
                                        onPressed: () => _speakWord(
                                            _englishController.text.trim()),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                              DdCheckboxRow(
                                label: 'Include pronunciation',
                                value: state.includePronunciation,
                                enabled: state.isValid &&
                                    (state.phonetic != null ||
                                        state.audioUrl != null),
                                onChanged: (value) {
                                  context.read<AddWordBloc>().add(
                                        TogglePronunciationEvent(
                                            value ?? false),
                                      );
                                },
                              ),
                              if (state.isValid) ...[
                                DdButton.secondary(
                                  text: state.selectedImageUrl == null
                                      ? 'Add Image (Optional)'
                                      : 'Change Image',
                                  icon: Icons.image_search,
                                  onPressed: () async {
                                    final result = await context.push<String>(
                                      '/unit/${widget.unitId}/search-images',
                                      extra: _englishController.text.trim(),
                                    );
                                    if (result != null) {
                                      context
                                          .read<AddWordBloc>()
                                          .add(SelectImageEvent(result));
                                    }
                                  },
                                ),
                                if (state.selectedImageUrl != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Image selected',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ],
                              DdCheckboxRow(
                                label: 'Add example sentence',
                                value: state.includeExample,
                                onChanged: (value) {
                                  context
                                      .read<AddWordBloc>()
                                      .add(ToggleExampleEvent(value ?? false));
                                },
                              ),
                              if (state.includeExample) ...[
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _exampleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Example Sentence',
                                    hintText: 'Enter an example sentence',
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                              const SizedBox(height: 24),
                            ],
                          );
                        }

                        if (_hasValidated && state is AddWordInitial) {
                          return const SizedBox();
                        }

                        return const SizedBox();
                      },
                    ),
                    TextFormField(
                      controller: _uzbekController,
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Add additional notes or context',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<AddWordBloc, AddWordState>(
                      builder: (context, state) {
                        return DdButton.primary(
                          text: 'Save Word',
                          isLoading: state is AddWordSaving,
                          onPressed: (state is AddWordValidated &&
                                  _hasValidated)
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AddWordBloc>().add(
                                          SaveWordEvent(
                                            english:
                                                _englishController.text.trim(),
                                            uzbek: _uzbekController.text.trim(),
                                            example: _exampleController
                                                    .text.isNotEmpty
                                                ? _exampleController.text.trim()
                                                : null,
                                            description: _descriptionController
                                                    .text.isNotEmpty
                                                ? _descriptionController.text
                                                    .trim()
                                                : null,
                                            unitId: widget.unitId,
                                          ),
                                        );
                                  }
                                }
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _playPronunciation(String audioUrl) async {
    try {
      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      _speakWord(_englishController.text.trim());
    }
  }

  Future<void> _speakWord(String word) async {
    await _flutterTts.speak(word);
  }
}
