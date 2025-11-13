import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_state.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/mixin/quiz_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/completion_dialog.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/image_quiz_content.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/listening_quiz_content.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/quiz_feedback.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/translation_quiz_content.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _QuizPageState extends State<QuizPage> with QuizMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuizBloc>()
        ..add(StartQuizEvent(unitId: widget.unitId, quizType: widget.quizType)),
      child: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizCompleted) {
            CompletionDialog.show(
              context,
              finalScore: state.finalScore,
              totalQuestions: state.totalQuestions,
            );
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
                title: Text(getQuizTitle(state.quizType)),
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
                        QuizFeedback(isCorrect: state.isCorrect!),
                      ],
                      const SizedBox(height: 16),
                      if (state.isCorrect == null)
                        DdButton.primary(
                          text: 'Check Answer',
                          onPressed: canCheckAnswer(state, state.quizType)
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
      return ImageQuizContent(state: state);
    } else if (state.quizType == QuizType.listening) {
      return ListeningQuizContent(
        state: state,
        onPlay: () => playWordPronunciation(state.currentWord),
      );
    } else {
      return TranslationQuizContent(state: state);
    }
  }
}
