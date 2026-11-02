import 'package:demo/screens/ana_kasa_ekrani.dart';
import 'package:demo/screens/ana_sayfa_ekrani.dart';
import 'package:demo/screens/profil_ekrani.dart';
import 'package:demo/screens/vitrin_ekrani.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final uygulamaRotalari = GoRouter(
  initialLocation: '/anasayfa',
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AnaKasaEkrani(ekranGovdesi: child);
      },
      routes: [
        GoRoute(
          path: '/anakasa',
          builder: (context, state) =>
              const AnaKasaEkrani(ekranGovdesi: Text("333")),
        ),
        GoRoute(
          path: '/anasayfa',
          builder: (context, state) => const AnaSayfaEkrani(),
        ),
        GoRoute(
          path: '/vitrin',
          builder: (context, state) => const VitrinEkrani(),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: uygulamaRotalari,
      title: "gooruter örneği",
    );
  }
}
