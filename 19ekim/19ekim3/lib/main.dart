import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/home/view/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController(ThemeMode.dark);
  runApp(SusadimApp(themeController: themeController));
}

/// Susadım v1 - Uygulama Kök Widget'ı
class SusadimApp extends StatelessWidget {
  final ThemeController themeController;

  const SusadimApp({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: HomeView(themeController: themeController),
        );
      },
    );
  }
}
