import 'package:dictionarydox/src/config/theme.dart';
import 'package:flutter/material.dart';

class DdBanner extends StatelessWidget {
  final String text;
  final bool isError;

  const DdBanner({
    super.key,
    required this.text,
    this.isError = true,
  });

  factory DdBanner.error(String text) {
    return DdBanner(text: text, isError: true);
  }

  factory DdBanner.success(String text) {
    return DdBanner(text: text, isError: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isError
            ? AppTheme.errorColor.withOpacity(0.1)
            : AppTheme.accentColor.withOpacity(0.1),
        border: Border(
          left: BorderSide(
            color: isError ? AppTheme.errorColor : AppTheme.accentColor,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? AppTheme.errorColor : AppTheme.accentColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isError ? AppTheme.errorColor : AppTheme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
