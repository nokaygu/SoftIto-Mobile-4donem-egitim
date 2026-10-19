import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/workout_card.dart';
import '../widgets/workout_preset_selector.dart';
import '../widgets/workout_summary_banner.dart';

/// Egzersiz ve kalori takip ekranı (StatelessWidget + ValueListenableBuilder).
class WorkoutView extends StatelessWidget {
  const WorkoutView({super.key, required this.controller});

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WorkoutModel>>(
      valueListenable: controller.workouts,
      builder: (BuildContext context, List<WorkoutModel> items, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            WorkoutSummaryBanner(
              totalCalories: controller.totalCaloriesBurned,
              totalMinutes: controller.totalDurationMinutes,
              extraWaterMl: controller.totalExtraWaterNeedMl,
            ),
            const SizedBox(height: 16),
            WorkoutPresetSelector(
              presets: WorkoutController.presetWorkouts,
              onSelectPreset: controller.addOrIncrementWorkout,
            ),
            const SizedBox(height: 20),
            _WorkoutListHeader(
              hasItems: items.isNotEmpty,
              onClearAll: controller.clearWorkouts,
            ),
            const SizedBox(height: 8),
            _ActiveWorkoutsSection(items: items, controller: controller),
          ],
        );
      },
    );
  }
}

class _WorkoutListHeader extends StatelessWidget {
  const _WorkoutListHeader({required this.hasItems, required this.onClearAll});

  final bool hasItems;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Aktif Egzersiz Kartları', style: context.textTheme.titleMedium),
        if (hasItems)
          TextButton.icon(
            key: const Key('clear_workouts_btn'),
            onPressed: onClearAll,
            icon: const Icon(Icons.clear_all, size: 18),
            label: const Text('Tümünü Temizle'),
          ),
      ],
    );
  }
}

class _ActiveWorkoutsSection extends StatelessWidget {
  const _ActiveWorkoutsSection({required this.items, required this.controller});

  final List<WorkoutModel> items;
  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Aktif egzersiz bulunmuyor. Yukarıdaki egzersiz butonlarına dokunarak ekleyebilirsin.',
            style: context.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      children: items
          .map(
            (WorkoutModel workout) => WorkoutCard(
              key: ValueKey<String>(workout.id),
              workout: workout,
              onIncrement: () => controller.addOrIncrementWorkout(workout),
              onDecrement: () =>
                  controller.decrementOrRemoveWorkout(workout.id),
              onDelete: () => controller.removeWorkout(workout.id),
            ),
          )
          .toList(growable: false),
    );
  }
}
