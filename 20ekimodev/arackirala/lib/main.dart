import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'features/models/user_model.dart';
import 'features/views/araclar/araclar.dart';
import 'features/views/kiracilar/kiraci.dart';
import 'features/views/kiracilar/kiralayan.dart';
import 'features/views/login.dart';
import 'features/views/mesajlar/mesajlar.dart';
import 'features/views/profil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VitesApp());
}

/// Uygulama kök bileşeni
class VitesApp extends StatelessWidget {
  const VitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.theme,
      builder: (context, _) {
        return MaterialApp(
          title: 'Vites',
          debugShowCheckedModeBanner: false,
          themeMode: AppState.theme.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const AuthGate(),
        );
      },
    );
  }
}

/// Kullanıcı oturum durumuna göre Login veya Ana Kabuk ekranını açan kapı
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: AppState.userProfile.currentUser,
      builder: (context, user, _) {
        if (user == null) {
          return LoginScreen(onLoginSuccess: () {});
        }
        return const MainNavigationShell();
      },
    );
  }
}

/// 4 sekmeli ana navigasyon kabuğu (Rol tabanlı dinamik sekme içerir)
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = AppState.userProfile.currentUser.value;
    final isVeren = user?.isKirayaVeren ?? true;
    final tabs = _buildTabs(isVeren);

    return Scaffold(
      backgroundColor: context.scaffoldColor,
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: _buildBottomNavBar(context, isVeren),
    );
  }

  List<Widget> _buildTabs(bool isVeren) {
    return [
      const AraclarScreen(),
      isVeren ? const KiraciScreen() : const KiralayanScreen(),
      const MesajlarScreen(),
      ProfilScreen(onLogout: () {
        setState(() => _currentIndex = 0);
      }),
    ];
  }

  Widget _buildBottomNavBar(BuildContext context, bool isVeren) {
    return Container(
      decoration: BoxDecoration(
        color: context.scaffoldColor,
        border: Border(top: BorderSide(color: context.glassBorderColor, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.burgundyLight,
        unselectedItemColor: context.textMutedColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.speed_rounded),
            activeIcon: Icon(Icons.speed_rounded, color: AppColors.burgundyLight),
            label: 'Vitrin',
          ),
          BottomNavigationBarItem(
            icon: Icon(isVeren ? Icons.people_outline_rounded : Icons.car_rental_rounded),
            activeIcon: Icon(
              isVeren ? Icons.people_alt_rounded : Icons.car_rental_rounded,
              color: AppColors.burgundyLight,
            ),
            label: isVeren ? 'Kiracılar' : 'Kiralayanlar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded, color: AppColors.burgundyLight),
            label: 'Mesajlar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded, color: AppColors.burgundyLight),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
