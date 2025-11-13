import 'package:dictionarydox/src/core/services/notification_service.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:flutter/material.dart';

/// Provider that handles lazy initialization of services
class InitializationProvider extends InheritedWidget {
  final Future<void> initialization;

  const InitializationProvider({
    super.key,
    required this.initialization,
    required super.child,
  });

  static InitializationProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<InitializationProvider>();
    assert(result != null, 'No InitializationProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InitializationProvider oldWidget) => false;

  /// Initialize all non-critical services in background
  static Future<void> initialize() async {
    // Initialize dependencies
    await initDependencies();

    // Initialize notification service (can be done lazily)
    // Don't await - let it initialize in background
    NotificationService().initialize().catchError((e) {
      debugPrint('NotificationService initialization error: $e');
    });
  }
}
