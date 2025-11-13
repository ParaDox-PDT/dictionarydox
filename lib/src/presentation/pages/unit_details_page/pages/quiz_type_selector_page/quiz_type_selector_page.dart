import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_card.dart';
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
            DdCard(
              onTap: () => context.push(
                '/unit/$unitId/quiz',
                extra: QuizType.translation,
              ),
              child: Column(
                children: [
                  const Icon(Icons.translate, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Translation Quiz',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Build the English word from letters',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DdCard(
              onTap: () => context.push(
                '/unit/$unitId/quiz',
                extra: QuizType.image,
              ),
              child: Column(
                children: [
                  const Icon(Icons.image, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Image Quiz',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Match the word to the correct image',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DdCard(
              onTap: () => context.push(
                '/unit/$unitId/quiz',
                extra: QuizType.listening,
              ),
              child: Column(
                children: [
                  const Icon(Icons.hearing, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Listening Quiz',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Listen and build the word from letters',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
