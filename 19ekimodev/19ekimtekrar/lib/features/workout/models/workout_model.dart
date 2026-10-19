import 'package:flutter/material.dart';

/// Egzersiz ve kalori bilgisini temsil eden immutable model.
@immutable
class WorkoutModel {
  const WorkoutModel({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.waterNeedMl,
    required this.iconName,
    this.sessionCount = 1,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['calories_burned'] as num?)?.toInt() ?? 0,
      waterNeedMl: (json['water_need_ml'] as num?)?.toInt() ?? 0,
      iconName: json['icon_name'] as String? ?? 'fitness_center',
      sessionCount: (json['session_count'] as num?)?.toInt() ?? 1,
    );
  }

  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final int caloriesBurned;
  final int waterNeedMl;
  final String iconName;
  final int sessionCount;

  int get totalCalories => caloriesBurned * sessionCount;
  int get totalDurationMinutes => durationMinutes * sessionCount;
  int get totalWaterNeedMl => waterNeedMl * sessionCount;

  IconData get iconData {
    switch (iconName) {
      case 'directions_run':
        return Icons.directions_run;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'pool':
        return Icons.pool;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'sports_mma':
        return Icons.sports_mma;
      case 'fitness_center':
      default:
        return Icons.fitness_center;
    }
  }

  WorkoutModel copyWith({
    String? id,
    String? title,
    String? category,
    int? durationMinutes,
    int? caloriesBurned,
    int? waterNeedMl,
    String? iconName,
    int? sessionCount,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      waterNeedMl: waterNeedMl ?? this.waterNeedMl,
      iconName: iconName ?? this.iconName,
      sessionCount: sessionCount ?? this.sessionCount,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
      'water_need_ml': waterNeedMl,
      'icon_name': iconName,
      'session_count': sessionCount,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutModel &&
        other.id == id &&
        other.title == title &&
        other.category == category &&
        other.durationMinutes == durationMinutes &&
        other.caloriesBurned == caloriesBurned &&
        other.waterNeedMl == waterNeedMl &&
        other.iconName == iconName &&
        other.sessionCount == sessionCount;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    durationMinutes,
    caloriesBurned,
    waterNeedMl,
    iconName,
    sessionCount,
  );
}
