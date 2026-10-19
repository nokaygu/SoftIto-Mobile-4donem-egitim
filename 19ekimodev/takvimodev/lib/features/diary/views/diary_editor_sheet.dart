import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/calendar_date_utils.dart';
import '../controllers/diary_controller.dart';
import '../models/diary_model.dart';
import '../widgets/mood_selector_bar.dart';

/// Günlük yazma ve düzenleme alt penceresi (Modal Bottom Sheet).
/// Yalnızca `TextEditingController` yaşam döngüsü için küçük bir `StatefulWidget` kullanır;
/// seçili ruh hali (`selectedMood`) ise `ValueNotifier<String>` ile reaktif yönetilir.
class DiaryEditorSheet extends StatefulWidget {
  final DateTime date;
  final DiaryController diaryController;
  final DiaryEntryModel? existingEntry;

  const DiaryEditorSheet({
    super.key,
    required this.date,
    required this.diaryController,
    this.existingEntry,
  });

  static Future<void> show(
    BuildContext context, {
    required DateTime date,
    required DiaryController diaryController,
  }) {
    final existing = diaryController.getEntryForDate(date);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => DiaryEditorSheet(
        date: date,
        diaryController: diaryController,
        existingEntry: existing,
      ),
    );
  }

  @override
  State<DiaryEditorSheet> createState() => _DiaryEditorSheetState();
}

class _DiaryEditorSheetState extends State<DiaryEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final ValueNotifier<String> _selectedMood;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingEntry?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.existingEntry?.content ?? '',
    );
    _selectedMood = ValueNotifier<String>(
      widget.existingEntry?.moodEmoji ?? MoodOption.presets.first.emoji,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _selectedMood.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.diaryController.saveEntry(
      date: widget.date,
      title: _titleController.text,
      content: _contentController.text,
      moodEmoji: _selectedMood.value,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: EdgeInsets.fromLTRB(22, 16, 22, bottomInset + 22),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _EditorSheetHeader(
              dateText: CalendarDateUtils.formatFullDate(widget.date),
              onSave: _handleSave,
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<String>(
              valueListenable: _selectedMood,
              builder: (context, currentMood, _) {
                return MoodSelectorBar(
                  selectedEmoji: currentMood,
                  onMoodSelected: (emoji) => _selectedMood.value = emoji,
                );
              },
            ),
            const SizedBox(height: 18),
            _NotebookPaperEditor(
              titleController: _titleController,
              contentController: _contentController,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorSheetHeader extends StatelessWidget {
  final String dateText;
  final VoidCallback onSave;

  const _EditorSheetHeader({required this.dateText, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Günce Yaprağı',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(dateText, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.check_rounded, size: 18),
          label: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _NotebookPaperEditor extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;

  const _NotebookPaperEditor({
    required this.titleController,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusLg,
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            style: theme.textTheme.titleLarge,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'Günün Başlığı...'),
          ),
          const Divider(height: 16),
          TextField(
            controller: contentController,
            style: theme.textTheme.bodyLarge,
            minLines: 6,
            maxLines: 12,
            decoration: const InputDecoration(
              hintText: 'Sevgili güncem, bugün neler hissettin ve yaşadın?...',
            ),
          ),
        ],
      ),
    );
  }
}
