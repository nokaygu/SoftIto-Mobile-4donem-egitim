import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_logo.dart';

class AppHeaderTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const AppHeaderTitle({
    super.key,
    this.title = 'Susadım',
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppLogo(size: 28),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.neonCyan,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
