import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Toplam yakılan kalori, süre ve ek su ihtiyacını gösteren özet kartı.
class WorkoutSummaryBanner extends StatelessWidget {
  const WorkoutSummaryBanner({
    super.key,
    required this.totalCalories,
    required this.totalMinutes,
    required this.extraWaterMl,
  });

  final int totalCalories;
  final int totalMinutes;
  final int extraWaterMl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _MetricItem(
              icon: Icons.local_fire_department,
              value: '$totalCalories kcal',
              label: 'Yakılan Kalori',
              color: context.colorScheme.tertiary,
            ),
            _MetricItem(
              icon: Icons.timer_outlined,
              value: '$totalMinutes dk',
              label: 'Toplam Süre',
              color: context.colorScheme.secondary,
            ),
            _MetricItem(
              icon: Icons.water_drop_outlined,
              value: '+$extraWaterMl ml',
              label: 'Ek Su İhtiyacı',
              color: context.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(value, style: context.textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(label, style: context.textTheme.labelMedium),
      ],
    );
  }
}
