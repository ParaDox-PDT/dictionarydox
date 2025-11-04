import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_event.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_card.dart';
import 'package:dictionarydox/src/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UnitBloc _unitBloc;

  @override
  void initState() {
    super.initState();
    _unitBloc = sl<UnitBloc>()..add(LoadUnitsEvent());
  }

  @override
  void dispose() {
    _unitBloc.close();
    super.dispose();
  }

  void _refreshUnits() {
    _unitBloc.add(LoadUnitsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _unitBloc,
      child: HomeView(onRefresh: _refreshUnits),
    );
  }
}

class HomeView extends StatelessWidget {
  final VoidCallback onRefresh;

  const HomeView({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DictionaryDox'),
      ),
      body: BlocBuilder<UnitBloc, UnitState>(
        builder: (context, state) {
          if (state is UnitLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UnitError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UnitBloc>().add(LoadUnitsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is UnitsLoaded) {
            if (state.units.isEmpty) {
              return EmptyState(
                icon: Icons.folder_open,
                title: 'No Units Yet',
                message: 'Create your first unit to start learning vocabulary',
                action: ElevatedButton(
                  onPressed: () async {
                    await context.push('/create-unit');
                    onRefresh();
                  },
                  child: const Text('Create Unit'),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.units.length,
              itemBuilder: (context, index) {
                final unit = state.units[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Slidable(
                    key: ValueKey(unit.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Delete Unit'),
                                content: Text(
                                    'Are you sure you want to delete "${unit.name}"? All words in this unit will be deleted.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      context.read<UnitBloc>().add(
                                            DeleteUnitEvent(unit.id),
                                          );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: DdCard(
                      onTap: () async {
                        await context.push('/unit/${unit.id}', extra: unit);
                        onRefresh();
                      },
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
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/create-unit');
          onRefresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
