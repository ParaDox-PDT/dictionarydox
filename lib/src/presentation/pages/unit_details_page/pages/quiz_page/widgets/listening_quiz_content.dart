import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_state.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/letter_board.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/widgets/letter_grid.dart';
import 'package:flutter/material.dart';

class ListeningQuizContent extends StatelessWidget {
  final QuizInProgress state;
  final VoidCallback onPlay;

  const ListeningQuizContent({
    super.key,
    required this.state,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Listen and build the word:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: onPlay,
          icon: const Icon(Icons.volume_up, size: 48),
          label: const Text('Play'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(32),
          ),
        ),
        const SizedBox(height: 32),
        LetterBoard(state: state),
        const SizedBox(height: 24),
        LetterGrid(state: state),
      ],
    );
  }
}
