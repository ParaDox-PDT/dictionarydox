import 'package:dictionarydox/src/core/utils/platform_utils.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:flutter/material.dart';

class UnitDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Unit unit;
  final bool isCarouselView;
  final VoidCallback onToggleView;
  final VoidCallback onQuizPressed;

  const UnitDetailsAppBar({
    super.key,
    required this.unit,
    required this.isCarouselView,
    required this.onToggleView,
    required this.onQuizPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isWeb = PlatformUtils.isWeb;
    
    return AppBar(
      title: Text(unit.name),
      actions: [
        // Web uchun carousel toggle ni olib tashlash
        if (!isWeb)
          IconButton(
            icon: Icon(isCarouselView ? Icons.view_list : Icons.view_carousel),
            onPressed: onToggleView,
          ),
        IconButton(
          icon: const Icon(Icons.quiz),
          onPressed: onQuizPressed,
        ),
      ],
    );
  }
}
