import 'package:flutter/material.dart';

class SailorAvatar {
  final int index;
  final String title;
  final String roleDescription;
  final IconData icon;

  const SailorAvatar({
    required this.index,
    required this.title,
    required this.roleDescription,
    required this.icon,
  });
}

class AvatarConstants {
  AvatarConstants._();

  static const List<SailorAvatar> avatars = [
    SailorAvatar(
      index: 0,
      title: 'Açık Deniz Kaptanı',
      roleDescription: 'Geminin rotasını çizer, fırtınalara meydan okur.',
      icon: Icons.sailing_rounded,
    ),
    SailorAvatar(
      index: 1,
      title: 'Usta Dümenci',
      roleDescription: 'Dümeni sımsıkı tutar, rotadan asla şaşmaz.',
      icon: Icons.explore_rounded,
    ),
    SailorAvatar(
      index: 2,
      title: 'Pruva Gözcüsü',
      roleDescription: 'Ufuktaki hedefleri ilk o fark eder.',
      icon: Icons.remove_red_eye_rounded,
    ),
    SailorAvatar(
      index: 3,
      title: 'Çalışkan Tayfa',
      roleDescription: 'Yelkenleri açar, zinciri asla kırmaz.',
      icon: Icons.rowing_rounded,
    ),
    SailorAvatar(
      index: 4,
      title: 'Deniz Muhafızı',
      roleDescription: 'Tüm zorluklara karşı kalkan olur.',
      icon: Icons.shield_rounded,
    ),
  ];

  static SailorAvatar getByIndex(int index) {
    if (index >= 0 && index < avatars.length) {
      return avatars[index];
    }
    return avatars[0];
  }
}
