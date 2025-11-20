import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.book,
                size: 80,
                color: Colors.white,
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'DictionaryDox',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Master Vocabulary Effortlessly',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 0.5,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your personal vocabulary trainer with smart learning tools and progress tracking',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
