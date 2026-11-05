import 'package:firebase_messaging/firebase_messaging.dart';
//arkada çalışma özelliği
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//arka planda bildirim
  print("arka planda bildirim geldi:${message.notification?.title}");
}

class BildirimServisi {
//instance dediğimiz için çoklu instance üretme korkumuz yok
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//armalı alarm ses var
  Future<void> baslat() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
//izin varsa print
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Kullanıcı bildirim iznini verdi");
    }
    final token = await _fcm.getToken();
    print('cihazın fcm tokeni: $token');
  }
}
