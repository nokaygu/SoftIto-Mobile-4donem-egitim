import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/water_intake_history_list.dart';
import '../widgets/water_quick_actions.dart';
import '../widgets/water_tracker_card.dart';

/// Su takip ekranı (StatelessWidget + ValueListenableBuilder).
class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({
    super.key,
    required this.controller,
    this.extraWorkoutWaterMl = 0,
  });

  final WaterTrackerController controller;
  final int extraWorkoutWaterMl;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WaterTrackerModel>(
      valueListenable: controller.state,
      builder: (BuildContext context, WaterTrackerModel model, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            WaterTrackerCard(
              model: model,
              extraWorkoutWaterMl: extraWorkoutWaterMl,
            ),
            const SizedBox(height: 16),
            WaterQuickActions(
              onAdd200: () => controller.addWater(200, 'Kupa Su (200 ml)'),
              onAdd250: () => controller.addWater(250, 'Bardak Su (250 ml)'),
              onAdd500: () => controller.addWater(500, 'Matara Su (500 ml)'),
              onRemove250: () => controller.removeWater(250),
              onReset: controller.resetWater,
            ),
            const SizedBox(height: 20),
            Text('Bugünkü Su Kayıtları', style: context.textTheme.titleMedium),
            const SizedBox(height: 8),
            WaterIntakeHistoryList(
              logs: model.logs,
              onRemoveLog: controller.removeLogById,
            ),
          ],
        );
      },
    );
  }
}
