import 'package:flutter/material.dart';
import 'agenda/agenda_view.dart';
import 'logbook/logbook_view.dart';
import 'profile/profile_view.dart';
import 'tasks/tasks_hub_view.dart';
import 'today/today_view.dart';

class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    TodayView(),
    LogbookView(),
    AgendaView(),
    TasksHubView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(
            top: BorderSide(color: cs.outlineVariant, width: 1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.outlineVariant,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: cs.surface,
          indicatorColor: cs.primaryContainer,
          elevation: 0,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.wb_sunny_outlined, color: cs.onSurface),
              selectedIcon: Icon(Icons.wb_sunny_rounded, color: cs.primary),
              label: 'Bugün',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined, color: cs.onSurface),
              selectedIcon: Icon(Icons.auto_stories_rounded, color: cs.primary),
              label: 'Seyir Defteri',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined, color: cs.onSurface),
              selectedIcon: Icon(Icons.calendar_month_rounded, color: cs.primary),
              label: 'Ajanda',
            ),
            NavigationDestination(
              icon: Icon(Icons.sailing_outlined, color: cs.onSurface),
              selectedIcon: Icon(Icons.sailing_rounded, color: cs.primary),
              label: 'Görevle',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: cs.onSurface),
              selectedIcon: Icon(Icons.person_rounded, color: cs.primary),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
