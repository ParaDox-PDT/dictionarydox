import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_state.dart';
import 'package:dictionarydox/src/presentation/widgets/letter_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LetterBoard extends StatelessWidget {
  final QuizInProgress state;

  const LetterBoard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Next Question bosilgandan keyin readonly qilish
    final isReadOnly = state.isCorrect != null;
    
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
                  (entry) => isReadOnly
                      ? LetterTile(letter: entry.value) // Readonly - o'chirib bo'lmaydi
                      : GestureDetector(
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
}
