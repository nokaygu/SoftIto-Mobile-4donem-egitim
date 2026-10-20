import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Apple iOS Liquid Glass frosted glassmorphism bileşeni.
/// Harici paket olmadan tamamen Flutter yerleşik BackdropFilter ve ClipRRect kullanır.
class LiquidGlassContainer extends StatelessWidget {
  const LiquidGlassContainer({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurSigma = 22.0,
    this.border,
    this.color,
    this.gradient,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final BoxBorder? border;
  final Color? color;
  final Gradient? gradient;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(24);

    final defaultBorder = border ??
        Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
          width: 1.3,
        );

    final defaultGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.15),
                  const Color(0xFF131B2E).withValues(alpha: 0.50),
                ]
              : [
                  Colors.white.withValues(alpha: 0.85),
                  Colors.white.withValues(alpha: 0.58),
                ],
        );

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.42)
                : AppColors.lightAccent.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
          if (isDark)
            BoxShadow(
              color: AppColors.darkAccent.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding ?? const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color,
              gradient: color == null ? defaultGradient : null,
              borderRadius: radius,
              border: defaultBorder,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
