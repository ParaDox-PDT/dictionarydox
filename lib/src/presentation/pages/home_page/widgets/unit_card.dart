import 'package:dictionarydox/src/presentation/widgets/dd_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UnitCard extends StatelessWidget {
  final dynamic unit;
  final bool enableSwipe;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const UnitCard({
    super.key,
    required this.unit,
    required this.enableSwipe,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = DdCard(
      onTap: onTap,
      child: Row(
        children: [
          if (unit.icon != null)
            Text(
              unit.icon!,
              style: const TextStyle(fontSize: 32),
            )
          else
            const Icon(Icons.folder, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '${unit.wordCount} words',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );

    if (!enableSwipe) {
      return InkWell(
        onLongPress: onDelete,
        child: cardContent,
      );
    }

    return Slidable(
      key: ValueKey(unit.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: cardContent,
    );
  }
}
