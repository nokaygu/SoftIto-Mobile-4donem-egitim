import 'package:flutter/material.dart';

/// Tema yönetimi ve reaktif geçiş iş mantığı
class ThemeController {
  final ValueNotifier<ThemeMode> themeMode;

  ThemeController([ThemeMode initialMode = ThemeMode.dark])
      : themeMode = ValueNotifier<ThemeMode>(initialMode);

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    if (themeMode.value != mode) {
      themeMode.value = mode;
    }
  }

  void dispose() {
    themeMode.dispose();
  }
}
