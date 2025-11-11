import 'package:flutter/foundation.dart' show kIsWeb;

import 'platform_utils_stub.dart'
    if (dart.library.io) 'platform_utils_io.dart'
    if (dart.library.html) 'platform_utils_web.dart';

/// Platform utilities for checking current platform
class PlatformUtils {
  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile (iOS or Android)
  static bool get isMobile => getPlatformInfo().isMobile;

  /// Check if running on desktop (Windows, MacOS, or Linux)
  static bool get isDesktop => getPlatformInfo().isDesktop;

  /// Check if running on Android
  static bool get isAndroid => getPlatformInfo().isAndroid;

  /// Check if running on iOS
  static bool get isIOS => getPlatformInfo().isIOS;
}
