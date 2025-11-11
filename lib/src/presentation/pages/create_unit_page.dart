import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_event.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateUnitPage extends StatefulWidget {
  const CreateUnitPage({super.key});

  @override
  State<CreateUnitPage> createState() => _CreateUnitPageState();
}

class _CreateUnitPageState extends State<CreateUnitPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedIcon;

  final List<String> _iconOptions = [
    '📚',
    '📖',
    '✏️',
    '🎓',
    '🌍',
    '🗣️',
    '💼',
    '🏠',
    '🍕',
    '✈️',
    '🎵',
    '⚽',
    '🎨',
    '💻',
    '🔬',
    '🏥',
    '🚗',
    '📱',
    '⌚',
    '🎮',
    '📷',
    '🎬',
    '🎤',
    '🎸',
    '🎹',
    '🎺',
    '🎻',
    '🏀',
    '🏈',
    '⚾',
    '🎾',
    '🏐',
    '🏓',
    '🏸',
    '🥊',
    '🏊',
    '🚴',
    '🏋️',
    '⛷️',
    '🏂',
    '🧗',
    '🤸',
    '🧘',
    '🛹',
    '🏇',
    '🏆',
    '🥇',
    '🎯',
    '🎲',
    '🎰',
    '🎭',
    '🎪',
    '🖼️',
    '🎼',
    '🎧',
    '📻',
    '📺',
    '📡',
    '🔭',
    '💊',
    '💉',
    '🩺',
    '🩹',
    '🌡️',
    '🧬',
    '🦠',
    '🧫',
    '🔥',
    '💧',
    '🌊',
    '🌪️',
    '⚡',
    '❄️',
    '☀️',
    '🌙',
    '⭐',
    '🌟',
    '✨',
    '💫',
    '🌈',
    '☁️',
    '⛅',
    '🌤️',
    '🌥️',
    '🌦️',
    '⛈️',
    '🍎',
    '🍊',
    '🍋',
    '🍌',
    '🍉',
    '🍇',
    '🍓',
    '🫐',
    '🍒',
    '🍑',
    '🥭',
    '🍍',
    '🥥',
    '🥝',
    '🍅',
    '🥑',
    '🥦',
    '🥬',
    '🥒',
    '🌶️',
    '🫑',
    '🌽',
    '🥕',
    '🫒',
    '🧄',
    '🧅',
    '🥔',
    '🍠',
    '🥐',
    '🥖',
    '🍞',
    '🥨',
    '🥯',
    '🧀',
    '🥚',
    '🍳',
    '🥞',
    '🧇',
    '🥓',
    '🥩',
    '🍗',
    '🍖',
    '🌭',
    '🍔',
    '🍟',
    '🫓',
    '🥙',
    '🌮',
    '🌯',
    '🫔',
    '🥗',
    '🥘',
    '🫕',
    '🍲',
    '🍱',
    '🍘',
    '🍙',
    '🍚',
    '🍛',
    '🍜',
    '🍝',
    '🍢',
    '🍣',
    '🍤',
    '🍥',
    '🥮',
    '🍡',
    '🥟',
    '🥠',
    '🥡',
    '🦀',
    '🦞',
    '🦐',
    '🦑',
    '🍦',
    '🍧',
    '🍨',
    '🍩',
    '🍪',
    '🎂',
    '🍰',
    '🧁',
    '🥧',
    '🍫',
    '🍬',
    '🍭',
    '🍮',
    '🍯',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UnitBloc>(),
      child: BlocListener<UnitBloc, UnitState>(
        listener: (context, state) {
          if (state is UnitsLoaded) {
            context.pop();
          } else if (state is UnitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
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
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
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
                          Text(
                            'Choose an Icon (Optional)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: _iconOptions.map((icon) {
                              final isSelected = _selectedIcon == icon;
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedIcon = isSelected ? null : icon;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  splashColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  highlightColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  child: Ink(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1)
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
                            }).toList(),
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
                          onPressed: state is UnitLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<UnitBloc>().add(
                                          CreateUnitEvent(
                                            name: _nameController.text.trim(),
                                            icon: _selectedIcon,
                                          ),
                                        );
                                  }
                                },
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
