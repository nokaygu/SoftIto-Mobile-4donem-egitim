import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../models/water_tracker_model.dart';

/// Günlük su tüketim ilerlemesini gösteren ana özet kartı.
class WaterTrackerCard extends StatelessWidget {
  const WaterTrackerCard({
    super.key,
    required this.model,
    this.extraWorkoutWaterMl = 0,
  });

  final WaterTrackerModel model;
  final int extraWorkoutWaterMl;

  @override
  Widget build(BuildContext context) {
    final int effectiveGoal = model.dailyGoalMl + extraWorkoutWaterMl;
    final double progress = effectiveGoal > 0
        ? (model.currentWaterMl / effectiveGoal).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _WaterCardHeader(
              currentMl: model.currentWaterMl,
              goalMl: effectiveGoal,
              isGoalReached: model.currentWaterMl >= effectiveGoal,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: progress, minHeight: 12),
            ),
            const SizedBox(height: 12),
            _WaterCardFooter(
              remainingMl: (effectiveGoal - model.currentWaterMl).clamp(
                0,
                effectiveGoal,
              ),
              percent: (progress * 100).round(),
              extraWorkoutWaterMl: extraWorkoutWaterMl,
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterCardHeader extends StatelessWidget {
  const _WaterCardHeader({
    required this.currentMl,
    required this.goalMl,
    required this.isGoalReached,
  });

  final int currentMl;
  final int goalMl;
  final bool isGoalReached;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          isGoalReached ? Icons.verified : Icons.water_drop,
          color: context.colorScheme.primary,
          size: 36,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Günlük Hidrasyon', style: context.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                '$currentMl / $goalMl ml',
                style: context.textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WaterCardFooter extends StatelessWidget {
  const _WaterCardFooter({
    required this.remainingMl,
    required this.percent,
    required this.extraWorkoutWaterMl,
  });

  final int remainingMl;
  final int percent;
  final int extraWorkoutWaterMl;

  @override
  Widget build(BuildContext context) {
    final String statusText = remainingMl == 0
        ? 'Günlük su hedefine ulaştın!'
        : 'Hedefe kalan: $remainingMl ml';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            extraWorkoutWaterMl > 0
                ? '$statusText (+$extraWorkoutWaterMl ml antrenman)'
                : statusText,
            style: context.textTheme.bodyMedium,
          ),
        ),
        Text('%$percent', style: context.textTheme.titleMedium),
      ],
    );
  }
}
