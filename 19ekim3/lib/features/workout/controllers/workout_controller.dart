import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

/// Egzersiz ve kalori takip iş mantığı
class WorkoutController {
  final ValueNotifier<List<WorkoutExercise>> activeWorkouts =
      ValueNotifier<List<WorkoutExercise>>(<WorkoutExercise>[]);

  final ValueNotifier<int> totalCalories = ValueNotifier<int>(0);
  final ValueNotifier<int> totalMinutes = ValueNotifier<int>(0);

  static const List<WorkoutExercise> availableCatalog = [
    WorkoutExercise(
      id: 'run',
      title: 'Açık Hava Koşusu',
      subtitle: 'Kardiyo & Dayanıklılık',
      durationMinutes: 30,
      calories: 280,
      icon: Icons.directions_run,
      accentColor: AppColors.neonLime,
    ),
    WorkoutExercise(
      id: 'gym',
      title: 'Ağırlık Antrenmanı',
      subtitle: 'Hipertrofi & Güç',
      durationMinutes: 45,
      calories: 320,
      icon: Icons.fitness_center,
      accentColor: AppColors.neonCyan,
    ),
    WorkoutExercise(
      id: 'bike',
      title: 'Kondisyon Bisikleti',
      subtitle: 'Bacak & Kondisyon',
      durationMinutes: 25,
      calories: 210,
      icon: Icons.directions_bike,
      accentColor: AppColors.neonCoral,
    ),
    WorkoutExercise(
      id: 'hiit',
      title: 'HIIT Fonksiyonel',
      subtitle: 'Patlayıcı Güç',
      durationMinutes: 20,
      calories: 240,
      icon: Icons.bolt,
      accentColor: AppColors.neonAmber,
    ),
    WorkoutExercise(
      id: 'rope',
      title: 'İp Atlama',
      subtitle: 'Çeviklik & Isınma',
      durationMinutes: 15,
      calories: 160,
      icon: Icons.sports_gymnastics,
      accentColor: AppColors.neonLime,
    ),
  ];

  void addWorkout(WorkoutExercise template) {
    final newWorkout = template.copyWith(
      id: '${template.id}_${DateTime.now().millisecondsSinceEpoch}',
    );

    activeWorkouts.value = [newWorkout, ...activeWorkouts.value];
    _recalculateTotals();
  }

  void removeWorkout(String id) {
    activeWorkouts.value =
        activeWorkouts.value.where((w) => w.id != id).toList();
    _recalculateTotals();
  }

  void clearAll() {
    activeWorkouts.value = <WorkoutExercise>[];
    _recalculateTotals();
  }

  void _recalculateTotals() {
    int cals = 0;
    int mins = 0;
    for (final item in activeWorkouts.value) {
      cals += item.calories;
      mins += item.durationMinutes;
    }
    totalCalories.value = cals;
    totalMinutes.value = mins;
  }

  void dispose() {
    activeWorkouts.dispose();
    totalCalories.dispose();
    totalMinutes.dispose();
  }
}
