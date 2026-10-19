import 'package:flutter/material.dart';

/// Uygulamanın tema durumunu (Açık / Koyu) `ValueNotifier` ile reaktif yöneten kontrolcü.
class ThemeController {
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }

  void dispose() {
    themeMode.dispose();
  }
}
