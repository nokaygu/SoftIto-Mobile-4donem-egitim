import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme_model.dart';
import 'conference/conference_lobby_view.dart';
import 'friends/friends_view.dart';
import 'profile/profile_view.dart';
import 'settings/settings_view.dart';

/// 4 Sekmeli Ana İskelet ve Alt Navigasyon Barı
class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ConferenceLobbyView(),
    FriendsView(),
    SettingsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeModel>(
      valueListenable: AppState.theme.currentTheme,
      builder: (context, theme, _) {
        return ValueListenableBuilder<String>(
          valueListenable: AppState.language.currentLanguage,
          builder: (context, langCode, _) {
            final lang = AppState.language;

            return Scaffold(
              backgroundColor: theme.background,
              appBar: AppBar(
                backgroundColor: theme.surface,
                elevation: 0,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_camera_front_rounded, color: theme.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      lang.text('app_title'),
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              body: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: theme.surface,
                selectedItemColor: theme.primary,
                unselectedItemColor: theme.textSecondary,
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.hub_outlined),
                    activeIcon: const Icon(Icons.hub_rounded),
                    label: lang.text('tab_conference'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.people_alt_outlined),
                    activeIcon: const Icon(Icons.people_alt_rounded),
                    label: lang.text('tab_friends'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.settings_outlined),
                    activeIcon: const Icon(Icons.settings_rounded),
                    label: lang.text('tab_settings'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.account_circle_outlined),
                    activeIcon: const Icon(Icons.account_circle_rounded),
                    label: lang.text('tab_profile'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
