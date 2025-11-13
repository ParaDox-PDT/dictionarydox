import 'package:flutter/material.dart';

class IconSelector extends StatelessWidget {
  final List<String> icons;
  final String? selectedIcon;
  final ValueChanged<String?> onIconSelected;

  const IconSelector({
    super.key,
    required this.icons,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose an Icon (Optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: icons.map((icon) {
            final isSelected = selectedIcon == icon;
            return _IconButton(
              icon: icon,
              isSelected: isSelected,
              onTap: () => onIconSelected(isSelected ? null : icon),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Ink(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              width: isSelected ? 3 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              icon,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
      ),
    );
  }
}
