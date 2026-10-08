import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dark status / nav icons for light app backgrounds (time, battery, signal).
abstract final class AppSystemUi {
  static const overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static void apply() {
    SystemChrome.setSystemUIOverlayStyle(overlay);
  }
}
