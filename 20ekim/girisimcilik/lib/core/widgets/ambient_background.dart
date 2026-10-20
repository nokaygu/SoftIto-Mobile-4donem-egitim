import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Sayfa arkasında sıvı ışık kırılmaları (ambient liquid glow) oluşturan dinamik zemin.
class AmbientBackground extends StatelessWidget {
  const AmbientBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // 1. Temel Arka Plan
        Positioned.fill(
          child: ColoredBox(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          ),
        ),

        // 2. Üst Bölge Canlı İndigo/Mavi Sıvı Işık Küresi (Tam Ekran İçi)
        Positioned(
          top: 40,
          left: -40,
          child: Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.ambientBlue : const Color(0xFF93C5FD))
                      .withValues(alpha: isDark ? 0.45 : 0.28),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 3. Sağ Orta Akışkan Safir / İndigo Sıvı Işık Küresi
        Positioned(
          top: 260,
          right: -50,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.ambientIndigo : const Color(0xFFBAE6FD))
                      .withValues(alpha: isDark ? 0.38 : 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 4. Alt Bölge Zümrüt & Camgöbeği Sıvı Işık Küresi
        Positioned(
          bottom: 80,
          left: 10,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.ambientEmerald : const Color(0xFFA7F3D0))
                      .withValues(alpha: isDark ? 0.35 : 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 5. En Alt Dock Arkası Ek Cyan Parıltısı
        Positioned(
          bottom: -40,
          right: 20,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.ambientCyan : const Color(0xFFBAE6FD))
                      .withValues(alpha: isDark ? 0.32 : 0.20),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 6. Sayfa İçeriği
        Positioned.fill(child: child),
      ],
    );
  }
}
