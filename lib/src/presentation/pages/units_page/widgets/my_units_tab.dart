import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_grid_view.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_list_view.dart';
import 'package:dictionarydox/src/presentation/pages/units_page/widgets/empty_my_units_view.dart';
import 'package:flutter/material.dart';

class MyUnitsTab extends StatelessWidget {
  final List<dynamic> units;
  final Function(dynamic unit) onUnitTap;
  final Function(dynamic unit) onUnitDelete;
  final VoidCallback onCreateUnit;

  const MyUnitsTab({
    super.key,
    required this.units,
    required this.onUnitTap,
    required this.onUnitDelete,
    required this.onCreateUnit,
  });

  @override
  Widget build(BuildContext context) {
    // Filter only user's own units (not global)
    final myUnits = units.where((unit) => unit.isGlobal != true).toList();

    if (myUnits.isEmpty) {
      return EmptyMyUnitsView(
        onCreateUnit: onCreateUnit,
      );
    }

    return Stack(
      children: [
        ResponsiveWrapper(
          child: ResponsiveUtils.isDesktop(context)
              ? UnitGridView(
                  units: myUnits,
                  onUnitTap: onUnitTap,
                  onUnitDelete: onUnitDelete,
                )
              : UnitListView(
                  units: myUnits,
                  onUnitTap: onUnitTap,
                  onUnitDelete: onUnitDelete,
                ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: onCreateUnit,
            backgroundColor: Colors.blue,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Create Unit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
