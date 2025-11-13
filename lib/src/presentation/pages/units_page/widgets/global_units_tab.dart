import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_grid_view.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_list_view.dart';
import 'package:flutter/material.dart';

class GlobalUnitsTab extends StatelessWidget {
  final List<dynamic> units;
  final Function(dynamic unit) onUnitTap;

  const GlobalUnitsTab({
    super.key,
    required this.units,
    required this.onUnitTap,
  });

  @override
  Widget build(BuildContext context) {
    // Filter only global units (units created by admins)
    final globalUnits = units.where((unit) => unit.isGlobal == true).toList();

    if (globalUnits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.public,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No global units available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Global units will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return ResponsiveWrapper(
      child: ResponsiveUtils.isDesktop(context)
          ? UnitGridView(
              units: globalUnits,
              onUnitTap: onUnitTap,
              onUnitDelete: (_) {}, // No delete for global units
            )
          : UnitListView(
              units: globalUnits,
              onUnitTap: onUnitTap,
              onUnitDelete: (_) {}, // No delete for global units
            ),
    );
  }
}
