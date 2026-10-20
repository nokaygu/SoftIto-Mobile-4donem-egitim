import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Bordo ve Liquid Glass stilli özel buton.
/// Mor renk kesinlikle içermez, yüksek kontrastlı beyaz/gümüş metin kullanır.
class LiquidButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isFullWidth;
  final double height;
  final Color? customColor;

  const LiquidButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isFullWidth = true,
    this.height = 50,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = customColor ??
        (isPrimary ? AppColors.burgundyPrimary : Colors.transparent);

    final buttonDecoration = BoxDecoration(
      gradient: isPrimary && customColor == null
          ? const LinearGradient(
              colors: [
                AppColors.burgundyAccent,
                AppColors.burgundyPrimary,
                AppColors.burgundySecondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: isPrimary && customColor != null
          ? effectiveColor
          : (isPrimary ? null : AppColors.glassSurface),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isPrimary
            ? AppColors.burgundyAccent.withValues(alpha: 0.6)
            : AppColors.glassBorderLight,
        width: 1.2,
      ),
      boxShadow: isPrimary
          ? [
              BoxShadow(
                color: AppColors.burgundyPrimary.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );

    Widget childWidget = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: isPrimary ? AppColors.textWhite : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: isPrimary ? AppColors.textWhite : AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: buttonDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: childWidget,
          ),
        ),
      ),
    );
  }
}
