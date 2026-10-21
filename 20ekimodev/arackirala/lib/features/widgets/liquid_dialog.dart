import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'liquid_button.dart';

/// Liquid Glass modal diyalog bileşeni.
/// Koyu ve aydınlık tema ile tam uyumludur. Mor renk içermez.
class LiquidDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;

  const LiquidDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: context.glassSurfaceColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: context.glassBorderColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.45 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                Flexible(child: SingleChildScrollView(child: content)),
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  if (actions!.length == 1)
                    actions!.first
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions!,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.burgundyPrimary).withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: (iconColor ?? AppColors.burgundyPrimary).withValues(alpha: 0.4),
              ),
            ),
            child: Icon(icon, color: iconColor ?? AppColors.burgundyLight, size: 22),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: context.textPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Standart Liquid Modal açıcı
Future<T?> showLiquidDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget>? actions,
  IconData? icon,
  Color? iconColor,
}) {
  return showDialog<T>(
    context: context,
    builder: (ctx) => LiquidDialog(
      title: title,
      content: content,
      actions: actions,
      icon: icon,
      iconColor: iconColor,
    ),
  );
}

/// İşlem onay diyaloğu (Vazgeç / Onayla)
Future<bool?> showLiquidConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Onayla',
  String cancelText = 'Vazgeç',
  bool isDestructive = false,
  IconData icon = Icons.help_outline_rounded,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => LiquidDialog(
      title: title,
      icon: icon,
      iconColor: isDestructive ? AppColors.error : AppColors.burgundyLight,
      content: Text(
        message,
        style: TextStyle(
          color: ctx.textSecondaryColor,
          fontSize: 14,
          height: 1.45,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            cancelText,
            style: TextStyle(color: ctx.textMutedColor, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        LiquidButton(
          text: confirmText,
          height: 42,
          isFullWidth: false,
          customColor: isDestructive ? AppColors.error : AppColors.burgundyPrimary,
          onPressed: () => Navigator.pop(ctx, true),
        ),
      ],
    ),
  );
}

/// Başarı ve bilgilendirme diyaloğu (Tamam)
Future<void> showLiquidSuccessDialog(
  BuildContext context, {
  required String title,
  required String message,
  String buttonText = 'Harika, Devam Et',
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => LiquidDialog(
      title: title,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
      content: Text(
        message,
        style: TextStyle(
          color: ctx.textSecondaryColor,
          fontSize: 14,
          height: 1.45,
        ),
      ),
      actions: [
        LiquidButton(
          text: buttonText,
          height: 42,
          isFullWidth: true,
          onPressed: () => Navigator.pop(ctx),
        ),
      ],
    ),
  );
}
