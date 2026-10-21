import 'package:flutter/material.dart';

/// VizyonMeet kapsamlı tema renk modeli
class AppThemeModel {
  final int id;
  final String nameTr;
  final String nameEn;
  final IconData icon;
  final bool isDark;
  
  final Color background;
  final Color surface;
  final Color card;
  final Color primary;
  final Color secondary;
  final Color fail;
  final Color success;
  final Color textPrimary;
  final Color textSecondary;

  const AppThemeModel({
    required this.id,
    required this.nameTr,
    required this.nameEn,
    required this.icon,
    required this.isDark,
    required this.background,
    required this.surface,
    required this.card,
    required this.primary,
    required this.secondary,
    required this.fail,
    required this.success,
    required this.textPrimary,
    required this.textSecondary,
  });

  String getName(bool isTurkish) => isTurkish ? nameTr : nameEn;

  ThemeData toThemeData() {
    final brightness = isDark ? Brightness.dark : Brightness.light;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: isDark ? Colors.white : Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        error: fail,
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
      ),
      iconTheme: IconThemeData(color: textPrimary),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: textPrimary),
        labelLarge: TextStyle(color: textPrimary),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textSecondary),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.7)),
        labelStyle: TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }
}
