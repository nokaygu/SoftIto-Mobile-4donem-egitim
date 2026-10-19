import 'package:flutter/foundation.dart';

@immutable
class WaterLog {
  final DateTime timestamp;
  final int amountMl;

  const WaterLog({
    required this.timestamp,
    required this.amountMl,
  });
}

@immutable
class WaterModel {
  final int dailyGoalMl;
  final int consumedMl;
  final List<WaterLog> logs;

  const WaterModel({
    this.dailyGoalMl = 2500,
    this.consumedMl = 0,
    this.logs = const [],
  });

  double get progressPercentage {
    if (dailyGoalMl == 0) return 0.0;
    final progress = consumedMl / dailyGoalMl;
    return progress > 1.0 ? 1.0 : progress;
  }

  int get remainingMl {
    final remaining = dailyGoalMl - consumedMl;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isGoalReached => consumedMl >= dailyGoalMl;

  WaterModel copyWith({
    int? dailyGoalMl,
    int? consumedMl,
    List<WaterLog>? logs,
  }) {
    return WaterModel(
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      consumedMl: consumedMl ?? this.consumedMl,
      logs: logs ?? this.logs,
    );
  }
}
