import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/mixin/home_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/create_unit_fab.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/empty_units_view.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/error_view.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/home_app_bar.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_grid_view.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitBloc,
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: BlocBuilder<UnitBloc, UnitState>(
          builder: (context, state) {
            if (state is UnitLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UnitError) {
              return ErrorView(message: state.message);
            }

            if (state is UnitsLoaded) {
              if (state.units.isEmpty) {
                return EmptyUnitsView(
                  onCreateUnit: navigateToCreateUnit,
                );
              }

              return ResponsiveWrapper(
                child: ResponsiveUtils.isDesktop(context)
                    ? UnitGridView(
                        units: state.units,
                        onUnitTap: navigateToUnitDetails,
                        onUnitDelete: showDeleteDialog,
                      )
                    : UnitListView(
                        units: state.units,
                        onUnitTap: navigateToUnitDetails,
                        onUnitDelete: showDeleteDialog,
                      ),
              );
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: CreateUnitFab(
          onPressed: navigateToCreateUnit,
        ),
      ),
    );
  }
}
