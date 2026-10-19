import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan merkezi renk sabitleri.
/// Koyu Tema: Gece spor salonu paleti (Dark Obsidian & Neon).
/// Aydınlık Tema: Gündüz ferah spor & hidrasyon paleti (Temiz Beyaz & Canlı Neon).
abstract final class AppColors {
  // Koyu Tema (Dark Obsidian & Neon)
  static const Color darkBackground = Color(0xFF0A0E14);
  static const Color darkSurface = Color(0xFF121824);
  static const Color darkCard = Color(0xFF1A2232);
  static const Color darkBorder = Color(0xFF263248);
  static const Color darkPrimary = Color(0xFF00E5FF); // Neon Mavi (Hidrasyon)
  static const Color darkSecondary = Color(0xFF00E676); // Neon Yeşil (Egzersiz)
  static const Color darkTertiary = Color(0xFFFF9100); // Neon Turuncu (Kalori)
  static const Color darkError = Color(0xFFFF5252);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Aydınlık Tema (Ferah Spor & Hidrasyon)
  static const Color lightBackground = Color(0xFFF4F8FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightPrimary = Color(0xFF0091EA); // Canlı Mavi
  static const Color lightSecondary = Color(0xFF00C853); // Canlı Yeşil
  static const Color lightTertiary = Color(0xFFFF6D00); // Canlı Turuncu
  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
}
