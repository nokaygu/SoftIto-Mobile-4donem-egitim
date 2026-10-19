import 'package:flutter/material.dart';
import '../../../core/widgets/app_header_title.dart';
import '../controller/water_controller.dart';
import '../models/water_model.dart';
import '../widget/daily_goal_card.dart';
import '../widget/quick_add_buttons.dart';
import '../widget/water_progress_indicator.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppHeaderTitle(subtitle: 'Su Takibi'),
      ),
      body: ValueListenableBuilder<WaterModel>(
        valueListenable: controller,
        builder: (context, model, _) {
          return _WaterTrackerBody(
            model: model,
            controller: controller,
          );
        },
      ),
    );
  }
}

class _WaterTrackerBody extends StatelessWidget {
  final WaterModel model;
  final WaterController controller;

  const _WaterTrackerBody({
    required this.model,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          DailyGoalCard(
            remainingMl: model.remainingMl,
            isGoalReached: model.isGoalReached,
            onReset: controller.resetToday,
          ),
          const SizedBox(height: 32),
          WaterProgressIndicator(
            progress: model.progressPercentage,
            consumedMl: model.consumedMl,
            goalMl: model.dailyGoalMl,
          ),
          const SizedBox(height: 36),
          QuickAddButtons(
            onAddWater: controller.addWater,
          ),
        ],
      ),
    );
  }
}
