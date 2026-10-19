import 'package:flutter/material.dart';

/// Egzersiz ve aktivite modeli
class WorkoutExercise {
  final String id;
  final String title;
  final String subtitle;
  final int durationMinutes;
  final int calories;
  final IconData icon;
  final Color accentColor;

  const WorkoutExercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.durationMinutes,
    required this.calories,
    required this.icon,
    this.accentColor = const Color(0xFF39FF14),
  });

  WorkoutExercise copyWith({
    String? id,
    String? title,
    String? subtitle,
    int? durationMinutes,
    int? calories,
    IconData? icon,
    Color? accentColor,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      calories: calories ?? this.calories,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      calories: json['calories'] as int? ?? 0,
      icon: Icons.fitness_center,
      accentColor: Color(json['accent_color'] as int? ?? 0xFF39FF14),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'duration_minutes': durationMinutes,
      'calories': calories,
      'accent_color': accentColor.toARGB32(),
    };
  }
}
