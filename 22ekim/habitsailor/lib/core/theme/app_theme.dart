import 'package:flutter/material.dart';

class HabitSailorThemeExtension extends ThemeExtension<HabitSailorThemeExtension> {
  final Color babyBlueBg;
  final Color babyBlueFg;
  final Color babyBlueBorder;

  final Color normalBlueBg;
  final Color normalBlueFg;
  final Color normalBlueBorder;

  final Color urgentNavyBg;
  final Color urgentNavyFg;
  final Color urgentNavyBorder;
  final Color deepNavyShadow;

  final Color lightningYellow;
  final Color lightningBannerBg;
  final Color onLightningBanner;

  final Color streakNeonLow;
  final Color streakNeonMid;
  final Color streakNeonHigh;
  final Color onStreakNeon;

  final Color urgentDayBg;
  final Color urgentDayFg;
  final Color normalDayBg;
  final Color normalDayFg;
  final Color selectedDayBorder;

  final Color avatarBadgeBg;
  final Color avatarBadgeBorder;
  final Color avatarIconColor;

  const HabitSailorThemeExtension({
    required this.babyBlueBg,
    required this.babyBlueFg,
    required this.babyBlueBorder,
    required this.normalBlueBg,
    required this.normalBlueFg,
    required this.normalBlueBorder,
    required this.urgentNavyBg,
    required this.urgentNavyFg,
    required this.urgentNavyBorder,
    required this.deepNavyShadow,
    required this.lightningYellow,
    required this.lightningBannerBg,
    required this.onLightningBanner,
    required this.streakNeonLow,
    required this.streakNeonMid,
    required this.streakNeonHigh,
    required this.onStreakNeon,
    required this.urgentDayBg,
    required this.urgentDayFg,
    required this.normalDayBg,
    required this.normalDayFg,
    required this.selectedDayBorder,
    required this.avatarBadgeBg,
    required this.avatarBadgeBorder,
    required this.avatarIconColor,
  });

  Color difficultyBackground(int difficulty) {
    switch (difficulty) {
      case 2:
        return urgentNavyBg;
      case 1:
        return normalBlueBg;
      case 0:
      default:
        return babyBlueBg;
    }
  }

  Color difficultyForeground(int difficulty) {
    switch (difficulty) {
      case 2:
        return urgentNavyFg;
      case 1:
        return normalBlueFg;
      case 0:
      default:
        return babyBlueFg;
    }
  }

  Color difficultyBorder(int difficulty) {
    switch (difficulty) {
      case 2:
        return urgentNavyBorder;
      case 1:
        return normalBlueBorder;
      case 0:
      default:
        return babyBlueBorder;
    }
  }

  Color streakNeonColor(int streak) {
    if (streak < 3) {
      return streakNeonLow;
    } else if (streak < 7) {
      return streakNeonMid;
    } else {
      return streakNeonHigh;
    }
  }

  @override
  ThemeExtension<HabitSailorThemeExtension> copyWith({
    Color? babyBlueBg,
    Color? babyBlueFg,
    Color? babyBlueBorder,
    Color? normalBlueBg,
    Color? normalBlueFg,
    Color? normalBlueBorder,
    Color? urgentNavyBg,
    Color? urgentNavyFg,
    Color? urgentNavyBorder,
    Color? deepNavyShadow,
    Color? lightningYellow,
    Color? lightningBannerBg,
    Color? onLightningBanner,
    Color? streakNeonLow,
    Color? streakNeonMid,
    Color? streakNeonHigh,
    Color? onStreakNeon,
    Color? urgentDayBg,
    Color? urgentDayFg,
    Color? normalDayBg,
    Color? normalDayFg,
    Color? selectedDayBorder,
    Color? avatarBadgeBg,
    Color? avatarBadgeBorder,
    Color? avatarIconColor,
  }) {
    return HabitSailorThemeExtension(
      babyBlueBg: babyBlueBg ?? this.babyBlueBg,
      babyBlueFg: babyBlueFg ?? this.babyBlueFg,
      babyBlueBorder: babyBlueBorder ?? this.babyBlueBorder,
      normalBlueBg: normalBlueBg ?? this.normalBlueBg,
      normalBlueFg: normalBlueFg ?? this.normalBlueFg,
      normalBlueBorder: normalBlueBorder ?? this.normalBlueBorder,
      urgentNavyBg: urgentNavyBg ?? this.urgentNavyBg,
      urgentNavyFg: urgentNavyFg ?? this.urgentNavyFg,
      urgentNavyBorder: urgentNavyBorder ?? this.urgentNavyBorder,
      deepNavyShadow: deepNavyShadow ?? this.deepNavyShadow,
      lightningYellow: lightningYellow ?? this.lightningYellow,
      lightningBannerBg: lightningBannerBg ?? this.lightningBannerBg,
      onLightningBanner: onLightningBanner ?? this.onLightningBanner,
      streakNeonLow: streakNeonLow ?? this.streakNeonLow,
      streakNeonMid: streakNeonMid ?? this.streakNeonMid,
      streakNeonHigh: streakNeonHigh ?? this.streakNeonHigh,
      onStreakNeon: onStreakNeon ?? this.onStreakNeon,
      urgentDayBg: urgentDayBg ?? this.urgentDayBg,
      urgentDayFg: urgentDayFg ?? this.urgentDayFg,
      normalDayBg: normalDayBg ?? this.normalDayBg,
      normalDayFg: normalDayFg ?? this.normalDayFg,
      selectedDayBorder: selectedDayBorder ?? this.selectedDayBorder,
      avatarBadgeBg: avatarBadgeBg ?? this.avatarBadgeBg,
      avatarBadgeBorder: avatarBadgeBorder ?? this.avatarBadgeBorder,
      avatarIconColor: avatarIconColor ?? this.avatarIconColor,
    );
  }

  @override
  ThemeExtension<HabitSailorThemeExtension> lerp(
    covariant ThemeExtension<HabitSailorThemeExtension>? other,
    double t,
  ) {
    if (other is! HabitSailorThemeExtension) {
      return this;
    }
    return HabitSailorThemeExtension(
      babyBlueBg: Color.lerp(babyBlueBg, other.babyBlueBg, t)!,
      babyBlueFg: Color.lerp(babyBlueFg, other.babyBlueFg, t)!,
      babyBlueBorder: Color.lerp(babyBlueBorder, other.babyBlueBorder, t)!,
      normalBlueBg: Color.lerp(normalBlueBg, other.normalBlueBg, t)!,
      normalBlueFg: Color.lerp(normalBlueFg, other.normalBlueFg, t)!,
      normalBlueBorder: Color.lerp(normalBlueBorder, other.normalBlueBorder, t)!,
      urgentNavyBg: Color.lerp(urgentNavyBg, other.urgentNavyBg, t)!,
      urgentNavyFg: Color.lerp(urgentNavyFg, other.urgentNavyFg, t)!,
      urgentNavyBorder: Color.lerp(urgentNavyBorder, other.urgentNavyBorder, t)!,
      deepNavyShadow: Color.lerp(deepNavyShadow, other.deepNavyShadow, t)!,
      lightningYellow: Color.lerp(lightningYellow, other.lightningYellow, t)!,
      lightningBannerBg: Color.lerp(lightningBannerBg, other.lightningBannerBg, t)!,
      onLightningBanner: Color.lerp(onLightningBanner, other.onLightningBanner, t)!,
      streakNeonLow: Color.lerp(streakNeonLow, other.streakNeonLow, t)!,
      streakNeonMid: Color.lerp(streakNeonMid, other.streakNeonMid, t)!,
      streakNeonHigh: Color.lerp(streakNeonHigh, other.streakNeonHigh, t)!,
      onStreakNeon: Color.lerp(onStreakNeon, other.onStreakNeon, t)!,
      urgentDayBg: Color.lerp(urgentDayBg, other.urgentDayBg, t)!,
      urgentDayFg: Color.lerp(urgentDayFg, other.urgentDayFg, t)!,
      normalDayBg: Color.lerp(normalDayBg, other.normalDayBg, t)!,
      normalDayFg: Color.lerp(normalDayFg, other.normalDayFg, t)!,
      selectedDayBorder: Color.lerp(selectedDayBorder, other.selectedDayBorder, t)!,
      avatarBadgeBg: Color.lerp(avatarBadgeBg, other.avatarBadgeBg, t)!,
      avatarBadgeBorder: Color.lerp(avatarBadgeBorder, other.avatarBadgeBorder, t)!,
      avatarIconColor: Color.lerp(avatarIconColor, other.avatarIconColor, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color onPrimaryWhite = Color(0xFFFFFFFF);
  static const Color babyBlueContainer = Color(0xFFE0F2FE);
  static const Color oceanNavy = Color(0xFF082F49);
  static const Color skyBlue = Color(0xFF0EA5E9);
  static const Color surfaceSkyWhite = Color(0xFFF0F9FF);
  static const Color darkNavyText = Color(0xFF0C4A6E);
  static const Color cardBabyBlueSurface = Color(0xFFBAE6FD);
  static const Color seaBlueOutline = Color(0xFF38BDF8);
  static const Color softBlueOutline = Color(0xFF7DD3FC);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color onErrorWhite = Color(0xFFFFFFFF);

  // Extension colors
  static const Color navyUrgentBackground = Color(0xFF0F172A);
  static const Color navyUrgentForeground = Color(0xFFF8FAFC);
  static const Color navyDeepShadow = Color(0x66082F49);

  static const Color bannerYellow = Color(0xFFFDE047);
  static const Color bannerYellowText = Color(0xFFFEF08A);

  static const Color neonCyan = Color(0xFF22D3EE);
  static const Color neonGold = Color(0xFFFACC15);

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: onPrimaryWhite,
      primaryContainer: babyBlueContainer,
      onPrimaryContainer: oceanNavy,
      secondary: skyBlue,
      onSecondary: onPrimaryWhite,
      secondaryContainer: cardBabyBlueSurface,
      onSecondaryContainer: oceanNavy,
      surface: surfaceSkyWhite,
      onSurface: darkNavyText,
      surfaceContainerHighest: cardBabyBlueSurface,
      outline: seaBlueOutline,
      outlineVariant: softBlueOutline,
      error: errorRed,
      onError: onErrorWhite,
    );

    const themeExtension = HabitSailorThemeExtension(
      babyBlueBg: babyBlueContainer,
      babyBlueFg: oceanNavy,
      babyBlueBorder: softBlueOutline,
      normalBlueBg: seaBlueOutline,
      normalBlueFg: oceanNavy,
      normalBlueBorder: primaryBlue,
      urgentNavyBg: navyUrgentBackground,
      urgentNavyFg: navyUrgentForeground,
      urgentNavyBorder: seaBlueOutline,
      deepNavyShadow: navyDeepShadow,
      lightningYellow: bannerYellow,
      lightningBannerBg: darkNavyText,
      onLightningBanner: bannerYellowText,
      streakNeonLow: cardBabyBlueSurface,
      streakNeonMid: neonCyan,
      streakNeonHigh: neonGold,
      onStreakNeon: oceanNavy,
      urgentDayBg: navyUrgentBackground,
      urgentDayFg: navyUrgentForeground,
      normalDayBg: cardBabyBlueSurface,
      normalDayFg: oceanNavy,
      selectedDayBorder: primaryBlue,
      avatarBadgeBg: babyBlueContainer,
      avatarBadgeBorder: primaryBlue,
      avatarIconColor: primaryBlue,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surfaceSkyWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceSkyWhite,
        foregroundColor: darkNavyText,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceSkyWhite,
        surfaceTintColor: surfaceSkyWhite,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: surfaceSkyWhite,
        surfaceTintColor: surfaceSkyWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: onPrimaryWhite,
          elevation: 4,
          shadowColor: navyDeepShadow,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: babyBlueContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: softBlueOutline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: softBlueOutline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: darkNavyText, fontWeight: FontWeight.w600),
        hintStyle: TextStyle(
          color: darkNavyText.withValues(alpha: 0.6),
          fontWeight: FontWeight.w400,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        themeExtension,
      ],
    );
  }
}
