import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//2importum var biri yerrl bildirim diğrri firebaseten mesajlaşma

import 'package:firebase_messaging/firebase_messaging.dart';

class YerelBildirimYOneticis {
//static ile singleton yaparım ana clası instance yapıp her seferinde yeni değerüretmem
  static final FlutterLocalNotificationsPlugin _yerelBildirim =
      FlutterLocalNotificationsPlugin();

  static Future<void> kurulum() async {
   //android res üzerinden mipmağ
 const androidAyarlar = AndroidInitializationSettings('@mipmap/ic_launcher');
//macos da destekler
    const iosAyarlar = DarwinInitializationSettings();
    const ayarlar = InitializationSettings(
      android: androidAyarlar,
      iOS: iosAyarlar,
    );
//bu ayarlarla başla
    await _yerelBildirim.initialize(settings: ayarlar);
  }

  static Future<void> bildirimGoster(RemoteMessage message) async {
//detayları belirtik
    const androidDetay = AndroidNotificationDetails(
      'softito_kanal_id',
      'Softito Bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
//title başlık body gövde
//null gelirse yeni bildirim
    const detaylar = NotificationDetails(android: androidDetay);
    await _yerelBildirim.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'Yeni Bildirim',
      body: message.notification?.body ?? '',
      notificationDetails: detaylar,
    );
  }
}
