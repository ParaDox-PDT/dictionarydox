/// Web platform implementation
class PlatformInfo {
  bool get isMobile => false;
  bool get isDesktop => false;
  bool get isAndroid => false;
  bool get isIOS => false;
}

PlatformInfo getPlatformInfo() => PlatformInfo();
