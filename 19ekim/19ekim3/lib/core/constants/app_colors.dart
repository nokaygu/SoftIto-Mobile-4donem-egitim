import 'package:flutter/material.dart';

/// Gece spor salonu paleti: Dark Obsidian & Neon renk sabitleri
abstract final class AppColors {
  // Obsidian Arka Planlar
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF131822);
  static const Color cardSurface = Color(0xFF1A2230);
  static const Color surfaceElevated = Color(0xFF222C3D);

  // Neon Vurgular (Neon Cyan - Su, Neon Lime - Fitness, Neon Coral - Kalori)
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonLime = Color(0xFF39FF14);
  static const Color neonCoral = Color(0xFFFF416C);
  static const Color neonAmber = Color(0xFFFFB300);

  // Kenarlık & Çizgiler
  static const Color borderDark = Color(0xFF2A364A);
  static const Color borderGlow = Color(0x3300E5FF);

  // Metin Renkleri (Koyu Tema)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Aydınlık Mod Renkleri (Gündüz Ferah Spor & Hidrasyon Teması)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderGlow = Color(0x330284C7);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);
  static const Color lightPrimary = Color(0xFF0284C7);
  static const Color lightSecondary = Color(0xFF16A34A);
  static const Color lightTertiary = Color(0xFFEA580C);

  // Gradyanlar
  static const LinearGradient cyanGlowGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF0088FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient limeGlowGradient = LinearGradient(
    colors: [Color(0xFF39FF14), Color(0xFF00D26A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient obsidianCardGradient = LinearGradient(
    colors: [Color(0xFF1A2230), Color(0xFF131822)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
