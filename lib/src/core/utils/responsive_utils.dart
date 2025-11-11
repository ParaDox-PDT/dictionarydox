import 'package:flutter/material.dart';

/// Responsive utilities for adaptive layouts
class ResponsiveUtils {
  /// Check if screen is mobile (< 600px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Check if screen is tablet (600-900px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  /// Check if screen is desktop (>= 900px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  /// Get maximum content width for the screen
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1200;
    } else if (isTablet(context)) {
      return 800;
    }
    return double.infinity;
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(24);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(20);
    }
    return const EdgeInsets.all(16);
  }

  /// Get number of grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    if (isDesktop(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 2;
    }
    return 1;
  }
}

/// Responsive wrapper widget that centers and constrains content
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? ResponsiveUtils.getMaxContentWidth(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    );
  }
}
