import 'package:flutter/foundation.dart';
import 'app_theme_model.dart';
import 'app_themes.dart';

/// Reaktif tema kontrolcüsü
class ThemeController {
  final ValueNotifier<AppThemeModel> currentTheme =
      ValueNotifier<AppThemeModel>(AppThemes.crimsonNeon);

  AppThemeModel get theme => currentTheme.value;
  int get themeId => currentTheme.value.id;

  void setTheme(int id) {
    currentTheme.value = AppThemes.getById(id);
  }
}
