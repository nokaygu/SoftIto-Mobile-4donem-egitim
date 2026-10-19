import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/diary_model.dart';

/// Seçili gün için kayıtlı günlüğü (ruh hali emojisi, başlık, önizleme ve Düzenle/Sil butonları)
/// gösteren şık kırtasiye kartı.
class DiaryEntryCard extends StatelessWidget {
  final DiaryEntryModel entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DiaryEntryCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusLg,
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: isDark
            ? AppDimens.darkCardShadow
            : AppDimens.lightCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _EntryCardHeader(entry: entry, onEdit: onEdit, onDelete: onDelete),
          const SizedBox(height: 14),
          Text(entry.title, style: theme.textTheme.titleLarge),
          if (entry.content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(entry.content, style: theme.textTheme.bodyLarge),
          ],
        ],
      ),
    );
  }
}

class _EntryCardHeader extends StatelessWidget {
  final DiaryEntryModel entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EntryCardHeader({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moodLabel = MoodOption.labelForEmoji(entry.moodEmoji);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            borderRadius: AppDimens.radiusPill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(entry.moodEmoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                moodLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, size: 16),
          label: const Text('Düzenle'),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onDelete,
          tooltip: 'Sil',
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            shape: const RoundedRectangleBorder(
              borderRadius: AppDimens.radiusSm,
            ),
          ),
          icon: Icon(
            Icons.delete_outline_rounded,
            color: theme.colorScheme.error,
            size: 20,
          ),
        ),
      ],
    );
  }
}
