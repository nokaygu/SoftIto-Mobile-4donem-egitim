import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/app_theme.dart';
import 'package:susadim/features/workout/controllers/workout_controller.dart';
import 'package:susadim/features/workout/models/workout_model.dart';
import 'package:susadim/features/workout/view/workout_view.dart';

void main() {
  group('WorkoutModel Unit Tests', () {
    test('copyWith, toJson ve fromJson doğru çalışmalı', () {
      const WorkoutModel model = WorkoutModel(
        id: 'run_30',
        title: 'Tempolu Koşu',
        category: 'Kardiyo',
        durationMinutes: 30,
        caloriesBurned: 320,
        waterNeedMl: 350,
        iconName: 'directions_run',
        sessionCount: 2,
      );

      final Map<String, dynamic> json = model.toJson();
      final WorkoutModel fromJson = WorkoutModel.fromJson(json);

      expect(fromJson, equals(model));
      expect(fromJson.totalCalories, 640);
      expect(fromJson.totalDurationMinutes, 60);
      expect(fromJson.totalWaterNeedMl, 700);
      expect(fromJson.iconData, Icons.directions_run);
    });
  });

  group('WorkoutController Unit Tests', () {
    late WorkoutController controller;

    setUp(() {
      controller = WorkoutController(initialWorkouts: const <WorkoutModel>[]);
    });

    tearDown(() {
      controller.dispose();
    });

    test('egzersiz ekleme, artırma, azaltma ve silme doğru çalışmalı', () {
      final WorkoutModel sample = WorkoutController.presetWorkouts.first;

      controller.addOrIncrementWorkout(sample);
      expect(controller.workouts.value.length, 1);
      expect(controller.totalCaloriesBurned, sample.caloriesBurned);

      controller.addOrIncrementWorkout(sample);
      expect(controller.workouts.value.first.sessionCount, 2);
      expect(controller.totalCaloriesBurned, sample.caloriesBurned * 2);

      controller.decrementOrRemoveWorkout(sample.id);
      expect(controller.workouts.value.first.sessionCount, 1);

      controller.removeWorkout(sample.id);
      expect(controller.workouts.value, isEmpty);
    });
  });

  group('WorkoutView Widget Tests', () {
    testWidgets('egzersiz kartları eklenip çıkarılabilmeli', (
      WidgetTester tester,
    ) async {
      final WorkoutController controller = WorkoutController(
        initialWorkouts: const <WorkoutModel>[],
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(body: WorkoutView(controller: controller)),
        ),
      );

      expect(find.text('0 kcal'), findsOneWidget);

      await tester.tap(find.byKey(const Key('preset_run_30')));
      await tester.pump();

      expect(find.text('320 kcal'), findsOneWidget);
      expect(find.text('1x'), findsOneWidget);

      await tester.tap(find.byKey(const Key('increment_run_30')));
      await tester.pump();

      expect(find.text('640 kcal'), findsOneWidget);
      expect(find.text('2x'), findsOneWidget);

      await tester.tap(find.byKey(const Key('delete_run_30')));
      await tester.pump();

      expect(find.text('0 kcal'), findsOneWidget);
    });
  });
}
