import 'package:flutter/material.dart';

/// Vites platformu renk paleti.
/// Liquid Glass (akışkan buzlu cam) ve Bordo/Karbon Siyahı/Antrasit Gri odaklıdır.
/// Mor renk kesinlikle kullanılmaz.
abstract final class AppColors {
  // Arka Plan Renkleri (Koyu Tema)
  static const Color backgroundDark = Color(0xFF0B0C0E);
  static const Color backgroundSecondaryDark = Color(0xFF16181D);
  static const Color surfaceDark = Color(0xFF181A20);
  static const Color surfaceVariantDark = Color(0xFF262932);

  // Arka Plan Renkleri (Açık Tema)
  static const Color backgroundLight = Color(0xFFF1F5F9); // Slate-100
  static const Color backgroundSecondaryLight = Color(0xFFE2E8F0); // Slate-200
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF8FAFC);

  // Geriye dönük uyumluluk (Varsayılan Koyu)
  static const Color backgroundSecondary = backgroundSecondaryDark;
  static const Color surface = surfaceDark;
  static const Color surfaceVariant = surfaceVariantDark;

  // Bordo Vurgu Renkleri (Her İki Temada Geçerli Marka Kimliği)
  static const Color burgundyPrimary = Color(0xFF8B1E2F);
  static const Color burgundySecondary = Color(0xFF5E111E);
  static const Color burgundyAccent = Color(0xFFB8293D);
  static const Color burgundyLight = Color(0xFFD93850);

  // Kısayol takma ad
  static const Color burgundy = burgundyPrimary;

  // Liquid Glass Buzlu Cam Renkleri (Koyu Tema)
  static const Color glassSurfaceDark = Color(0xB31E2028);
  static const Color glassSurfaceHighDark = Color(0xD9222630);
  static const Color glassBorderDark = Color(0x33FFFFFF);
  static const Color glassBorderLightDark = Color(0x4DFFFFFF);

  // Liquid Glass Buzlu Cam Renkleri (Açık Tema)
  static const Color glassSurfaceLight = Color(0xEBFFFFFF);
  static const Color glassSurfaceHighLight = Color(0xF5FFFFFF);
  static const Color glassBorderLightMode = Color(0x2E8B1E2F);
  static const Color glassBorderSubtleLight = Color(0x1F0F172A);

  // Geriye dönük uyumluluk
  static const Color glassSurface = glassSurfaceDark;
  static const Color glassSurfaceHigh = glassSurfaceHighDark;
  static const Color glassBorder = glassBorderDark;
  static const Color glassBorderLight = glassBorderLightDark;

  // Yüksek Kontrastlı Metin Renkleri (Koyu Tema)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Yüksek Kontrastlı Metin Renkleri (Açık Tema)
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate-900
  static const Color textSecondaryLight = Color(0xFF334155); // Slate-700
  static const Color textMutedLight = Color(0xFF64748B); // Slate-500

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

/// Tema durumuna göre renkleri dinamik getiren BuildContext eklentisi
extension ThemeHelper on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get scaffoldColor => isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get surfaceColor => isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get surfaceVariantColor =>
      isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight;
  Color get glassSurfaceColor => isDark ? AppColors.glassSurfaceDark : AppColors.glassSurfaceLight;
  Color get glassBorderColor => isDark ? AppColors.glassBorderDark : AppColors.glassBorderLightMode;
  Color get glassBorderSubtleColor =>
      isDark ? AppColors.glassBorderLightDark : AppColors.glassBorderSubtleLight;

  Color get textPrimaryColor => isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
  Color get textSecondaryColor => isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
  Color get textMutedColor => isDark ? AppColors.textMuted : AppColors.textMutedLight;
}
