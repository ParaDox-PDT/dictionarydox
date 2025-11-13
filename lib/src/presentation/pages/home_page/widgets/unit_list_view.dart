import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_card.dart';
import 'package:flutter/material.dart';

class UnitListView extends StatelessWidget {
  final List<dynamic> units;
  final Function(dynamic unit) onUnitTap;
  final Function(dynamic unit) onUnitDelete;

  const UnitListView({
    super.key,
    required this.units,
    required this.onUnitTap,
    required this.onUnitDelete,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return ListView.builder(
      padding: padding,
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: UnitCard(
            unit: unit,
            enableSwipe: true,
            onTap: () => onUnitTap(unit),
            onDelete: () => onUnitDelete(unit),
          ),
        );
      },
    );
  }
}
