import 'package:flutter/foundation.dart';
import '../models/water_record_model.dart';

/// Su takip iş mantığı ve reaktif durum yönetimi
class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final ValueNotifier<List<WaterRecord>> records =
      ValueNotifier<List<WaterRecord>>(<WaterRecord>[]);

  final int dailyGoalWater = 2500; // 2.5 Litre günlük hedef

  double get progress =>
      (currentWater.value / dailyGoalWater).clamp(0.0, 1.0);

  int get remainingWater =>
      (dailyGoalWater - currentWater.value).clamp(0, dailyGoalWater);

  void addWater([int amount = 250, String note = 'Hızlı Ekleme']) {
    final int newTotal = currentWater.value + amount;
    currentWater.value = newTotal;

    final newRecord = WaterRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: amount,
      timestamp: DateTime.now(),
      note: note,
    );

    records.value = [newRecord, ...records.value];
  }

  void resetWater() {
    currentWater.value = 0;
    records.value = <WaterRecord>[];
  }

  void removeRecord(String id) {
    final recordToRemove =
        records.value.cast<WaterRecord?>().firstWhere(
              (r) => r?.id == id,
              orElse: () => null,
            );

    if (recordToRemove != null) {
      currentWater.value =
          (currentWater.value - recordToRemove.amountMl).clamp(0, 99999);
      records.value = records.value.where((r) => r.id != id).toList();
    }
  }

  void dispose() {
    currentWater.dispose();
    records.dispose();
  }
}
