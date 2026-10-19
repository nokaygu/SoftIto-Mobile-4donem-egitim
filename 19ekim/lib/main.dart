import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/view/main_dashboard_view.dart';

void main() {
  runApp(const SusadimApp());
}

class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainDashboardView(),
    );
  }
}
