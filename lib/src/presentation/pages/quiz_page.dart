import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_state.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_progress_bar.dart';
import 'package:dictionarydox/src/presentation/widgets/image_shimmer.dart';
import 'package:dictionarydox/src/presentation/widgets/letter_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

class QuizPage extends StatefulWidget {
  final String unitId;
  final QuizType quizType;

  const QuizPage({
    super.key,
    required this.unitId,
    required this.quizType,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _audioPlayer = AudioPlayer();
  final _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage('en-US');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuizBloc>()
        ..add(StartQuizEvent(unitId: widget.unitId, quizType: widget.quizType)),
      child: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizCompleted) {
            _showCompletionDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state is QuizLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is QuizError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Quiz')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is QuizInProgress) {
            return Scaffold(
              appBar: AppBar(
                title: Text(_getQuizTitle(state.quizType)),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DdProgressBar(
                        current: state.currentQuestionIndex + 1,
                        total: state.totalQuestions,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: _buildQuizContent(context, state),
                      ),
                      if (state.isCorrect != null) ...[
                        const SizedBox(height: 16),
                        _buildFeedback(state.isCorrect!),
                      ],
                      const SizedBox(height: 16),
                      if (state.isCorrect == null)
                        DdButton.primary(
                          text: 'Check Answer',
                          onPressed: _canCheckAnswer(state)
                              ? () => context
                                  .read<QuizBloc>()
                                  .add(CheckAnswerEvent())
                              : null,
                        )
                      else
                        DdButton.primary(
                          text: 'Next Question',
                          onPressed: () =>
                              context.read<QuizBloc>().add(NextQuestionEvent()),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, QuizInProgress state) {
    if (state.quizType == QuizType.image) {
      return _buildImageQuiz(context, state);
    } else if (state.quizType == QuizType.listening) {
      return _buildListeningQuiz(context, state);
    } else {
      return _buildTranslationQuiz(context, state);
    }
  }

  Widget _buildTranslationQuiz(BuildContext context, QuizInProgress state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Build the English word:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Text(
          state.currentWord.uzbek,
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildLetterBoard(context, state),
        const SizedBox(height: 24),
        _buildLetterGrid(context, state),
      ],
    );
  }

  Widget _buildListeningQuiz(BuildContext context, QuizInProgress state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Listen and build the word:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () => _playWordPronunciation(state.currentWord),
          icon: const Icon(Icons.volume_up, size: 48),
          label: const Text('Play'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(32),
          ),
        ),
        const SizedBox(height: 32),
        _buildLetterBoard(context, state),
        const SizedBox(height: 24),
        _buildLetterGrid(context, state),
      ],
    );
  }

  Widget _buildImageQuiz(BuildContext context, QuizInProgress state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.currentWord.english,
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.imageOptions?.length ?? 0,
            itemBuilder: (context, index) {
              final imageUrl = state.imageOptions![index];
              final isSelected = state.selectedImageIndex == index;
              final isCorrectAnswer = state.correctImageIndex == index;

              // Determine border color based on state
              Color borderColor = Colors.transparent;
              if (state.isCorrect != null) {
                // Answer has been checked
                if (isCorrectAnswer) {
                  borderColor = Colors.green;
                } else if (isSelected && !isCorrectAnswer) {
                  borderColor = Colors.red;
                }
              } else if (isSelected) {
                // Not checked yet, just show selection
                borderColor = Theme.of(context).primaryColor;
              }

              return GestureDetector(
                onTap: state.isCorrect == null
                    ? () => context
                        .read<QuizBloc>()
                        .add(SelectImageOptionEvent(index))
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor,
                      width: 4,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ImageShimmer(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLetterBoard(BuildContext context, QuizInProgress state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: state.selectedLetters.isEmpty
            ? [
                Text(
                  'Tap letters below',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ]
            : state.selectedLetters
                .asMap()
                .entries
                .map(
                  (entry) => GestureDetector(
                    onTap: () => context
                        .read<QuizBloc>()
                        .add(RemoveLetterEvent(entry.key)),
                    child: LetterTile(letter: entry.value),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildLetterGrid(BuildContext context, QuizInProgress state) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: state.availableLetters
          .asMap()
          .entries
          .map(
            (entry) => LetterTile(
              letter: entry.value,
              onTap: () => context.read<QuizBloc>().add(
                    SelectLetterEvent(letter: entry.value, index: entry.key),
                  ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFeedback(bool isCorrect) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 12),
          Text(
            isCorrect ? 'Correct!' : 'Incorrect. Try again!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
        ],
      ),
    );
  }

  String _getQuizTitle(QuizType quizType) {
    switch (quizType) {
      case QuizType.translation:
        return 'Translation Quiz';
      case QuizType.image:
        return 'Image Quiz';
      case QuizType.listening:
        return 'Listening Quiz';
    }
  }

  bool _canCheckAnswer(QuizInProgress state) {
    if (state.quizType == QuizType.image) {
      return state.selectedImageIndex != null;
    } else {
      return state.selectedLetters.isNotEmpty;
    }
  }

  Future<void> _playWordPronunciation(dynamic word) async {
    if (word.audioUrl != null) {
      try {
        await _audioPlayer.play(UrlSource(word.audioUrl));
      } catch (e) {
        await _flutterTts.speak(word.english);
      }
    } else {
      await _flutterTts.speak(word.english);
    }
  }

  void _showCompletionDialog(BuildContext context, QuizCompleted state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Quiz Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Score: ${state.finalScore}/${state.totalQuestions}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${((state.finalScore / state.totalQuestions) * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
