import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Backend base URL. Override at run time:
/// `flutter run --dart-define=API_BASE_URL=http://192.168.1.4:6000/api/v1`
class ApiConfig {
  ApiConfig._();

  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Freedom Smile backend (PORT=6000).
  ///
  /// Android emulator: use `127.0.0.1` + one-time:
  ///   adb reverse tcp:6000 tcp:6000
  /// (`10.0.2.2` is unreliable on some Windows setups.)
  ///
  /// Physical phone on same Wi‑Fi:
  ///   --dart-define=API_BASE_URL=http://192.168.1.4:6000/api/v1
  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    // Emulator + desktop: localhost (Android needs `adb reverse` above).
    if (!kIsWeb &&
        (Platform.isAndroid ||
            Platform.isIOS ||
            Platform.isWindows ||
            Platform.isMacOS ||
            Platform.isLinux)) {
      // return 'http://127.0.0.1:6000/api/v1';
      return 'http://34.229.165.161:6000/api/v1';
    }
    return 'http://34.229.165.161:6000/api/v1';
    // return 'http://127.0.0.1:6000/api/v1';
  }

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
