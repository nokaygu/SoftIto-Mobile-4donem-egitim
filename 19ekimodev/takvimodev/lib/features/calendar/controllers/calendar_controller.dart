import 'package:flutter/foundation.dart';

import '../../../core/utils/calendar_date_utils.dart';

/// Takvimde görüntülenen ayı (`focusedMonth`) ve seçili günü (`selectedDate`)
/// harici paket kullanmadan `ValueNotifier` ile yöneten kontrolcü.
class CalendarController {
  final ValueNotifier<DateTime> focusedMonth;
  final ValueNotifier<DateTime> selectedDate;

  CalendarController({DateTime? initialDate})
    : focusedMonth = ValueNotifier<DateTime>(
        DateTime(
          (initialDate ?? DateTime.now()).year,
          (initialDate ?? DateTime.now()).month,
          1,
        ),
      ),
      selectedDate = ValueNotifier<DateTime>(
        CalendarDateUtils.dateOnly(initialDate ?? DateTime.now()),
      );

  /// Bir önceki aya geçer.
  void previousMonth() {
    final current = focusedMonth.value;
    focusedMonth.value = DateTime(current.year, current.month - 1, 1);
  }

  /// Bir sonraki aya geçer.
  void nextMonth() {
    final current = focusedMonth.value;
    focusedMonth.value = DateTime(current.year, current.month + 1, 1);
  }

  /// Belirli bir günü seçer ve gerekirse odaklanan ayı o güne günceller.
  void selectDate(DateTime date) {
    final normalized = CalendarDateUtils.dateOnly(date);
    selectedDate.value = normalized;
    if (!CalendarDateUtils.isSameMonth(focusedMonth.value, normalized)) {
      focusedMonth.value = DateTime(normalized.year, normalized.month, 1);
    }
  }

  /// Tek tıkla bugünün tarihine ve ayına döner.
  void jumpToToday() {
    final now = CalendarDateUtils.dateOnly(DateTime.now());
    selectedDate.value = now;
    focusedMonth.value = DateTime(now.year, now.month, 1);
  }

  /// Odaklanan ayın ya da seçili günün bugünden farklı olup olmadığını döner.
  bool get isShowingToday {
    final now = DateTime.now();
    return CalendarDateUtils.isSameMonth(focusedMonth.value, now) &&
        CalendarDateUtils.isSameDay(selectedDate.value, now);
  }

  void dispose() {
    focusedMonth.dispose();
    selectedDate.dispose();
  }
}
