import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:dictionarydox/src/presentation/pages/units_page/mixin/units_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/units_page/widgets/global_units_tab.dart';
import 'package:dictionarydox/src/presentation/pages/units_page/widgets/my_units_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});

  @override
  State<UnitsPage> createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage>
    with UnitsMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitBloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<UnitBloc, UnitState>(
            builder: (context, state) {
              if (state is UnitLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UnitError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (state is UnitsLoaded) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey[700],
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        dividerColor: Colors.transparent,
                        padding: const EdgeInsets.all(4),
                        tabs: const [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_outlined, size: 20),
                                SizedBox(width: 8),
                                Text('My Units'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.public, size: 20),
                                SizedBox(width: 8),
                                Text('Global Units'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          MyUnitsTab(
                            units: state.units,
                            onUnitTap: navigateToUnitDetails,
                            onUnitDelete: showDeleteDialog,
                            onCreateUnit: navigateToCreateUnit,
                          ),
                          GlobalUnitsTab(
                            onUnitTap: navigateToUnitDetails,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
