import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_state.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/letter_board.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/letter_grid.dart';
import 'package:flutter/material.dart';

class TranslationQuizContent extends StatelessWidget {
  final QuizInProgress state;

  const TranslationQuizContent({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
        LetterBoard(state: state),
        const SizedBox(height: 24),
        LetterGrid(state: state),
      ],
    );
  }
}
