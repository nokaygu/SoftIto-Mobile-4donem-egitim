import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';
import 'package:susadim/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim/features/workout/controllers/workout_controller.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets(
    'Susadım uygulaması koyu temada başlamalı, sekmeler ve tema geçişi çalışmalı',
    (WidgetTester tester) async {
      final ThemeController themeController = ThemeController();
      final WaterTrackerController waterController = WaterTrackerController();
      final WorkoutController workoutController = WorkoutController();

      addTearDown(() {
        themeController.dispose();
        waterController.dispose();
        workoutController.dispose();
      });

      await tester.pumpWidget(
        SusadimApp(
          themeController: themeController,
          waterController: waterController,
          workoutController: workoutController,
        ),
      );

      expect(find.text('Susadım'), findsOneWidget);
      expect(themeController.themeMode.value, ThemeMode.dark);

      // Başlangıçta aktif olan 2 egzersizden gelen +650 ml antrenman su ihtiyacıyla
      // toplam hedef 2650 ml olarak görüntülenmelidir.
      expect(find.text('0 / 2650 ml'), findsOneWidget);

      // Tema değiştirme butonunu test et
      await tester.tap(find.byKey(const Key('theme_toggle_btn')));
      await tester.pump();
      expect(themeController.themeMode.value, ThemeMode.light);

      // Egzersiz & Kalori sekmesine geç
      await tester.tap(find.text('Egzersiz & Kalori'));
      await tester.pumpAndSettle();

      expect(find.text('Aktif Egzersiz Kartları'), findsOneWidget);
      expect(find.text('600 kcal'), findsOneWidget);
    },
  );
}
