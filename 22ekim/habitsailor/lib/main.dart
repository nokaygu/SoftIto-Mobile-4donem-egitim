import 'package:flutter/material.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'features/views/auth/login_view.dart';
import 'features/views/main_shell_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init();
  runApp(const HabitSailorApp());
}

class HabitSailorApp extends StatelessWidget {
  const HabitSailorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AppState.instance.authController;

    return MaterialApp(
      title: 'Habit Sailor - Zinciri Kırma ⚡',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ListenableBuilder(
        listenable: authController,
        builder: (context, _) {
          if (authController.isLoggedIn) {
            return const MainShellView();
          }
          return const LoginView();
        },
      ),
    );
  }
}
