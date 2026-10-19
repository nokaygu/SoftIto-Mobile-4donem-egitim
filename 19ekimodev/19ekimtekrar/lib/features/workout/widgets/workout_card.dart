import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

/// Egzersiz ikonu, kalori/süre bilgisi ve ekleme/çıkarma butonları içeren CardBox.
class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  final WorkoutModel workout;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: <Widget>[
            _WorkoutIconBadge(iconData: workout.iconData),
            const SizedBox(width: 12),
            Expanded(child: _WorkoutDetails(workout: workout)),
            _WorkoutCardActions(
              workoutId: workout.id,
              sessionCount: workout.sessionCount,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutIconBadge extends StatelessWidget {
  const _WorkoutIconBadge({required this.iconData});

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: context.colorScheme.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: context.colorScheme.secondary, size: 26),
    );
  }
}

class _WorkoutDetails extends StatelessWidget {
  const _WorkoutDetails({required this.workout});

  final WorkoutModel workout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(workout.title, style: context.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          '${workout.category} • ${workout.totalDurationMinutes} dk • '
          '${workout.totalCalories} kcal',
          style: context.textTheme.bodyMedium,
        ),
        const SizedBox(height: 2),
        Text(
          'Ek su ihtiyacı: +${workout.totalWaterNeedMl} ml',
          style: context.textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _WorkoutCardActions extends StatelessWidget {
  const _WorkoutCardActions({
    required this.workoutId,
    required this.sessionCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  final String workoutId;
  final int sessionCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          key: Key('decrement_$workoutId'),
          onPressed: onDecrement,
          tooltip: 'Azalt / Çıkar',
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('${sessionCount}x', style: context.textTheme.titleMedium),
        IconButton(
          key: Key('increment_$workoutId'),
          onPressed: onIncrement,
          tooltip: 'Set Ekle',
          icon: Icon(
            Icons.add_circle_outline,
            color: context.colorScheme.secondary,
          ),
        ),
        IconButton(
          key: Key('delete_$workoutId'),
          onPressed: onDelete,
          tooltip: 'Kaldır',
          icon: Icon(Icons.delete_outline, color: context.colorScheme.error),
        ),
      ],
    );
  }
}
