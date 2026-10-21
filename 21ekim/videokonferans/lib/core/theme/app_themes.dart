import 'package:flutter/material.dart';
import 'app_theme_model.dart';

/// VizyonMeet 4 Kapsamlı Tema Tanımları
class AppThemes {
  AppThemes._();

  /// Tema 1: Crimson Cyber Neon (Varsayılan)
  static const AppThemeModel crimsonNeon = AppThemeModel(
    id: 0,
    nameTr: 'Kırmızı - Siyah Neon',
    nameEn: 'Crimson Cyber Neon',
    icon: Icons.bolt_rounded,
    isDark: true,
    background: Color(0xFF08090C),
    surface: Color(0xFF12141C),
    card: Color(0xFF1A1D28),
    primary: Color(0xFFFF1E42),
    secondary: Color(0xFFFF5E7E),
    fail: Color(0xFFD90429),
    success: Color(0xFF00F5D4),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
  );

  /// Tema 2: Solarized Light (Orijinal Solarized Açık Palet)
  static const AppThemeModel solarizedLight = AppThemeModel(
    id: 1,
    nameTr: 'Solarized Açık',
    nameEn: 'Solarized Light',
    icon: Icons.wb_sunny_rounded,
    isDark: false,
    background: Color(0xFFFDF6E3),
    surface: Color(0xFFEEE8D5),
    card: Color(0xFFF7F0DC),
    primary: Color(0xFF268BD2),
    secondary: Color(0xFF2AA198),
    fail: Color(0xFFDC322F),
    success: Color(0xFF859900),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF334155),
  );

  /// Tema 3: Nordic Aurora Dark (Kuzey Işıkları Gece Paleti)
  static const AppThemeModel nordicAurora = AppThemeModel(
    id: 2,
    nameTr: 'Nordik Kutup Işıkları',
    nameEn: 'Nordic Aurora Dark',
    icon: Icons.nights_stay_rounded,
    isDark: true,
    background: Color(0xFF242933),
    surface: Color(0xFF2E3440),
    card: Color(0xFF3B4252),
    primary: Color(0xFF88C0D0),
    secondary: Color(0xFF81A1C1),
    fail: Color(0xFFBF616A),
    success: Color(0xFFA3BE8C),
    textPrimary: Color(0xFFECEFF4),
    textSecondary: Color(0xFFD8DEE9),
  );

  /// Tema 4: Emerald Matrix (Zümrüt Okyanus Paleti)
  static const AppThemeModel emeraldMatrix = AppThemeModel(
    id: 3,
    nameTr: 'Zümrüt Matris',
    nameEn: 'Emerald Matrix',
    icon: Icons.diamond_rounded,
    isDark: true,
    background: Color(0xFF061316),
    surface: Color(0xFF0B2025),
    card: Color(0xFF112E36),
    primary: Color(0xFF10B981),
    secondary: Color(0xFF06B6D4),
    fail: Color(0xFFF43F5E),
    success: Color(0xFF34D399),
    textPrimary: Color(0xFFF0FDF4),
    textSecondary: Color(0xFF99F6E4),
  );

  static const List<AppThemeModel> allThemes = [
    crimsonNeon,
    solarizedLight,
    nordicAurora,
    emeraldMatrix,
  ];

  static AppThemeModel getById(int id) {
    if (id < 0 || id >= allThemes.length) {
      return crimsonNeon;
    }
    return allThemes[id];
  }
}
