import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/water_tracker/controllers/water_tracker_controller.dart';
import 'features/water_tracker/view/water_tracker_view.dart';
import 'features/workout/controllers/workout_controller.dart';
import 'features/workout/models/workout_model.dart';
import 'features/workout/view/workout_view.dart';

void main() {
  runApp(SusadimApp());
}

/// Susadım ana uygulama bileşeni (Uygulama başlatma ve reaktif tema yönetimi).
class SusadimApp extends StatelessWidget {
  SusadimApp({
    super.key,
    ThemeController? themeController,
    WaterTrackerController? waterController,
    WorkoutController? workoutController,
  }) : _themeController = themeController ?? ThemeController(),
       _waterController = waterController ?? WaterTrackerController(),
       _workoutController = workoutController ?? WorkoutController();

  final ThemeController _themeController;
  final WaterTrackerController _waterController;
  final WorkoutController _workoutController;
  final ValueNotifier<int> _selectedTab = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeMode,
      builder: (BuildContext context, ThemeMode mode, _) {
        return MaterialApp(
          title: 'Susadım',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: _SusadimHomeShell(
            themeController: _themeController,
            waterController: _waterController,
            workoutController: _workoutController,
            selectedTab: _selectedTab,
          ),
        );
      },
    );
  }
}

class _SusadimHomeShell extends StatelessWidget {
  const _SusadimHomeShell({
    required this.themeController,
    required this.waterController,
    required this.workoutController,
    required this.selectedTab,
  });

  final ThemeController themeController;
  final WaterTrackerController waterController;
  final WorkoutController workoutController;
  final ValueNotifier<int> selectedTab;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedTab,
      builder: (BuildContext context, int currentIndex, _) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: currentIndex == 0
              ? _HydrationTabBody(
                  waterController: waterController,
                  workoutController: workoutController,
                )
              : WorkoutView(controller: workoutController),
          bottomNavigationBar: _SusadimNavigationBar(
            currentIndex: currentIndex,
            onTabSelected: (int index) => selectedTab.value = index,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Susadım'),
      actions: <Widget>[
        IconButton(
          key: const Key('theme_toggle_btn'),
          tooltip: 'Temayı Değiştir',
          onPressed: themeController.toggleTheme,
          icon: Icon(
            themeController.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
        ),
      ],
    );
  }
}

class _SusadimNavigationBar extends StatelessWidget {
  const _SusadimNavigationBar({
    required this.currentIndex,
    required this.onTabSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTabSelected,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop),
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center),
          label: 'Egzersiz & Kalori',
        ),
      ],
    );
  }
}

class _HydrationTabBody extends StatelessWidget {
  const _HydrationTabBody({
    required this.waterController,
    required this.workoutController,
  });

  final WaterTrackerController waterController;
  final WorkoutController workoutController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WorkoutModel>>(
      valueListenable: workoutController.workouts,
      builder: (BuildContext context, List<WorkoutModel> _, _) {
        return WaterTrackerView(
          controller: waterController,
          extraWorkoutWaterMl: workoutController.totalExtraWaterNeedMl,
        );
      },
    );
  }
}
