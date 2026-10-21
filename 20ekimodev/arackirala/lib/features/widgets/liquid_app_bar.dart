import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Buzlu cam arka planlı şeffaf AppBar bileşeni.
class LiquidAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBottomBorder;

  const LiquidAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBottomBorder = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: context.scaffoldColor.withValues(alpha: context.isDark ? 0.75 : 0.88),
            border: showBottomBorder
                ? Border(
                    bottom: BorderSide(
                      color: context.glassBorderColor,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: leading,
            iconTheme: IconThemeData(color: context.textPrimaryColor),
            centerTitle: true,
            title: Text(
              title,
              style: TextStyle(
                color: context.textPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            actions: actions,
          ),
        ),
      ),
    );
  }
}
