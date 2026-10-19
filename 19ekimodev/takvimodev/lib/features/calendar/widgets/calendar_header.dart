import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/utils/calendar_date_utils.dart';
import '../controllers/calendar_controller.dart';

/// Takvim üst barı: Seçili ay/yıl başlığı, önceki/sonraki ay okları,
/// farklı bir aydayken/gündeyken bugüne döndüren "Bugün" butonu ve Tema Değiştirme ikonu.
class CalendarHeader extends StatelessWidget {
  final CalendarController calendarController;
  final ThemeController themeController;

  const CalendarHeader({
    super.key,
    required this.calendarController,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: calendarController.focusedMonth,
      builder: (context, focusedMonth, _) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: calendarController.selectedDate,
          builder: (context, _, _) {
            return Row(
              children: [
                Expanded(
                  child: _MonthTitleLabel(
                    title: CalendarDateUtils.formatMonthYear(focusedMonth),
                  ),
                ),
                if (!calendarController.isShowingToday)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _TodayChipButton(
                      onTap: calendarController.jumpToToday,
                    ),
                  ),
                _NavIconButton(
                  icon: Icons.chevron_left_rounded,
                  tooltip: 'Önceki Ay',
                  onTap: calendarController.previousMonth,
                ),
                const SizedBox(width: 4),
                _NavIconButton(
                  icon: Icons.chevron_right_rounded,
                  tooltip: 'Sonraki Ay',
                  onTap: calendarController.nextMonth,
                ),
                const SizedBox(width: 8),
                _ThemeToggleButton(themeController: themeController),
              ],
            );
          },
        );
      },
    );
  }
}

class _MonthTitleLabel extends StatelessWidget {
  final String title;

  const _MonthTitleLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      layoutBuilder: (currentChild, previousChildren) {
        return Align(alignment: Alignment.centerLeft, child: currentChild);
      },
      child: Text(
        title,
        key: ValueKey<String>(title),
        style: theme.textTheme.headlineSmall,
      ),
    );
  }
}

class _TodayChipButton extends StatelessWidget {
  final VoidCallback onTap;

  const _TodayChipButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: AppDimens.radiusPill,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer,
          borderRadius: AppDimens.radiusPill,
          border: Border.all(color: theme.colorScheme.primary, width: 1),
        ),
        child: Text(
          'Bugün',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _NavIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        shape: const RoundedRectangleBorder(borderRadius: AppDimens.radiusSm),
      ),
      icon: Icon(icon, color: theme.colorScheme.onSurface),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  final ThemeController themeController;

  const _ThemeToggleButton({required this.themeController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          onPressed: themeController.toggleTheme,
          tooltip: isDark ? 'Aydınlık Tema' : 'Koyu Tema',
          visualDensity: VisualDensity.compact,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            shape: const RoundedRectangleBorder(
              borderRadius: AppDimens.radiusSm,
            ),
          ),
          icon: Icon(
            isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        );
      },
    );
  }
}
