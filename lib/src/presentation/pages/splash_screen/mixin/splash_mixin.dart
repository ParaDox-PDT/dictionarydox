import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin SplashMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  void initializeAnimations() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    controller.forward();
  }

  void checkAuthAndNavigate(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final authService = AuthService();
        if (authService.isSignedIn) {
          context.go('/');
        } else {
          context.go('/login');
        }
      }
    });
  }

  void disposeAnimations() {
    controller.dispose();
  }
}
