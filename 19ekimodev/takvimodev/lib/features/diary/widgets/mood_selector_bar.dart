import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/diary_model.dart';

/// Günlük yazma ekranında yatay olarak ruh hali (mood) seçmeyi sağlayan bileşen.
/// Hem mobil dokunmatik ekranlarda hem de Web/Masaüstü fare (mouse drag + scrollbar)
/// kullanımında tüm seçeneklere rahatça kaydırılarak ulaşılmasını sağlar.
class MoodSelectorBar extends StatefulWidget {
  final String selectedEmoji;
  final ValueChanged<String> onMoodSelected;

  const MoodSelectorBar({
    super.key,
    required this.selectedEmoji,
    required this.onMoodSelected,
  });

  @override
  State<MoodSelectorBar> createState() => _MoodSelectorBarState();
}

class _MoodSelectorBarState extends State<MoodSelectorBar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _HorizontalDragScrollBehavior(),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 42,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              itemCount: MoodOption.presets.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final option = MoodOption.presets[index];
                final isSelected = option.emoji == widget.selectedEmoji;
                return _MoodChipItem(
                  option: option,
                  isSelected: isSelected,
                  onTap: () => widget.onMoodSelected(option.emoji),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalDragScrollBehavior extends MaterialScrollBehavior {
  const _HorizontalDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class _MoodChipItem extends StatelessWidget {
  final MoodOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodChipItem({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: AppDimens.radiusPill,
          border: Border.all(
            color: isSelected ? colors.primary : colors.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(option.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              option.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? colors.onPrimary : colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
