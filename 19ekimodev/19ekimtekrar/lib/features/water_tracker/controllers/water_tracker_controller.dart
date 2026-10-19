import 'package:flutter/foundation.dart';

import '../models/water_tracker_model.dart';

/// Su takip durumunu ValueNotifier ile yöneten controller.
class WaterTrackerController {
  WaterTrackerController({this.dailyGoalWater = 2000})
    : currentWater = ValueNotifier<int>(0),
      state = ValueNotifier<WaterTrackerModel>(
        WaterTrackerModel(currentWaterMl: 0, dailyGoalMl: dailyGoalWater),
      );

  final int dailyGoalWater;
  final ValueNotifier<int> currentWater;
  final ValueNotifier<WaterTrackerModel> state;
  int _sequence = 0;

  void addWater([int amountMl = 250, String label = 'Bardak Su']) {
    if (amountMl <= 0) return;
    _sequence += 1;
    final int nextWater = currentWater.value + amountMl;
    final WaterIntakeLog newLog = WaterIntakeLog(
      id: 'water_$_sequence',
      amountMl: amountMl,
      label: label,
    );
    final List<WaterIntakeLog> updatedLogs = <WaterIntakeLog>[
      newLog,
      ...state.value.logs,
    ];
    currentWater.value = nextWater;
    state.value = state.value.copyWith(
      currentWaterMl: nextWater,
      logs: updatedLogs,
    );
  }

  void removeWater([int amountMl = 250]) {
    if (amountMl <= 0 || currentWater.value == 0) return;
    final int nextWater = (currentWater.value - amountMl).clamp(0, 100000);
    final List<WaterIntakeLog> updatedLogs = state.value.logs.isNotEmpty
        ? state.value.logs.sublist(1)
        : const <WaterIntakeLog>[];
    currentWater.value = nextWater;
    state.value = state.value.copyWith(
      currentWaterMl: nextWater,
      logs: updatedLogs,
    );
  }

  void removeLogById(String id) {
    final int index = state.value.logs.indexWhere(
      (WaterIntakeLog item) => item.id == id,
    );
    if (index == -1) return;
    final WaterIntakeLog removed = state.value.logs[index];
    final List<WaterIntakeLog> updatedLogs = List<WaterIntakeLog>.of(
      state.value.logs,
    )..removeAt(index);
    final int nextWater = (currentWater.value - removed.amountMl).clamp(
      0,
      100000,
    );
    currentWater.value = nextWater;
    state.value = state.value.copyWith(
      currentWaterMl: nextWater,
      logs: updatedLogs,
    );
  }

  void resetWater() {
    currentWater.value = 0;
    state.value = state.value.copyWith(
      currentWaterMl: 0,
      logs: const <WaterIntakeLog>[],
    );
  }

  void updateGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    state.value = state.value.copyWith(dailyGoalMl: newGoalMl);
  }

  void dispose() {
    currentWater.dispose();
    state.dispose();
  }
}
