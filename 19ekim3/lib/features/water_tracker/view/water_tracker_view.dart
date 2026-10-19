import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_record_model.dart';
import '../widgets/water_gauge_card.dart';
import '../widgets/water_quick_buttons.dart';
import '../widgets/water_record_tile.dart';

/// Su takip ekranı - Clean UI & ValueNotifier tabanlı
class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        _buildGaugeSection(),
        const SizedBox(height: 20),
        WaterQuickButtons(
          onAdd: (amount) => controller.addWater(amount),
          onReset: controller.resetWater,
        ),
        const SizedBox(height: 24),
        _buildRecordsSection(),
      ],
    );
  }

  Widget _buildGaugeSection() {
    return ValueListenableBuilder<int>(
      valueListenable: controller.currentWater,
      builder: (context, current, _) {
        return WaterGaugeCard(
          currentWater: current,
          dailyGoal: controller.dailyGoalWater,
        );
      },
    );
  }

  Widget _buildRecordsSection() {
    return ValueListenableBuilder<List<WaterRecord>>(
      valueListenable: controller.records,
      builder: (context, records, _) {
        if (records.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Henüz kayıt yok. Su içtikçe ekleyebilirsin!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bugünün Kayıtları',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...records.map(
              (r) => WaterRecordTile(
                record: r,
                onDelete: () => controller.removeRecord(r.id),
              ),
            ),
          ],
        );
      },
    );
  }
}
