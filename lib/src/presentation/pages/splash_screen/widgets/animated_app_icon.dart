import 'package:flutter/material.dart';

class AnimatedAppIcon extends StatelessWidget {
  const AnimatedAppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.book,
        size: 80,
        color: Color(0xFF2196F3),
      ),
    );
  }
}
