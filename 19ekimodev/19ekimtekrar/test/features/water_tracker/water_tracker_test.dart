import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/app_theme.dart';
import 'package:susadim/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/models/water_tracker_model.dart';
import 'package:susadim/features/water_tracker/view/water_tracker_view.dart';

void main() {
  group('WaterTrackerModel & WaterIntakeLog Unit Tests', () {
    test('copyWith, toJson ve fromJson doğru çalışmalı', () {
      const WaterIntakeLog log = WaterIntakeLog(
        id: 'water_1',
        amountMl: 250,
        label: 'Bardak Su',
      );
      const WaterTrackerModel model = WaterTrackerModel(
        currentWaterMl: 250,
        dailyGoalMl: 2000,
        logs: <WaterIntakeLog>[log],
      );

      final Map<String, dynamic> json = model.toJson();
      final WaterTrackerModel fromJson = WaterTrackerModel.fromJson(json);

      expect(fromJson, equals(model));
      expect(fromJson.progress, closeTo(0.125, 0.001));
      expect(fromJson.remainingWaterMl, 1750);
      expect(fromJson.isGoalReached, isFalse);

      final WaterTrackerModel updated = model.copyWith(currentWaterMl: 2000);
      expect(updated.isGoalReached, isTrue);
      expect(updated.progressPercent, 100);
    });
  });

  group('WaterTrackerController Unit Tests', () {
    late WaterTrackerController controller;

    setUp(() {
      controller = WaterTrackerController(dailyGoalWater: 2000);
    });

    tearDown(() {
      controller.dispose();
    });

    test('su ekleme, azaltma, kayıt silme ve sıfırlama doğru çalışmalı', () {
      expect(controller.currentWater.value, 0);

      controller.addWater(250, 'Bardak Su');
      expect(controller.currentWater.value, 250);
      expect(controller.state.value.logs.length, 1);

      controller.addWater(500, 'Matara Su');
      expect(controller.currentWater.value, 750);
      expect(controller.state.value.logs.length, 2);

      final String firstLogId = controller.state.value.logs.first.id;
      controller.removeLogById(firstLogId);
      expect(controller.currentWater.value, 250);
      expect(controller.state.value.logs.length, 1);

      controller.removeWater(250);
      expect(controller.currentWater.value, 0);

      controller.addWater(200);
      controller.resetWater();
      expect(controller.currentWater.value, 0);
      expect(controller.state.value.logs, isEmpty);
    });
  });

  group('WaterTrackerView Widget Tests', () {
    testWidgets('butonlarla su eklenip sıfırlanabilmeli', (
      WidgetTester tester,
    ) async {
      final WaterTrackerController controller = WaterTrackerController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(body: WaterTrackerView(controller: controller)),
        ),
      );

      expect(find.text('0 / 2000 ml'), findsOneWidget);

      await tester.tap(find.byKey(const Key('add_250_btn')));
      await tester.pump();

      expect(find.text('250 / 2000 ml'), findsOneWidget);
      expect(find.text('Bardak Su (250 ml)'), findsOneWidget);

      await tester.tap(find.byKey(const Key('reset_water_btn')));
      await tester.pump();

      expect(find.text('0 / 2000 ml'), findsOneWidget);
    });
  });
}
