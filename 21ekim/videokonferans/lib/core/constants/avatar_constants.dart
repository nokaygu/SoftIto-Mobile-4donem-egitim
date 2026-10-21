import 'package:flutter/material.dart';

/// 5 Özel Avatar Model ve Tanımları
class AvatarInfo {
  final int id;
  final String titleTr;
  final String titleEn;
  final IconData icon;
  final List<Color> gradientColors;
  final Color primaryColor;

  const AvatarInfo({
    required this.id,
    required this.titleTr,
    required this.titleEn,
    required this.icon,
    required this.gradientColors,
    required this.primaryColor,
  });

  String getTitle(bool isTurkish) => isTurkish ? titleTr : titleEn;
}

class AvatarConstants {
  AvatarConstants._();

  static const List<AvatarInfo> avatars = [
    AvatarInfo(
      id: 0,
      titleTr: 'Siber Pilot',
      titleEn: 'Cyber Pilot',
      icon: Icons.rocket_launch_rounded,
      gradientColors: [Color(0xFFFF1E42), Color(0xFFFF8A00)],
      primaryColor: Color(0xFFFF1E42),
    ),
    AvatarInfo(
      id: 1,
      titleTr: 'Bilge Ninja',
      titleEn: 'Wise Ninja',
      icon: Icons.psychology_rounded,
      gradientColors: [Color(0xFFFFB703), Color(0xFFFB8500)],
      primaryColor: Color(0xFFFFB703),
    ),
    AvatarInfo(
      id: 2,
      titleTr: 'Kutup Kaşifi',
      titleEn: 'Polar Explorer',
      icon: Icons.ac_unit_rounded,
      gradientColors: [Color(0xFF88C0D0), Color(0xFF5E81AC)],
      primaryColor: Color(0xFF88C0D0),
    ),
    AvatarInfo(
      id: 3,
      titleTr: 'Zümrüt Hacker',
      titleEn: 'Emerald Hacker',
      icon: Icons.terminal_rounded,
      gradientColors: [Color(0xFF10B981), Color(0xFF06B6D4)],
      primaryColor: Color(0xFF10B981),
    ),
    AvatarInfo(
      id: 4,
      titleTr: 'Galaksi Kaptanı',
      titleEn: 'Galaxy Captain',
      icon: Icons.public_rounded,
      gradientColors: [Color(0xFF3A86FF), Color(0xFF8338EC)],
      primaryColor: Color(0xFF3A86FF),
    ),
  ];

  static AvatarInfo getById(int id) {
    if (id < 0 || id >= avatars.length) {
      return avatars[0];
    }
    return avatars[id];
  }
}
