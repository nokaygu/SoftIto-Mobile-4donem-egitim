import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/calendar_day_model.dart';

/// Takvimdeki her bir günü çizen `AnimatedContainer` tabanlı zarif gün kutucuğu.
class CalendarDayTile extends StatelessWidget {
  final CalendarDayModel dayModel;
  final VoidCallback onTap;

  const CalendarDayTile({
    super.key,
    required this.dayModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: _resolveBackgroundColor(colors),
          borderRadius: AppDimens.radiusMd,
          border: Border.all(
            color: _resolveBorderColor(colors),
            width: dayModel.isToday || dayModel.isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${dayModel.dayNumber}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: dayModel.isSelected || dayModel.isToday
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: _resolveTextColor(colors),
              ),
            ),
            const SizedBox(height: 2),
            _DayEntryIndicator(
              moodEmoji: dayModel.moodEmoji,
              isSelected: dayModel.isSelected,
            ),
          ],
        ),
      ),
    );
  }

  Color _resolveBackgroundColor(ColorScheme colors) {
    if (dayModel.isSelected) return colors.primary;
    if (dayModel.isToday) return colors.tertiaryContainer;
    return colors.surfaceContainerHighest;
  }

  Color _resolveBorderColor(ColorScheme colors) {
    if (dayModel.isSelected || dayModel.isToday) return colors.primary;
    return colors.outline;
  }

  Color _resolveTextColor(ColorScheme colors) {
    if (dayModel.isSelected) return colors.onPrimary;
    if (dayModel.isToday) return colors.primary;
    return colors.onSurface;
  }
}

class _DayEntryIndicator extends StatelessWidget {
  final String? moodEmoji;
  final bool isSelected;

  const _DayEntryIndicator({required this.moodEmoji, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (moodEmoji == null || moodEmoji!.isEmpty) {
      return const SizedBox(height: 14);
    }

    return SizedBox(
      height: 14,
      child: Center(
        child: Text(
          moodEmoji!,
          style: const TextStyle(fontSize: 11, height: 1.0),
        ),
      ),
    );
  }
}
