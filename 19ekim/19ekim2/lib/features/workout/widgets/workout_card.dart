import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

/// Egzersiz kartı (İkonlu cardbox, detaylar ve çıkarma butonu)
class WorkoutCard extends StatelessWidget {
  final WorkoutExercise workout;
  final VoidCallback onRemove;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? AppColors.cardSurface : AppColors.lightCardSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: workout.accentColor.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: workout.accentColor.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIconBox(),
          const SizedBox(width: 14),
          Expanded(child: _buildDetails(context)),
          _buildRemoveButton(context),
        ],
      ),
    );
  }

  Widget _buildIconBox() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: workout.accentColor.withAlpha(35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(workout.icon, color: workout.accentColor, size: 26),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workout.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${workout.durationMinutes} dk  •  ${workout.calories} kcal',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: workout.accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? AppColors.surface : AppColors.lightSurfaceElevated;
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: btnBg,
        foregroundColor: AppColors.neonCoral,
      ),
      icon: const Icon(Icons.delete_outline, size: 20),
      onPressed: onRemove,
      tooltip: 'Egzersizi Çıkar',
    );
  }
}
