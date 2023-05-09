import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

// * use one or the other below
// extension PatformExt on Platform {
//   bool get isDesktopOS =>
//       Platform.isMacOS || Platform.isLinux || Platform.isWindows;

//   bool get isMobile => !kIsWeb && Platform.isAndroid || !kIsWeb && Platform.isIOS;

//   bool get isAppOS => Platform.isMacOS || Platform.isAndroid;

//   bool get isWeb => kIsWeb;

//   bool get isDesktopOrWeb => isWeb || isDesktopOS;
// }

class PlatformInfo {
  bool isDesktopOS() =>
      Platform.isMacOS || Platform.isLinux || Platform.isWindows;

  bool isAppOS() => Platform.isMacOS || Platform.isAndroid;

  bool isMobile() => Platform.isIOS || Platform.isAndroid;

  bool isWeb() => kIsWeb;

  bool isDesktopOrWeb() => isWeb() || isDesktopOS();

  PlatformType getCurrentPlatformType() {
    if (kIsWeb) {
      return PlatformType.web;
    }
    if (Platform.isMacOS) {
      return PlatformType.macOS;
    }
    if (Platform.isFuchsia) {
      return PlatformType.fuchsia;
    }
    if (Platform.isLinux) {
      return PlatformType.linux;
    }
    if (Platform.isWindows) {
      return PlatformType.windows;
    }
    if (Platform.isIOS) {
      return PlatformType.iOS;
    }
    if (Platform.isAndroid) {
      return PlatformType.android;
    }
    return PlatformType.unknown;
  }
}

enum PlatformType { web, iOS, android, macOS, fuchsia, linux, windows, unknown }
