import 'package:flutter/material.dart';

/// Kurucu Apple iOS Liquid Glass renk sistemi ve paletleri.
abstract final class AppColors {
  // Aydınlık Tema Paleti (Liquid Crystal White)
  static const Color lightBackground = Color(0xFFF1F5F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightAccent = Color(0xFF2563EB); // Safir Mavi
  static const Color lightSuccess = Color(0xFF059669); // Zümrüt Yeşili
  static const Color lightWarning = Color(0xFFD97706);
  static const Color lightError = Color(0xFFDC2626);

  // Koyu Tema Paleti (Obsidian Liquid Glass)
  static const Color darkBackground = Color(0xFF070A12);
  static const Color darkSurface = Color(0xFF131B2E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // Net Beyaz
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Yüksek Kontrastlı Açık Gri
  static const Color darkAccent = Color(0xFF38BDF8); // Elektrik Azure / Buzul Cam Mavisi
  static const Color darkSuccess = Color(0xFF10B981); // Neon Zümrüt
  static const Color darkWarning = Color(0xFFF59E0B);
  static const Color darkError = Color(0xFFEF4444);

  // Yatırımcı Portalı & Deal Flow Vurgusu (Mor yerine Apple Okyanus Azure & Safir Tonları)
  static const Color investorAccent = Color(0xFF0284C7); // Okyanus Camgöbeği (Apple Cyan)
  static const Color investorAccentLight = Color(0xFF38BDF8); // Işıltılı Azure Mavi

  // Liquid Glass Parlama ve Işık Kırılma Sabitleri
  static const Color glassHighlight = Color(0x66FFFFFF);
  static const Color glassBorderLight = Color(0xB3FFFFFF);
  static const Color glassBorderDark = Color(0x47FFFFFF); // %28 Net Beyaz Cam Kenarlık

  // Soft Ambient Mesh Gradyan Tonları
  static const Color ambientIndigo = Color(0xFF3730A3);
  static const Color ambientBlue = Color(0xFF1E40AF);
  static const Color ambientCyan = Color(0xFF0284C7);
  static const Color ambientAzure = Color(0xFF0284C7);
  static const Color ambientEmerald = Color(0xFF047857);
}
