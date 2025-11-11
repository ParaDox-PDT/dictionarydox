import 'dart:io' show Platform;

/// IO platform implementation
class PlatformInfo {
  bool get isMobile => Platform.isAndroid || Platform.isIOS;
  bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  bool get isAndroid => Platform.isAndroid;
  bool get isIOS => Platform.isIOS;
}

PlatformInfo getPlatformInfo() => PlatformInfo();
