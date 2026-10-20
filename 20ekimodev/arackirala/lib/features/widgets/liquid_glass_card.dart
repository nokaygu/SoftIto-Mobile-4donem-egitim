import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Akışkan buzlu cam (Liquid Glass) kart bileşeni.
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isHighlighted;
  final double borderRadius;
  final double blurSigma;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.isHighlighted = false,
    this.borderRadius = 18,
    this.blurSigma = 18,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.burgundyPrimary.withValues(alpha: 0.24)
                : AppColors.glassSurface,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isHighlighted
                  ? AppColors.burgundyAccent.withValues(alpha: 0.8)
                  : AppColors.glassBorder,
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );

    Widget result = cardContent;

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: result,
        ),
      );
    }

    return result;
  }
}
