import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Material 3 tabanlı koyu ve aydınlık tema yapılandırması.
/// Tüm renk ve metin stilleri merkezi olarak burada tanımlanır.
abstract final class AppTheme {
  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    cardColor: AppColors.darkCard,
    borderColor: AppColors.darkBorder,
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkSecondary,
    tertiary: AppColors.darkTertiary,
    error: AppColors.darkError,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
  );

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    cardColor: AppColors.lightCard,
    borderColor: AppColors.lightBorder,
    primary: AppColors.lightPrimary,
    secondary: AppColors.lightSecondary,
    tertiary: AppColors.lightTertiary,
    error: AppColors.lightError,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color cardColor,
    required Color borderColor,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color error,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: isDark ? AppColors.darkBackground : Colors.white,
      secondary: secondary,
      onSecondary: isDark ? AppColors.darkBackground : Colors.white,
      tertiary: tertiary,
      onTertiary: isDark ? AppColors.darkBackground : Colors.white,
      error: error,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderColor,
      surfaceContainerHighest: cardColor,
    );

    final TextTheme textTheme = _buildTextTheme(textPrimary, textSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.2),
        labelTextStyle: WidgetStatePropertyAll<TextStyle?>(
          textTheme.labelMedium,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: borderColor,
        circularTrackColor: borderColor,
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: primary,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
    );
  }
}
