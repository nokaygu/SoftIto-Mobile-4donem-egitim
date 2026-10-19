import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../water_tracker/controllers/water_tracker_controller.dart';
import '../../water_tracker/view/water_tracker_view.dart';
import '../../workout/controllers/workout_controller.dart';
import '../../workout/view/workout_view.dart';

/// Susadım v1 - Ana Sayfa ve Sekmeli Gezinme Görünümü
class HomeView extends StatefulWidget {
  final ThemeController themeController;

  const HomeView({
    super.key,
    required this.themeController,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
  }

  @override
  void dispose() {
    _waterController.dispose();
    _workoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            WaterTrackerView(controller: _waterController),
            WorkoutView(controller: _workoutController),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return AppBar(
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'susadım',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(40),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: primaryColor, width: 0.8),
            ),
            child: Text(
              'v1',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
      actions: [_buildThemeToggle()],
    );
  }

  Widget _buildThemeToggle() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: widget.themeController.themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? AppColors.neonAmber : AppColors.lightPrimary,
          ),
          tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
          onPressed: widget.themeController.toggleTheme,
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
      destinations: const [
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
