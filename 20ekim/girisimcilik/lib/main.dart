import 'dart:ui';
import 'package:flutter/material.dart';
import 'core/state/auth_role_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/admin_portal/views/admin_portal_view.dart';
import 'features/auth/views/role_selection_view.dart';
import 'features/investor_portal/views/investor_portal_view.dart';
import 'features/shell/views/shell_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KurucuApp());
}

class KurucuApp extends StatelessWidget {
  const KurucuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Kurucu - Girişimcilik Ekosistemi',
          debugShowCheckedModeBanner: false,
          scrollBehavior: const KurucuScrollBehavior(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const RootRoleGate(),
        );
      },
    );
  }
}

class RootRoleGate extends StatelessWidget {
  const RootRoleGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserRole?>(
      valueListenable: AuthRoleController.instance.activeRoleNotifier,
      builder: (context, role, _) {
        return switch (role) {
          UserRole.entrepreneur => const ShellView(),
          UserRole.investor => const InvestorPortalView(),
          UserRole.admin => const AdminPortalView(),
          null => const RoleSelectionView(),
        };
      },
    );
  }
}

class KurucuScrollBehavior extends MaterialScrollBehavior {
  const KurucuScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
