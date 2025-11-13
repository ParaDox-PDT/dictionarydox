import 'package:flutter/material.dart';

import 'animated_app_icon.dart';
import 'app_branding.dart';
import 'loading_indicator.dart';

class SplashContent extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const SplashContent({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedAppIcon(),
            SizedBox(height: 32),
            AppBranding(),
            SizedBox(height: 48),
            LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
