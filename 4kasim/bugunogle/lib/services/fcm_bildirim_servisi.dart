import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//pragma ile işi fcma devrrt uygulama açık olmasa da işlem devreye girer
@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {}

class FcmBildirimServisi {
  //fcmnin tekil instanceına ulaş
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  //yerel plugin oluştır
  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();

  // UI'daki listeye (_bildirimler) ekleme yapan callback'i saklıyoruz
  Function(RemoteMessage message)? _onMesajGeldiCallback;

  // Apple cihazlarda (iOS/macOS) APNS token kontrolü
  Future<bool> _apnsTokenHazirMi() async {
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        String? apnsToken = await _fcm.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await _fcm.getAPNSToken();
        }
        return apnsToken != null;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  // APNS olmasa bile hem Bildirim Merkezine hem de UI listesine bildirim ekleyen fonksiyon
  Future<void> bildirimMerkezineEkle({
    required String baslik,
    required String icerik,
  }) async {
    final mesaj = RemoteMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      notification: RemoteNotification(title: baslik, body: icerik),
    );
    // 1. İşletim sisteminin Bildirim Merkezinde (sağ üstte / bildirim çubuğunda) göster
    await _yerelBildirimGoster(mesaj);
    // 2. Uygulama ekranındaki BildirimListesiKarti içine ekle
    _onMesajGeldiCallback?.call(mesaj);
  }

  //onmesajgeldi callbağı tetiklenir böylece ui tarafında da o fonksiyon işlevini verebiliriz
  Future<void> baslat({
    required Function(RemoteMessage message) onMesajGeldi,
  }) async {
    _onMesajGeldiCallback = onMesajGeldi;

    //izinlwr her zaman istenmelidir/kontrol edilmelidir
    try {
      await _fcm.requestPermission(alert: true, badge: true, sound: true);
    } catch (e) {
      debugPrint('FCM izin uyarısı (yerel bildirim kullanılacak): $e');
    }

    //res klasöründe farklı çözünürlükler için farklı icomlar olur
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    //darwin kerneline göre ayarlar al ios macos destekler (İzinleri açıkça istiyoruz)
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );
    //event quede önce başlamayı bekle
    await _localPlugin.initialize(initSettings);

    //mssaj gelmesimi dinle bildirim göster
    FirebaseMessaging.onMessage.listen((message) {
      _yerelBildirimGoster(message);
      onMesajGeldi(message);
    });
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

    // APNS token alınamasa bile başlangıçta bildirim merkezine ilk bildirimi ekle
    final hazir = await _apnsTokenHazirMi();
    if (!hazir) {
      await bildirimMerkezineEkle(
        baslik: 'Bildirim Merkezi Aktif',
        icerik: 'APNS olmadan yerel FCM bildirim modu başlatıldı.',
      );
    }
  }

  Future<String?> tokenAl() async {
    try {
      final hazir = await _apnsTokenHazirMi();
      if (!hazir) {
        // APNS yoksa ekranda boş görünmemesi için test token'ı döndür
        return 'local_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
      }
      return await _fcm.getToken();
    } catch (_) {
      return 'local_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  //subsricbe olan konu bazlı bildiirmler gelsin
  Future<void> konuyaAboneOl(String konu) async {
    try {
      final hazir = await _apnsTokenHazirMi();
      if (hazir) {
        await _fcm.subscribeToTopic(konu);
      }
    } catch (e) {
      debugPrint('Konu abonelik uyarısı: $e');
    }
    // APNS olsa da olmasa da abone olunduğunda bildirim merkezine ve listeye ekle!
    await bildirimMerkezineEkle(
      baslik: 'Konuya Abone Olundu',
      icerik: '"$konu" sınıf bildirimlerine başarıyla abone oldunuz.',
    );
  }

  Future<void> konudanAyril(String konu) async {
    try {
      final hazir = await _apnsTokenHazirMi();
      if (hazir) {
        await _fcm.unsubscribeFromTopic(konu);
      }
    } catch (e) {
      debugPrint('Konudan ayrılma uyarısı: $e');
    }
    // Konudan ayrılınca da bildirim merkezine ve listeye bilgi ekle
    await bildirimMerkezineEkle(
      baslik: 'Abonelikten Çıkıldı',
      icerik: '"$konu" bildirim aboneliğinden ayrıldınız.',
    );
  }

  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    //android için gerekli özellikşer
    const androidDetails = AndroidNotificationDetails(
      'sofit_fcm_channel_id',
      'Softito bildirimleri',
      channelDescription: 'Fcm push bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
    );
    // Uygulama açıkken de bildirim merkezinde ve üst banner'da görünmesi için:
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
    await _localPlugin.show(
      message.hashCode,
      message.notification?.title ?? "yeni bildirim",
      message.notification?.body ?? "",
      details,
    );
  }
}
