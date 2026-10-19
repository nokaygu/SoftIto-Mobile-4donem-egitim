import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutItem item;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const WorkoutCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: item.isCompleted
          ? AppColors.surfaceElevated.withAlpha(120)
          : AppColors.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _WorkoutIconBadge(
          icon: item.icon,
          isCompleted: item.isCompleted,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: item.isCompleted
                ? AppColors.textMuted
                : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            decoration:
                item.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: _WorkoutSubtitle(
          duration: item.durationMinutes,
          calories: item.caloriesBurned,
        ),
        trailing: _WorkoutCardActions(
          isCompleted: item.isCompleted,
          onToggle: onToggle,
          onRemove: onRemove,
        ),
      ),
    );
  }
}

class _WorkoutIconBadge extends StatelessWidget {
  final IconData icon;
  final bool isCompleted;

  const _WorkoutIconBadge({
    required this.icon,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isCompleted
          ? AppColors.neonGreen.withAlpha(30)
          : AppColors.neonCyan.withAlpha(30),
      child: Icon(
        icon,
        color: isCompleted ? AppColors.neonGreen : AppColors.neonCyan,
        size: 22,
      ),
    );
  }
}

class _WorkoutCardActions extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _WorkoutCardActions({
    required this.isCompleted,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: isCompleted,
          activeColor: AppColors.neonGreen,
          checkColor: AppColors.background,
          onChanged: (_) => onToggle(),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          color: Colors.redAccent.withAlpha(200),
          tooltip: 'Egzersizi Sil',
          onPressed: onRemove,
        ),
      ],
    );
  }
}

class _WorkoutSubtitle extends StatelessWidget {
  final int duration;
  final int calories;

  const _WorkoutSubtitle({
    required this.duration,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$duration dk • $calories kcal',
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    );
  }
}
