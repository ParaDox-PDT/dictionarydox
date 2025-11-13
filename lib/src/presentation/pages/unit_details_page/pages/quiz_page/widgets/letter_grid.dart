import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_state.dart';
import 'package:dictionarydox/src/presentation/widgets/letter_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LetterGrid extends StatelessWidget {
  final QuizInProgress state;

  const LetterGrid({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
}
