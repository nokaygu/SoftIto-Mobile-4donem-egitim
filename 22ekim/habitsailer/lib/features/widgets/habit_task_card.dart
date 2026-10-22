import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/habit_task_model.dart';

class HabitTaskCard extends StatelessWidget {
  final HabitTaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDeleteTap;
  final bool isCompletedToday;

  const HabitTaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onDeleteTap,
    this.isCompletedToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailerThemeExtension>()!;

    final bgColor = ext.difficultyBackground(task.difficulty);
    final fgColor = ext.difficultyForeground(task.difficulty);
    final borderColor = ext.difficultyBorder(task.difficulty);
    final isUrgentNavy = task.difficulty == 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isUrgentNavy ? 2.2 : 1.5),
        boxShadow: [
          BoxShadow(
            color: isUrgentNavy ? ext.deepNavyShadow : cs.outlineVariant,
            blurRadius: isUrgentNavy ? 16 : 8,
            offset: Offset(0, isUrgentNavy ? 7 : 3),
          ),
        ],
      ),
      child: Material(
        color: cs.surface.withValues(alpha: 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.isRecurring) _buildStreakRow(context, ext),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (onToggleComplete != null) ...[
                      IconButton(
                        onPressed: onToggleComplete,
                        icon: Icon(
                          isCompletedToday
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: fgColor,
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
                          decoration: isCompletedToday ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    if (task.isRecurring)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.loop_rounded, color: fgColor, size: 22),
                      ),
                    if (onDeleteTap != null)
                      IconButton(
                        onPressed: onDeleteTap,
                        icon: Icon(Icons.close_rounded, color: fgColor),
                      ),
                  ],
                ),
                if (task.timeString != null && task.timeString!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildTimeAndDaysRow(context, fgColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakRow(
    BuildContext context,
    HabitSailerThemeExtension ext,
  ) {
    final streakColor = ext.streakNeonColor(task.streakCount);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: streakColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, size: 16, color: ext.onStreakNeon),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${task.streakCount} Zincir Puanı',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: ext.onStreakNeon,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAndDaysRow(BuildContext context, Color fgColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.access_time_filled_rounded, size: 16, color: fgColor),
        Text(
          task.timeString!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: fgColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
