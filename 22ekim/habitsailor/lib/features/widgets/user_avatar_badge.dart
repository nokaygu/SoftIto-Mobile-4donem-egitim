import 'package:flutter/material.dart';
import '../../core/constants/avatar_constants.dart';
import '../../core/theme/app_theme.dart';

class UserAvatarBadge extends StatelessWidget {
  final int avatarIndex;
  final double radius;
  final bool showBorder;
  final bool isSelected;
  final VoidCallback? onTap;

  const UserAvatarBadge({
    super.key,
    required this.avatarIndex,
    this.radius = 24,
    this.showBorder = true,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailorThemeExtension>()!;
    final avatar = AvatarConstants.getByIndex(avatarIndex);

    final widgetChild = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? cs.primary : ext.avatarBadgeBg,
        border: showBorder
            ? Border.all(
                color: isSelected ? ext.lightningYellow : ext.avatarBadgeBorder,
                width: isSelected ? 3.0 : 2.0,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: ext.deepNavyShadow,
            blurRadius: isSelected ? 12 : 6,
            offset: Offset(0, isSelected ? 4 : 2),
          ),
        ],
      ),
      child: Icon(
        avatar.icon,
        size: radius * 1.1,
        color: isSelected ? cs.onPrimary : ext.avatarIconColor,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: widgetChild,
      );
    }

    return widgetChild;
  }
}
