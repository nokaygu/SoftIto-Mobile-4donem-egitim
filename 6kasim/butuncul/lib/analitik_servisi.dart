import 'package:firebase_analytics/firebase_analytics.dart';

class AnalitikServisi {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  Future<void> ekranGoruntulendi(String ekranAdi) async {
    await _analytics.logScreenView(screenName: ekranAdi);
  }

  Future<void> butonTiklandi({
    required String butonId,
    required String kategori,
  }) async {
    //await ile olay loglama
    await _analytics.logEvent(
      name: "buton_tikleme",
      parameters: {
        'buton_id': butonId,
        'kategori': kategori,
        //tarihi formatına göre çevirme
        'zaman': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> sepeteEklendi({
    required String urunId,
    required double fiyat,
  }) async {
    await _analytics.logEvent(
      name: 'sepete_ekle',
      parameters: {'urun_id': urunId, 'fiyat': fiyat, 'para_birimi': 'TL'},
    );
  }
}
