import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_type_selector_page/widgets/quiz_type_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizTypeSelectorPage extends StatelessWidget {
  final String unitId;

  const QuizTypeSelectorPage({super.key, required this.unitId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Quiz Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QuizTypeCard(
              icon: Icons.translate,
              title: 'Translation Quiz',
              description: 'Build the English word from letters',
              onTap: () => context.push(
                '/unit/$unitId/quiz',
                extra: QuizType.translation,
              ),
            ),
            const SizedBox(height: 16),
            QuizTypeCard(
              icon: Icons.image,
              title: 'Image Quiz',
              description: 'Match the word to the correct image',
              onTap: () => context.push(
                '/unit/$unitId/quiz',
                extra: QuizType.image,
              ),
            ),
            const SizedBox(height: 16),
            QuizTypeCard(
              icon: Icons.hearing,
              title: 'Listening Quiz',
              description: 'Listen and build the word from letters',
              onTap: () => context.push(
                '/unit/$unitId/quiz',
                extra: QuizType.listening,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
