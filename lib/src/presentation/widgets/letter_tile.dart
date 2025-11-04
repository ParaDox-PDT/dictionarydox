import 'package:dictionarydox/src/config/theme.dart';
import 'package:flutter/material.dart';

class LetterTile extends StatelessWidget {
  final String letter;
  final VoidCallback? onTap;
  final bool isSelected;

  const LetterTile({
    super.key,
    required this.letter,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppTheme.primaryColor : AppTheme.cardBackground,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Text(
            letter.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
