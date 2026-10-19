import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim_v1/core/theme/theme_controller.dart';
import 'package:susadim_v1/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim_v1/features/workout/controllers/workout_controller.dart';
import 'package:susadim_v1/main.dart';

void main() {
  group('ThemeController Unit Testleri', () {
    test('Varsayılan tema dark olmalı ve toggle doğru çalışmalı', () {
      final themeController = ThemeController();
      expect(themeController.isDarkMode, true);
      expect(themeController.themeMode.value, ThemeMode.dark);

      themeController.toggleTheme();
      expect(themeController.isDarkMode, false);
      expect(themeController.themeMode.value, ThemeMode.light);

      themeController.toggleTheme();
      expect(themeController.isDarkMode, true);
      expect(themeController.themeMode.value, ThemeMode.dark);

      themeController.setThemeMode(ThemeMode.light);
      expect(themeController.themeMode.value, ThemeMode.light);
      themeController.dispose();
    });
  });

  group('WaterTrackerController Unit Testleri', () {
    test('Başlangıçta su miktarı 0 olmalı', () {
      final controller = WaterTrackerController();
      expect(controller.currentWater.value, 0);
      expect(controller.records.value.isEmpty, true);
      expect(controller.progress, 0.0);
      controller.dispose();
    });

    test('Su ekleme ve sıfırlama doğru çalışmalı', () {
      final controller = WaterTrackerController();
      controller.addWater(250);
      expect(controller.currentWater.value, 250);
      expect(controller.records.value.length, 1);

      controller.addWater(500);
      expect(controller.currentWater.value, 750);
      expect(controller.records.value.length, 2);

      controller.resetWater();
      expect(controller.currentWater.value, 0);
      expect(controller.records.value.isEmpty, true);
      controller.dispose();
    });
  });

  group('WorkoutController Unit Testleri', () {
    test('Egzersiz ekleme ve kalori hesaplama doğru çalışmalı', () {
      final controller = WorkoutController();
      expect(controller.totalCalories.value, 0);
      expect(controller.totalMinutes.value, 0);

      final sample = WorkoutController.availableCatalog.first;
      controller.addWorkout(sample);

      expect(controller.activeWorkouts.value.length, 1);
      expect(controller.totalCalories.value, sample.calories);
      expect(controller.totalMinutes.value, sample.durationMinutes);

      controller.removeWorkout(controller.activeWorkouts.value.first.id);
      expect(controller.activeWorkouts.value.isEmpty, true);
      expect(controller.totalCalories.value, 0);
      controller.dispose();
    });
  });

  group('SusadimApp Widget Testi', () {
    testWidgets('Uygulama açılmalı, sekmeler ve tema butonu çalışmalı',
        (WidgetTester tester) async {
      final themeController = ThemeController();
      await tester.pumpWidget(SusadimApp(themeController: themeController));
      await tester.pump();

      expect(find.text('susadım'), findsOneWidget);
      expect(find.text('v1'), findsOneWidget);
      expect(find.text('Su Takibi'), findsOneWidget);
      expect(find.text('Egzersiz & Kalori'), findsOneWidget);

      // Tema butonunu bul ve tıkla
      final themeButton = find.byType(IconButton).first;
      expect(themeController.isDarkMode, true);
      await tester.tap(themeButton);
      await tester.pumpAndSettle();
      expect(themeController.isDarkMode, false);

      themeController.dispose();
    });
  });
}
