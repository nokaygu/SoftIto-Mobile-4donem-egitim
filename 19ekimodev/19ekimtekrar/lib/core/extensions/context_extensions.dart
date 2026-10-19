import 'package:flutter/material.dart';

/// BuildContext üzerinden tema, renk şeması ve metin stillerine
/// hızlı erişim sağlayan yardımcı extension.
extension BuildContextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
