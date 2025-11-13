import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_event.dart';
import 'package:dictionarydox/src/presentation/blocs/add_word/add_word_state.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_banner.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_checkbox_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ValidationSection extends StatelessWidget {
  final String unitId;
  final bool hasValidated;
  final VoidCallback onPlayPronunciation;
  final VoidCallback onSpeakWord;

  const ValidationSection({
    super.key,
    required this.unitId,
    required this.hasValidated,
    required this.onPlayPronunciation,
    required this.onSpeakWord,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWordBloc, AddWordState>(
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: state.audioUrl != null
                          ? onPlayPronunciation
                          : onSpeakWord,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              DdCheckboxRow(
                label: 'Include pronunciation',
                value: state.includePronunciation,
                enabled: state.isValid &&
                    (state.phonetic != null || state.audioUrl != null),
                onChanged: (value) {
                  context.read<AddWordBloc>().add(
                        TogglePronunciationEvent(value ?? false),
                      );
                },
              ),
              if (state.isValid) ...[
                DdButton.secondary(
                  text: state.selectedImageUrl == null
                      ? 'Add Image (Optional)'
                      : 'Change Image',
                  icon: Icons.image_search,
                  onPressed: () => _navigateToImageSearch(context, state),
                ),
                if (state.selectedImageUrl != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Image selected',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
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
                  context.read<AddWordBloc>().add(
                        ToggleExampleEvent(value ?? false),
                      );
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        }

        if (hasValidated && state is AddWordInitial) {
          return const SizedBox();
        }

        return const SizedBox();
      },
    );
  }

  Future<void> _navigateToImageSearch(
    BuildContext context,
    AddWordValidated state,
  ) async {
    final result = await context.push<String>(
      '/unit/$unitId/search-images',
      extra: state.phonetic ?? '',
    );
    if (result != null && context.mounted) {
      context.read<AddWordBloc>().add(SelectImageEvent(result));
    }
  }
}
