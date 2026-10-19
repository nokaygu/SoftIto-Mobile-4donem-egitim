import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Seçili gün için henüz günlük yazılmadığında gösterilen şık boş durum (Empty State) kartı.
class DiaryEmptyCard extends StatelessWidget {
  final VoidCallback onWritePressed;

  const DiaryEmptyCard({super.key, required this.onWritePressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
          _EmptyNotebookIcon(colorScheme: theme.colorScheme),
          const SizedBox(height: 14),
          Text(
            'Bu güne ait bir anı henüz yazılmamış ✨',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Günün hissini ve hatıralarını defterine kaydedebilirsin.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onWritePressed,
            icon: const Icon(Icons.edit_note_rounded, size: 20),
            label: const Text('Günlük Yaz'),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotebookIcon extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyNotebookIcon({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: AppDimens.radiusMd,
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: colorScheme.primary,
        size: 26,
      ),
    );
  }
}
