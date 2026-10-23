import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/habit_task_model.dart';

class HabitTaskCard extends StatelessWidget {
  final HabitTaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onUncomplete;
  final bool isCompletedToday;
  final bool isLocked;
  final bool isSelected;
  final int? pointsEarned;
  final String? completionNote;
  final VoidCallback? onEditNote;

  const HabitTaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onDeleteTap,
    this.onUncomplete,
    this.isCompletedToday = false,
    this.isLocked = false,
    this.isSelected = false,
    this.pointsEarned,
    this.completionNote,
    this.onEditNote,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailorThemeExtension>()!;

    final bgColor = ext.difficultyBackground(task.difficulty);
    final fgColor = ext.difficultyForeground(task.difficulty);
    final baseBorderColor = ext.difficultyBorder(task.difficulty);
    final isUrgentNavy = task.difficulty == 2;

    final borderColor = isSelected ? ext.lightningYellow : baseBorderColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: isSelected ? 2.8 : (isUrgentNavy ? 2.2 : 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? ext.lightningYellow.withValues(alpha: 0.45)
                : (isUrgentNavy ? ext.deepNavyShadow : cs.outlineVariant),
            blurRadius: isSelected ? 14 : (isUrgentNavy ? 16 : 8),
            offset: Offset(0, isUrgentNavy ? 7 : 3),
          ),
        ],
      ),
      child: Material(
        color: cs.surface.withValues(alpha: 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          // Clicking anywhere on the card triggers action
          onTap: onTap ?? onToggleComplete,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.isRecurring || isLocked || pointsEarned != null)
                  _buildTopBadges(context, ext, cs, fgColor),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isLocked) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Tooltip(
                          message: 'Günü Gelince Açılır',
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: fgColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_clock_rounded,
                              color: fgColor.withValues(alpha: 0.85),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ] else if (onToggleComplete != null) ...[
                      IconButton(
                        onPressed: onToggleComplete,
                        icon: Icon(
                          (isCompletedToday || isSelected)
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: isSelected ? ext.lightningYellow : fgColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: fgColor,
                          fontWeight: FontWeight.w800,
                          decoration: (isCompletedToday || isSelected)
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    if (task.isRecurring)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.loop_rounded, color: fgColor, size: 22),
                      ),
                    if (onUncomplete != null)
                      TextButton.icon(
                        onPressed: onUncomplete,
                        icon: Icon(Icons.undo_rounded, size: 16, color: fgColor),
                        label: Text(
                          'Geri Al',
                          style: TextStyle(
                            color: fgColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    if (onDeleteTap != null)
                      IconButton(
                        onPressed: onDeleteTap,
                        icon: Icon(Icons.close_rounded, color: fgColor),
                      ),
                  ],
                ),
                if ((task.timeString != null && task.timeString!.isNotEmpty) ||
                    task.specificDateIso != null ||
                    task.isRecurring) ...[
                  const SizedBox(height: 8),
                  _buildTimeAndDaysRow(context, fgColor),
                ],
                if (completionNote != null && completionNote!.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: fgColor.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 16, color: fgColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            completionNote!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: fgColor,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (onEditNote != null)
                          InkWell(
                            onTap: onEditNote,
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.edit_note_rounded,
                                size: 18,
                                color: fgColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ] else if (isCompletedToday && onEditNote != null) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: onEditNote,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_note_rounded, size: 16, color: fgColor.withValues(alpha: 0.85)),
                          const SizedBox(width: 4),
                          Text(
                            'Seyir Notu Ekle',
                            style: TextStyle(
                              color: fgColor.withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBadges(
    BuildContext context,
    HabitSailorThemeExtension ext,
    ColorScheme cs,
    Color fgColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          if (pointsEarned != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ext.lightningYellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, size: 16, color: ext.onLightningBanner),
                  const SizedBox(width: 4),
                  Text(
                    '+$pointsEarned Puan',
                    style: TextStyle(
                      color: ext.onLightningBanner,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          if (task.isRecurring)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ext.streakNeonColor(task.streakCount),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, size: 16, color: ext.onStreakNeon),
                  const SizedBox(width: 4),
                  Text(
                    '${task.streakCount} Zincir Puanı',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: ext.onStreakNeon,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ),
          if (isLocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.surface.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule_rounded, size: 15, color: fgColor),
                  const SizedBox(width: 4),
                  Text(
                    'Planlandı',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: fgColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeAndDaysRow(BuildContext context, Color fgColor) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (task.timeString != null && task.timeString!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time_filled_rounded, size: 16, color: fgColor),
              const SizedBox(width: 4),
              Text(
                task.timeString!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        if (!task.isRecurring && task.specificDateIso != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_rounded, size: 16, color: fgColor),
              const SizedBox(width: 4),
              Text(
                task.specificDateIso!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          )
        else if (task.isRecurring && task.repeatWeekdays.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.repeat_rounded, size: 16, color: fgColor),
              const SizedBox(width: 4),
              Text(
                'Haftada ${task.repeatWeekdays.length} Gün',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
