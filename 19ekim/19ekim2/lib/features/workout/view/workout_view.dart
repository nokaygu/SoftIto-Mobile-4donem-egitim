import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/exercise_catalog_card.dart';
import '../widgets/workout_card.dart';
import '../widgets/workout_summary_card.dart';

/// Egzersiz ve kalori takip ekranı - ValueNotifier mimarisi
class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        _buildSummary(),
        const SizedBox(height: 24),
        _buildCatalogSection(),
        const SizedBox(height: 24),
        _buildActiveWorkoutsSection(),
      ],
    );
  }

  Widget _buildSummary() {
    return ValueListenableBuilder<List<WorkoutExercise>>(
      valueListenable: controller.activeWorkouts,
      builder: (context, workouts, _) {
        return ValueListenableBuilder<int>(
          valueListenable: controller.totalCalories,
          builder: (context, cals, _) {
            return ValueListenableBuilder<int>(
              valueListenable: controller.totalMinutes,
              builder: (context, mins, _) {
                return WorkoutSummaryCard(
                  totalCalories: cals,
                  totalMinutes: mins,
                  count: workouts.length,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCatalogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Egzersiz Ekle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: WorkoutController.availableCatalog.length,
            itemBuilder: (context, index) {
              final item = WorkoutController.availableCatalog[index];
              return ExerciseCatalogCard(
                exercise: item,
                onAdd: () => controller.addWorkout(item),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActiveWorkoutsSection() {
    return ValueListenableBuilder<List<WorkoutExercise>>(
      valueListenable: controller.activeWorkouts,
      builder: (context, workouts, _) {
        if (workouts.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Tamamlanan egzersiz yok. Yukarıdan ekleyebilirsin!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bugünkü Egzersizlerin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: controller.clearAll,
                  child: const Text('Temizle'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...workouts.map(
              (w) => WorkoutCard(
                workout: w,
                onRemove: () => controller.removeWorkout(w.id),
              ),
            ),
          ],
        );
      },
    );
  }
}
