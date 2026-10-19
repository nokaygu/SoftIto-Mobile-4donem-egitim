import 'package:flutter/material.dart';

/// Günce uygulaması renk ve tasarım sabitleri.
/// Aydınlık Tema: Sıcak Parşömen / Kırtasiye Paleti
/// Koyu Tema: Gece Mürekkebi Paleti
abstract final class AppColors {
  // --- Aydınlık Tema (Sıcak Parşömen Paleti) ---
  static const Color lightBackground = Color(0xFFFAF8F5);
  static const Color lightSurface = Color(0xFFF3EFEA);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightInkPrimary = Color(0xFF2C2623);
  static const Color lightInkSecondary = Color(0xFF6E655F);
  static const Color lightInkMuted = Color(0xFF9E948C);
  static const Color lightTerracotta = Color(0xFFC86D51);
  static const Color lightSage = Color(0xFF6B8E78);
  static const Color lightBorder = Color(0xFFE5DEC9);
  static const Color lightHighlight = Color(0xFFF7E7DF);

  // --- Koyu Tema (Gece Mürekkebi Paleti) ---
  static const Color darkBackground = Color(0xFF121316);
  static const Color darkSurface = Color(0xFF1B1D22);
  static const Color darkCard = Color(0xFF22252C);
  static const Color darkInkPrimary = Color(0xFFF2EFE9);
  static const Color darkInkSecondary = Color(0xFFA9A49C);
  static const Color darkInkMuted = Color(0xFF6E6A63);
  static const Color darkAmber = Color(0xFFE5A94E);
  static const Color darkLavender = Color(0xFFB39DDB);
  static const Color darkBorder = Color(0xFF2E323B);
  static const Color darkHighlight = Color(0xFF312A22);

  // --- Ortak Durum Renkleri ---
  static const Color errorRed = Color(0xFFC94A4A);
  static const Color transparent = Colors.transparent;
}

/// Widget'larda sabit (hardcoded) değer kullanmamak için stil ve ölçü sabitleri.
abstract final class AppDimens {
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(10));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(14));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(28));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(999));

  static const List<BoxShadow> lightCardShadow = [
    BoxShadow(color: Color(0x0D2C2623), blurRadius: 16, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(color: Color(0x40000000), blurRadius: 16, offset: Offset(0, 6)),
  ];
}
