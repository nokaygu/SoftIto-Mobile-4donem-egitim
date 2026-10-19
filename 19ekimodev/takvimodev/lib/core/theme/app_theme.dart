import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Günce uygulaması Material 3 Aydınlık ve Koyu tema yapılandırması.
abstract final class AppTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColors.lightTerracotta,
      onPrimary: AppColors.lightCard,
      secondary: AppColors.lightSage,
      onSecondary: AppColors.lightCard,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightInkPrimary,
      surfaceContainerHighest: AppColors.lightSurface,
      onSurfaceVariant: AppColors.lightInkSecondary,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightInkMuted,
      tertiaryContainer: AppColors.lightHighlight,
      error: AppColors.errorRed,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.lightBackground,
      inkPrimary: AppColors.lightInkPrimary,
      inkSecondary: AppColors.lightInkSecondary,
      borderColor: AppColors.lightBorder,
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.darkAmber,
      onPrimary: AppColors.darkBackground,
      secondary: AppColors.darkLavender,
      onSecondary: AppColors.darkBackground,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkInkPrimary,
      surfaceContainerHighest: AppColors.darkSurface,
      onSurfaceVariant: AppColors.darkInkSecondary,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkInkMuted,
      tertiaryContainer: AppColors.darkHighlight,
      error: AppColors.errorRed,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.darkBackground,
      inkPrimary: AppColors.darkInkPrimary,
      inkSecondary: AppColors.darkInkSecondary,
      borderColor: AppColors.darkBorder,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color inkPrimary,
    required Color inkSecondary,
    required Color borderColor,
  }) {
    final textTheme = _buildTextTheme(inkPrimary, inkSecondary);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      dividerColor: borderColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: inkPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimens.radiusLg,
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppDimens.radiusMd),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: inkPrimary,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: const RoundedRectangleBorder(borderRadius: AppDimens.radiusMd),
          textStyle: textTheme.labelMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: textTheme.bodyLarge?.copyWith(color: inkSecondary),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.5,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.3,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    );
  }
}
