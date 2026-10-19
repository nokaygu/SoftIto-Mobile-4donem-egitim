import 'package:flutter/foundation.dart';
import '../models/water_model.dart';

class WaterController extends ValueNotifier<WaterModel> {
  WaterController({WaterModel? initialModel})
      : super(initialModel ?? const WaterModel());

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    final updatedLogs = [
      WaterLog(timestamp: DateTime.now(), amountMl: amountMl),
      ...value.logs,
    ];
    value = value.copyWith(
      consumedMl: value.consumedMl + amountMl,
      logs: updatedLogs,
    );
  }

  void resetToday() {
    value = value.copyWith(
      consumedMl: 0,
      logs: const [],
    );
  }

  void updateDailyGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    value = value.copyWith(dailyGoalMl: newGoalMl);
  }
}
