import 'package:flutter/material.dart';

import '../../../core/utils/calendar_date_utils.dart';
import '../models/calendar_day_model.dart';
import 'calendar_day_tile.dart';

/// 7 sütunlu `GridView.builder` kullanarak ayın günlerini ve başlangıç boşluklarını çizen ızgara.
class CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<String, String> moodByDateKey;
  final ValueChanged<DateTime> onDaySelected;

  const CalendarGrid({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.moodByDateKey,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final year = focusedMonth.year;
    final month = focusedMonth.month;
    final leadingEmpty = CalendarDateUtils.getLeadingEmptyCells(year, month);
    final daysInMonth = CalendarDateUtils.getDaysInMonth(year, month);
    final totalCells = leadingEmpty + daysInMonth;
    final today = CalendarDateUtils.dateOnly(DateTime.now());

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        if (index < leadingEmpty) {
          return const SizedBox.shrink();
        }
        final dayNumber = index - leadingEmpty + 1;
        final cellDate = DateTime(year, month, dayNumber);
        final dateKey = CalendarDateUtils.toDateKey(cellDate);

        return CalendarDayTile(
          dayModel: CalendarDayModel(
            date: cellDate,
            isToday: CalendarDateUtils.isSameDay(cellDate, today),
            isSelected: CalendarDateUtils.isSameDay(cellDate, selectedDate),
            moodEmoji: moodByDateKey[dateKey],
          ),
          onTap: () => onDaySelected(cellDate),
        );
      },
    );
  }
}
