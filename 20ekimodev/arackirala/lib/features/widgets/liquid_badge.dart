import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum LiquidBadgeType {
  success,
  warning,
  burgundy,
  neutral,
}

/// Durum ve rol rozeti bileşeni.
class LiquidBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final LiquidBadgeType type;

  const LiquidBadge({
    super.key,
    required this.text,
    this.icon,
    this.type = LiquidBadgeType.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, borderColor, textColor) = _resolveColors(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, Color) _resolveColors(BuildContext context) {
    switch (type) {
      case LiquidBadgeType.success:
        return (
          AppColors.success.withValues(alpha: context.isDark ? 0.18 : 0.12),
          AppColors.success.withValues(alpha: 0.6),
          AppColors.success,
        );
      case LiquidBadgeType.warning:
        return (
          AppColors.warning.withValues(alpha: context.isDark ? 0.18 : 0.12),
          AppColors.warning.withValues(alpha: 0.6),
          AppColors.warning,
        );
      case LiquidBadgeType.burgundy:
        return (
          AppColors.burgundyPrimary.withValues(alpha: context.isDark ? 0.25 : 0.15),
          AppColors.burgundyAccent.withValues(alpha: 0.8),
          context.isDark ? AppColors.textWhite : AppColors.burgundyPrimary,
        );
      case LiquidBadgeType.neutral:
        return (
          context.surfaceVariantColor.withValues(alpha: context.isDark ? 0.5 : 0.8),
          context.glassBorderColor,
          context.textSecondaryColor,
        );
    }
  }
}
