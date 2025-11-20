import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_card.dart';
import 'package:flutter/material.dart';

class UnitGridView extends StatelessWidget {
  final List<dynamic> units;
  final Function(dynamic unit) onUnitTap;
  final Function(dynamic unit) onUnitDelete;

  const UnitGridView({
    super.key,
    required this.units,
    required this.onUnitTap,
    required this.onUnitDelete,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.getGridColumns(context),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3, // Reduced from 3 to prevent extra space at bottom
      ),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        return UnitCard(
          unit: unit,
          enableSwipe: false,
          onTap: () => onUnitTap(unit),
          onDelete: () => onUnitDelete(unit),
        );
      },
    );
  }
}
