import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

/// Egzersiz ekleme kartı (Katalog öğesi)
class ExerciseCatalogCard extends StatelessWidget {
  final WorkoutExercise exercise;
  final VoidCallback onAdd;

  const ExerciseCatalogCard({
    super.key,
    required this.exercise,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.borderDark : AppColors.lightBorder;

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(exercise.icon, color: exercise.accentColor, size: 28),
              _buildAddButton(),
            ],
          ),
          const Spacer(),
          Text(
            exercise.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${exercise.calories} kcal',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: exercise.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: onAdd,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: exercise.accentColor.withAlpha(40),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.add, size: 18, color: exercise.accentColor),
      ),
    );
  }
}
