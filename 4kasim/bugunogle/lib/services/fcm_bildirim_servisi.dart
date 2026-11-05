import 'package:firebase_messaging/firebase_messaging.dart';
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
//onmesajgeldi callbağı tetiklenir böylece ui tarafında da o fonksiyon işlevini verebiliriz
  Future<void> baslat({
    required Function(RemoteMessage message) onMesajGeldi,
  }) async {
//izinlwr her zaman istenmelidir/kontrol edilmelidir
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
//res klasöründe farklı çözünürlükler için farklı icomlar olur
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
//darwin kerneline göre ayarlar al ios macos destekler
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
//event quede önce başlamayı bekle
    await _localPlugin.initialize(initSettings);
   //mssaj gelmesimi dinle bildirim göster FirebaseMessaging.onMessage.listen((message) {
      _yerelBildirimGoster(message);
      onMesajGeldi(message);
    });
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  }
//subsricbe olan konu bazlı bildiirmler gelsin
  Future<void> konuyaAboneOl(String konu) async {
    await _fcm.subscribeToTopic(konu);
  }

  Future<void> konudanAyril(String konu) async {
    await _fcm.unsubscribeFromTopic(konu);
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
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );
    await _localPlugin.show(
      message.hashCode,
      message.notification?.title ?? "yeni bildirim",
      message.notification?.body ?? "",
      details,
    );
  }
}
