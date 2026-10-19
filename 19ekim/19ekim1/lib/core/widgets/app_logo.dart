import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withAlpha(40),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/app_logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
