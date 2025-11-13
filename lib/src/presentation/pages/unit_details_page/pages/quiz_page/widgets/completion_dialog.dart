import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompletionDialog extends StatelessWidget {
  final int finalScore;
  final int totalQuestions;

  const CompletionDialog({
    super.key,
    required this.finalScore,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            'Score: $finalScore/$totalQuestions',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${((finalScore / totalQuestions) * 100).toInt()}%',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required int finalScore,
    required int totalQuestions,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CompletionDialog(
        finalScore: finalScore,
        totalQuestions: totalQuestions,
      ),
    );
  }
}
