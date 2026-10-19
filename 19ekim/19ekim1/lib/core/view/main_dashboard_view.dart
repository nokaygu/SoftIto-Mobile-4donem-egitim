import 'package:flutter/material.dart';
import '../../features/water_tracker/controller/water_controller.dart';
import '../../features/water_tracker/view/water_tracker_view.dart';
import '../../features/workout/controller/workout_controller.dart';
import '../../features/workout/view/workout_view.dart';

class MainDashboardView extends StatefulWidget {
  const MainDashboardView({super.key});

  @override
  State<MainDashboardView> createState() => _MainDashboardViewState();
}

class _MainDashboardViewState extends State<MainDashboardView> {
  final ValueNotifier<int> _currentTabIndex = ValueNotifier<int>(0);
  late final WaterController _waterController;
  late final WorkoutController _workoutController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterController();
    _workoutController = WorkoutController();
  }

  @override
  void dispose() {
    _currentTabIndex.dispose();
    _waterController.dispose();
    _workoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentTabIndex,
      builder: (context, activeIndex, _) {
        return Scaffold(
          body: IndexedStack(
            index: activeIndex,
            children: [
              WaterTrackerView(controller: _waterController),
              WorkoutView(controller: _workoutController),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: activeIndex,
            onDestinationSelected: (index) => _currentTabIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop),
                label: 'Su Takibi',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Egzersiz',
              ),
            ],
          ),
        );
      },
    );
  }
}
