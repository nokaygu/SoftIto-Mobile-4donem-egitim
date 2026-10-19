import 'package:flutter/material.dart';

@immutable
class WorkoutItem {
  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final bool isCompleted;
  final IconData icon;

  const WorkoutItem({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.isCompleted = false,
    this.icon = Icons.fitness_center,
  });

  WorkoutItem copyWith({
    String? id,
    String? title,
    int? durationMinutes,
    int? caloriesBurned,
    bool? isCompleted,
    IconData? icon,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      isCompleted: isCompleted ?? this.isCompleted,
      icon: icon ?? this.icon,
    );
  }
}

@immutable
class WorkoutState {
  final List<WorkoutItem> workouts;

  const WorkoutState({this.workouts = const []});

  int get totalCaloriesBurned => workouts
      .where((w) => w.isCompleted)
      .fold(0, (sum, w) => sum + w.caloriesBurned);

  int get totalMinutes => workouts
      .where((w) => w.isCompleted)
      .fold(0, (sum, w) => sum + w.durationMinutes);

  int get completedCount => workouts.where((w) => w.isCompleted).length;

  WorkoutState copyWith({List<WorkoutItem>? workouts}) {
    return WorkoutState(workouts: workouts ?? this.workouts);
  }
}
