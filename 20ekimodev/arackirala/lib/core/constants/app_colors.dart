import 'package:flutter/material.dart';

/// Vites platformu renk paleti.
/// Liquid Glass (akışkan buzlu cam) ve Bordo/Karbon Siyahı/Antrasit Gri odaklıdır.
/// Mor renk kesinlikle kullanılmaz.
abstract final class AppColors {
  // Arka Plan Renkleri
  static const Color backgroundDark = Color(0xFF0B0C0E);
  static const Color backgroundSecondary = Color(0xFF16181D);
  static const Color surface = Color(0xFF181A20);
  static const Color surfaceVariant = Color(0xFF262932);

  // Bordo Vurgu Renkleri
  static const Color burgundyPrimary = Color(0xFF8B1E2F);
  static const Color burgundySecondary = Color(0xFF5E111E);
  static const Color burgundyAccent = Color(0xFFB8293D);
  static const Color burgundyLight = Color(0xFFD93850);

  // Kısayol takma ad
  static const Color burgundy = burgundyPrimary;

  // Liquid Glass Buzlu Cam Renkleri
  static const Color glassSurface = Color(0xB31E2028);
  static const Color glassSurfaceHigh = Color(0xD9222630);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassBorderLight = Color(0x4DFFFFFF);

  // Yüksek Kontrastlı Metin Renkleri
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Durum Renkleri
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);

  // Yıldız ve Beğeni Renkleri
  static const Color starActive = Color(0xFFFBBF24);
  static const Color starInactive = Color(0xFF475569);
  static const Color heartActive = Color(0xFFE11D48);
}
