import 'package:flutter/foundation.dart';

import '../../../core/utils/calendar_date_utils.dart';
import '../models/diary_model.dart';

/// Günlük kayıtlarını ve seçili tarihi `ValueNotifier` ile reaktif olarak yöneten kontrolcü.
class DiaryController {
  final ValueNotifier<Map<String, DiaryEntryModel>> entries =
      ValueNotifier<Map<String, DiaryEntryModel>>({});

  /// Verilen tarih için kayıtlı günlüğü döner (yoksa `null`).
  DiaryEntryModel? getEntryForDate(DateTime date) {
    final key = CalendarDateUtils.toDateKey(date);
    return entries.value[key];
  }

  /// Verilen tarihe ait yeni günlük ekler veya mevcut günlüğü günceller.
  void saveEntry({
    required DateTime date,
    required String title,
    required String content,
    required String moodEmoji,
  }) {
    final normalizedDate = CalendarDateUtils.dateOnly(date);
    final key = CalendarDateUtils.toDateKey(normalizedDate);
    final trimmedTitle = title.trim();
    final trimmedContent = content.trim();

    final newEntry = DiaryEntryModel(
      id: key,
      date: normalizedDate,
      title: trimmedTitle.isEmpty ? 'Günün Notu' : trimmedTitle,
      content: trimmedContent,
      moodEmoji: moodEmoji,
    );

    final updated = Map<String, DiaryEntryModel>.from(entries.value);
    updated[key] = newEntry;
    entries.value = updated;
  }

  /// Verilen tarihe ait günlüğü siler.
  void deleteEntry(DateTime date) {
    final key = CalendarDateUtils.toDateKey(date);
    if (!entries.value.containsKey(key)) return;
    final updated = Map<String, DiaryEntryModel>.from(entries.value);
    updated.remove(key);
    entries.value = updated;
  }

  /// Takvim ızgarasında günlerin altında gösterilecek `dateKey -> moodEmoji` haritasını üretir.
  Map<String, String> get moodMap {
    return entries.value.map((key, entry) => MapEntry(key, entry.moodEmoji));
  }

  void dispose() {
    entries.dispose();
  }
}
