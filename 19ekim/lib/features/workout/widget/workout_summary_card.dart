import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final int totalCalories;
  final int totalMinutes;
  final int completedCount;

  const WorkoutSummaryCard({
    super.key,
    required this.totalCalories,
    required this.totalMinutes,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryStatItem(
              label: 'Yakılan Kalori',
              value: '$totalCalories kcal',
              icon: Icons.local_fire_department,
              accentColor: AppColors.neonOrange,
            ),
            const _StatDivider(),
            _SummaryStatItem(
              label: 'Süre',
              value: '$totalMinutes dk',
              icon: Icons.timer_outlined,
              accentColor: AppColors.neonCyan,
            ),
            const _StatDivider(),
            _SummaryStatItem(
              label: 'Tamamlanan',
              value: '$completedCount egzersiz',
              icon: Icons.fitness_center,
              accentColor: AppColors.neonGreen,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _SummaryStatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: accentColor, size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.surfaceBorder,
    );
  }
}
