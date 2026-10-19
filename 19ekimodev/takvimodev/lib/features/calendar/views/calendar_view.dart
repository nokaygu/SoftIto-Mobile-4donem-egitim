import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/calendar_controller.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_weekday_row.dart';

/// Kırtasiye/defter estetiğinde özel tasarım takvim kartı görünümü.
class CalendarView extends StatelessWidget {
  final CalendarController calendarController;
  final ThemeController themeController;
  final Map<String, String> moodByDateKey;
  final ValueChanged<DateTime> onDaySelected;

  const CalendarView({
    super.key,
    required this.calendarController,
    required this.themeController,
    required this.moodByDateKey,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusLg,
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: isDark
            ? AppDimens.darkCardShadow
            : AppDimens.lightCardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarHeader(
            calendarController: calendarController,
            themeController: themeController,
          ),
          const SizedBox(height: 8),
          const Divider(height: 16),
          const CalendarWeekdayRow(),
          const SizedBox(height: 4),
          _ReactiveCalendarGrid(
            calendarController: calendarController,
            moodByDateKey: moodByDateKey,
            onDaySelected: onDaySelected,
          ),
        ],
      ),
    );
  }
}

class _ReactiveCalendarGrid extends StatelessWidget {
  final CalendarController calendarController;
  final Map<String, String> moodByDateKey;
  final ValueChanged<DateTime> onDaySelected;

  const _ReactiveCalendarGrid({
    required this.calendarController,
    required this.moodByDateKey,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: calendarController.focusedMonth,
      builder: (context, focusedMonth, _) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: calendarController.selectedDate,
          builder: (context, selectedDate, _) {
            return CalendarGrid(
              focusedMonth: focusedMonth,
              selectedDate: selectedDate,
              moodByDateKey: moodByDateKey,
              onDaySelected: onDaySelected,
            );
          },
        );
      },
    );
  }
}
