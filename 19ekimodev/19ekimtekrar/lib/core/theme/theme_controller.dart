import 'package:flutter/material.dart';

/// Uygulama tema durumunu ValueNotifier ile reaktif olarak yöneten controller.
class ThemeController {
  ThemeController({ThemeMode initialMode = ThemeMode.dark})
    : themeMode = ValueNotifier<ThemeMode>(initialMode);

  final ValueNotifier<ThemeMode> themeMode;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }

  void dispose() {
    themeMode.dispose();
  }
}
