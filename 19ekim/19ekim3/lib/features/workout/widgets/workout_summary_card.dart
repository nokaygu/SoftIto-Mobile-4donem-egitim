import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Egzersiz ve yakılan kalori özet paneli
class WorkoutSummaryCard extends StatelessWidget {
  final int totalCalories;
  final int totalMinutes;
  final int count;

  const WorkoutSummaryCard({
    super.key,
    required this.totalCalories,
    required this.totalMinutes,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? AppColors.cardSurface : AppColors.lightCardSurface;
    final borderColor =
        isDark ? AppColors.neonLime.withAlpha(80) : AppColors.lightBorder;
    final shadowColor =
        isDark ? const Color(0x1F39FF14) : const Color(0x1016A34A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(
            context,
            'Yakılan',
            '$totalCalories',
            'kcal',
            AppColors.neonCoral,
            Icons.local_fire_department,
          ),
          _buildDivider(context),
          _buildStat(
            context,
            'Süre',
            '$totalMinutes',
            'dk',
            isDark ? AppColors.neonLime : AppColors.lightSecondary,
            Icons.timer_outlined,
          ),
          _buildDivider(context),
          _buildStat(
            context,
            'Egzersiz',
            '$count',
            'adet',
            isDark ? AppColors.neonCyan : AppColors.lightPrimary,
            Icons.fitness_center,
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    String unit,
    Color color,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unitColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final labelColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            children: [
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: unitColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: labelColor),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 1,
      height: 38,
      color: isDark ? AppColors.borderDark : AppColors.lightBorder,
    );
  }
}
