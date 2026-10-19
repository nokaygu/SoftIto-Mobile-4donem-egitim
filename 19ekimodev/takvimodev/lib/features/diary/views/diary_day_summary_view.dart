import 'package:flutter/material.dart';

import '../../../core/utils/calendar_date_utils.dart';
import '../controllers/diary_controller.dart';
import '../models/diary_model.dart';
import '../widgets/diary_empty_card.dart';
import '../widgets/diary_entry_card.dart';
import 'diary_editor_sheet.dart';

/// Seçili günün tam tarihini (Örn: "19 Ekim 2026, Pazartesi") ve o güne ait
/// günlük kartını ya da boş durum kartını reaktif olarak gösteren alt panel görünümü.
class DiaryDaySummaryView extends StatelessWidget {
  final DateTime selectedDate;
  final DiaryController diaryController;

  const DiaryDaySummaryView({
    super.key,
    required this.selectedDate,
    required this.diaryController,
  });

  void _openEditor(BuildContext context) {
    DiaryEditorSheet.show(
      context,
      date: selectedDate,
      diaryController: diaryController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = CalendarDateUtils.formatFullDate(selectedDate);

    return ValueListenableBuilder<Map<String, DiaryEntryModel>>(
      valueListenable: diaryController.entries,
      builder: (context, _, _) {
        final entry = diaryController.getEntryForDate(selectedDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SelectedDateBanner(dateText: formattedDate),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: entry == null
                  ? DiaryEmptyCard(
                      key: ValueKey<String>('empty_$formattedDate'),
                      onWritePressed: () => _openEditor(context),
                    )
                  : DiaryEntryCard(
                      key: ValueKey<String>('entry_${entry.id}_${entry.title}'),
                      entry: entry,
                      onEdit: () => _openEditor(context),
                      onDelete: () => diaryController.deleteEntry(selectedDate),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _SelectedDateBanner extends StatelessWidget {
  final String dateText;

  const _SelectedDateBanner({required this.dateText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(dateText, style: theme.textTheme.titleMedium)),
      ],
    );
  }
}
