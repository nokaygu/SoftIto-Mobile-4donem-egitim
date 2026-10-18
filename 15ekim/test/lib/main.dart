import 'package:flutter/material.dart';

import 'screens/01_layout_screen.dart';
import 'screens/02_markets_list_screen.dart';
import 'screens/03_transfer_form_screen.dart';

void main() {
  runApp(const DtmMasterApp());
}

class DtmMasterApp extends StatelessWidget {
  const DtmMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DTM Flutter Sınıfı',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      home: const LiveCanvasScreen(),
    );
  }
}

class LiveCanvasScreen extends StatefulWidget {
  const LiveCanvasScreen({super.key});

  @override
  State<LiveCanvasScreen> createState() => _LiveCanvasScreenState();
}

class _LiveCanvasScreenState extends State<LiveCanvasScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    LayoutStylingScreen(),
    MarketsGridListScreen(),
    TransferFormScreen(),
  ];

  static const List<String> _titles = [
    'DTM Canlı Arayüz',
    'Piyasalar',
    'Hızlı Transfer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Bildirimler',
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Henüz yeni bildirim yok.'),
                ),
              );
            },
          ),
        ],
      ),

      // Seçili ekranı göster, diğer ekranların durumunu koru.
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          sizing: StackFit.expand,
          children: _screens,
        ),
      ),

      // Alt menü
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0x1F6366F1),
        onDestinationSelected: (index) {
          if (index == _selectedIndex) return;

          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Cüzdan',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Piyasalar',
          ),
          NavigationDestination(
            icon: Icon(Icons.send_outlined),
            selectedIcon: Icon(Icons.send_rounded),
            label: 'Transfer',
          ),
        ],
      ),
    );
  }
}
