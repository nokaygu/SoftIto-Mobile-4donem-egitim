import 'package:flutter/foundation.dart';

import '../models/workout_model.dart';

/// Egzersiz ve kalori takip durumunu ValueNotifier ile yöneten controller.
class WorkoutController {
  WorkoutController({List<WorkoutModel>? initialWorkouts})
    : workouts = ValueNotifier<List<WorkoutModel>>(
        initialWorkouts ?? _defaultActiveWorkouts,
      );

  static const List<WorkoutModel> presetWorkouts = <WorkoutModel>[
    WorkoutModel(
      id: 'run_30',
      title: 'Tempolu Koşu',
      category: 'Kardiyo',
      durationMinutes: 30,
      caloriesBurned: 320,
      waterNeedMl: 350,
      iconName: 'directions_run',
    ),
    WorkoutModel(
      id: 'strength_45',
      title: 'Ağırlık Antrenmanı',
      category: 'Güç',
      durationMinutes: 45,
      caloriesBurned: 280,
      waterNeedMl: 300,
      iconName: 'fitness_center',
    ),
    WorkoutModel(
      id: 'cycling_40',
      title: 'Bisiklet Turu',
      category: 'Kardiyo',
      durationMinutes: 40,
      caloriesBurned: 360,
      waterNeedMl: 400,
      iconName: 'directions_bike',
    ),
    WorkoutModel(
      id: 'swim_30',
      title: 'Yüzme Seansı',
      category: 'Tam Vücut',
      durationMinutes: 30,
      caloriesBurned: 340,
      waterNeedMl: 250,
      iconName: 'pool',
    ),
    WorkoutModel(
      id: 'hiit_20',
      title: 'HIIT & Boks',
      category: 'Yüksek Yoğunluk',
      durationMinutes: 20,
      caloriesBurned: 290,
      waterNeedMl: 350,
      iconName: 'sports_mma',
    ),
    WorkoutModel(
      id: 'yoga_30',
      title: 'Mobilite & Yoga',
      category: 'Esneklik',
      durationMinutes: 30,
      caloriesBurned: 140,
      waterNeedMl: 150,
      iconName: 'self_improvement',
    ),
  ];

  static final List<WorkoutModel> _defaultActiveWorkouts = <WorkoutModel>[
    presetWorkouts[0],
    presetWorkouts[1],
  ];

  final ValueNotifier<List<WorkoutModel>> workouts;

  int get totalCaloriesBurned => workouts.value.fold<int>(
    0,
    (int sum, WorkoutModel item) => sum + item.totalCalories,
  );

  int get totalDurationMinutes => workouts.value.fold<int>(
    0,
    (int sum, WorkoutModel item) => sum + item.totalDurationMinutes,
  );

  int get totalExtraWaterNeedMl => workouts.value.fold<int>(
    0,
    (int sum, WorkoutModel item) => sum + item.totalWaterNeedMl,
  );

  void addOrIncrementWorkout(WorkoutModel workout) {
    final List<WorkoutModel> current = List<WorkoutModel>.of(workouts.value);
    final int index = current.indexWhere(
      (WorkoutModel item) => item.id == workout.id,
    );
    if (index != -1) {
      final WorkoutModel existing = current[index];
      current[index] = existing.copyWith(
        sessionCount: existing.sessionCount + 1,
      );
    } else {
      current.add(workout.copyWith(sessionCount: 1));
    }
    workouts.value = List<WorkoutModel>.unmodifiable(current);
  }

  void decrementOrRemoveWorkout(String id) {
    final List<WorkoutModel> current = List<WorkoutModel>.of(workouts.value);
    final int index = current.indexWhere((WorkoutModel item) => item.id == id);
    if (index == -1) return;

    final WorkoutModel existing = current[index];
    if (existing.sessionCount > 1) {
      current[index] = existing.copyWith(
        sessionCount: existing.sessionCount - 1,
      );
    } else {
      current.removeAt(index);
    }
    workouts.value = List<WorkoutModel>.unmodifiable(current);
  }

  void removeWorkout(String id) {
    final List<WorkoutModel> updated = workouts.value
        .where((WorkoutModel item) => item.id != id)
        .toList(growable: false);
    workouts.value = updated;
  }

  void clearWorkouts() {
    workouts.value = const <WorkoutModel>[];
  }

  void dispose() {
    workouts.dispose();
  }
}
