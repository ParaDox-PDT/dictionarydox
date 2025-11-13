import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/pages/create_unit_page/mixin/create_unit_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/pages/create_unit_page/widgets/icon_constants.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/pages/create_unit_page/widgets/icon_selector.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUnitPage extends StatefulWidget {
  const CreateUnitPage({super.key});

  @override
  State<CreateUnitPage> createState() => _CreateUnitPageState();
}

class _CreateUnitPageState extends State<CreateUnitPage> with CreateUnitMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: unitBloc,
      child: BlocListener<UnitBloc, UnitState>(
        listener: handleBlocListener,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Unit'),
          ),
          body: ResponsiveWrapper(
            maxWidth: 800,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: ResponsiveUtils.getResponsivePadding(context),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Unit Name',
                              hintText: 'e.g., Travel Vocabulary',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a unit name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          IconSelector(
                            icons: unitIcons,
                            selectedIcon: selectedIcon,
                            onIconSelected: handleIconSelection,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                // Fixed button at bottom
                Container(
                  width: double.infinity,
                  padding: ResponsiveUtils.getResponsivePadding(context),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: BlocBuilder<UnitBloc, UnitState>(
                      builder: (context, state) {
                        return DdButton.primary(
                          text: 'Create Unit',
                          isLoading: state is UnitLoading,
                          onPressed:
                              state is UnitLoading ? null : handleCreateUnit,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
