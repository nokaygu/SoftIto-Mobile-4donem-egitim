import 'package:flutter/foundation.dart';

/// Tekil bir su tüketim kaydını temsil eden immutable model.
@immutable
class WaterIntakeLog {
  const WaterIntakeLog({
    required this.id,
    required this.amountMl,
    required this.label,
  });

  factory WaterIntakeLog.fromJson(Map<String, dynamic> json) {
    return WaterIntakeLog(
      id: json['id'] as String? ?? '',
      amountMl: (json['amount_ml'] as num?)?.toInt() ?? 0,
      label: json['label'] as String? ?? 'Su',
    );
  }

  final String id;
  final int amountMl;
  final String label;

  WaterIntakeLog copyWith({String? id, int? amountMl, String? label}) {
    return WaterIntakeLog(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'amount_ml': amountMl, 'label': label};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WaterIntakeLog &&
        other.id == id &&
        other.amountMl == amountMl &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(id, amountMl, label);
}

/// Günlük su takip durumunu temsil eden immutable model.
@immutable
class WaterTrackerModel {
  const WaterTrackerModel({
    required this.currentWaterMl,
    required this.dailyGoalMl,
    this.logs = const <WaterIntakeLog>[],
  });

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawLogs =
        json['logs'] as List<dynamic>? ?? const <dynamic>[];
    return WaterTrackerModel(
      currentWaterMl: (json['current_water_ml'] as num?)?.toInt() ?? 0,
      dailyGoalMl: (json['daily_goal_ml'] as num?)?.toInt() ?? 2000,
      logs: rawLogs
          .whereType<Map<String, dynamic>>()
          .map(WaterIntakeLog.fromJson)
          .toList(growable: false),
    );
  }

  final int currentWaterMl;
  final int dailyGoalMl;
  final List<WaterIntakeLog> logs;

  double get progress {
    if (dailyGoalMl <= 0) return 0;
    return (currentWaterMl / dailyGoalMl).clamp(0.0, 1.0);
  }

  int get progressPercent => (progress * 100).round();

  int get remainingWaterMl =>
      (dailyGoalMl - currentWaterMl).clamp(0, dailyGoalMl);

  bool get isGoalReached => currentWaterMl >= dailyGoalMl;

  WaterTrackerModel copyWith({
    int? currentWaterMl,
    int? dailyGoalMl,
    List<WaterIntakeLog>? logs,
  }) {
    return WaterTrackerModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      logs: logs ?? this.logs,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'current_water_ml': currentWaterMl,
      'daily_goal_ml': dailyGoalMl,
      'logs': logs.map((WaterIntakeLog item) => item.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WaterTrackerModel &&
        other.currentWaterMl == currentWaterMl &&
        other.dailyGoalMl == dailyGoalMl &&
        listEquals(other.logs, logs);
  }

  @override
  int get hashCode =>
      Object.hash(currentWaterMl, dailyGoalMl, Object.hashAll(logs));
}
