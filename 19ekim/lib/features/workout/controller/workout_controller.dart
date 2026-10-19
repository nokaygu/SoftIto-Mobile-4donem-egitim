import 'package:flutter/material.dart';
import '../models/workout_model.dart';

class WorkoutController extends ValueNotifier<WorkoutState> {
  WorkoutController({WorkoutState? initialState})
      : super(initialState ?? _defaultWorkouts);

  static const WorkoutState _defaultWorkouts = WorkoutState(
    workouts: [
      WorkoutItem(
        id: '1',
        title: 'HIIT Kardiyo & Isınma',
        durationMinutes: 20,
        caloriesBurned: 180,
        icon: Icons.directions_run,
      ),
      WorkoutItem(
        id: '2',
        title: 'Ağırlık & Hipertrofi',
        durationMinutes: 45,
        caloriesBurned: 320,
        icon: Icons.fitness_center,
      ),
      WorkoutItem(
        id: '3',
        title: 'Spinning & Bisiklet',
        durationMinutes: 25,
        caloriesBurned: 210,
        icon: Icons.pedal_bike,
      ),
    ],
  );

  void toggleCompletion(String id) {
    final updatedList = value.workouts.map((w) {
      if (w.id == id) {
        return w.copyWith(isCompleted: !w.isCompleted);
      }
      return w;
    }).toList();
    value = value.copyWith(workouts: updatedList);
  }

  void addWorkout(
    String title,
    int duration,
    int calories, {
    IconData icon = Icons.fitness_center,
  }) {
    final newItem = WorkoutItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: duration,
      caloriesBurned: calories,
      icon: icon,
    );
    value = value.copyWith(workouts: [...value.workouts, newItem]);
  }

  void removeWorkout(String id) {
    final updatedList = value.workouts.where((w) => w.id != id).toList();
    value = value.copyWith(workouts: updatedList);
  }
}
