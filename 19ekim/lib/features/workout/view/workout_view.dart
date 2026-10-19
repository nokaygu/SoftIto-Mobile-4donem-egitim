import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_header_title.dart';
import '../controller/workout_controller.dart';
import '../models/workout_model.dart';
import '../widget/add_workout_sheet.dart';
import '../widget/workout_card.dart';
import '../widget/workout_summary_card.dart';

class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  void _showAddModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddWorkoutSheet(
        onAdd: (title, duration, calories, icon) =>
            controller.addWorkout(title, duration, calories, icon: icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppHeaderTitle(subtitle: 'Egzersiz & Kalori'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Egzersiz Ekle',
            onPressed: () => _showAddModal(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_workout_fab',
        backgroundColor: AppColors.neonCyan,
        foregroundColor: AppColors.background,
        onPressed: () => _showAddModal(context),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder<WorkoutState>(
        valueListenable: controller,
        builder: (context, state, _) {
          return _WorkoutBody(
            state: state,
            controller: controller,
          );
        },
      ),
    );
  }
}

class _WorkoutBody extends StatelessWidget {
  final WorkoutState state;
  final WorkoutController controller;

  const _WorkoutBody({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      children: [
        WorkoutSummaryCard(
          totalCalories: state.totalCaloriesBurned,
          totalMinutes: state.totalMinutes,
          completedCount: state.completedCount,
        ),
        const SizedBox(height: 20),
        const _WorkoutSectionHeader(),
        const SizedBox(height: 12),
        if (state.workouts.isEmpty)
          const _EmptyWorkoutNotice()
        else
          ...state.workouts.map(
            (item) => WorkoutCard(
              item: item,
              onToggle: () => controller.toggleCompletion(item.id),
              onRemove: () => controller.removeWorkout(item.id),
            ),
          ),
      ],
    );
  }
}

class _WorkoutSectionHeader extends StatelessWidget {
  const _WorkoutSectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Günün Egzersiz Programı',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _EmptyWorkoutNotice extends StatelessWidget {
  const _EmptyWorkoutNotice();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Text(
          'Henüz egzersiz kartı yok.\n+ butonuna basarak ekleyebilirsin!',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ),
    );
  }
}
