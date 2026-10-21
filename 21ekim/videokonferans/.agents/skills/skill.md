---
name: flutter-agora-responsive-scaffold
description: VizyonMeet projesi için Agora v6.x video konferans entegrasyonu, permission_handler izin yönetimi, %100 responsive (sıfır taşma) UI bileşenleri ve SOLID/OOP standartlarında modüler kod üretir.
---

# Flutter Agora v6.x & Responsive UI Scaffold

Bu yetenek, projede ekranlar ve özellikler geliştirilirken **Agora RTC Engine v6.x** standartlarına, **sıfır widget/yazı sıkışması (Zero Overflow)** kuralına ve **SOLID** prensiplerine tam uyulmasını sağlar.

## Temel Kurallar

1. **Sıfır Sıkışma ve Tam Responsive Tasarım:**
   - Hiçbir `Row` içinde uzun metinler doğrudan `Text` olarak bırakılmaz; mutlaka `Expanded` veya `Flexible` içine alınır.
   - Buton grupları veya rozetler dar ekranlarda sıkışmaması için `Wrap` veya `FittedBox` ile sarmalanır.
   - Konferans ekranı `OrientationBuilder` veya `MediaQuery.orientationOf(context)` kullanarak hem dikey (Portrait) hem yatay (Landscape) modda kusursuz yerleşim sunar.
2. **Agora v6.x Güncel Kullanımı (`7aad306718aa4fe1a09d2c2f9ba68136`):**
   - Eski v4/v5 sınıfları (`RtcLocalView` vb.) **KESİNLİKLE KULLANILMAZ**.
   - Yalnızca v6.x API'si (`createAgoraRtcEngine()`, `AgoraVideoView`, `VideoViewController`, `VideoViewController.remote`, `ChannelMediaOptions`) kullanılır.
   - `joinChannel` metodunda `token: ""` gönderilir.
3. **Uzun Kodları Parçalama (SOLID):**
   - Hiçbir `build` metodu 40 satırı geçemez. Alt bölümler `_build...` metodlarına veya `lib/features/widgets/` altındaki bağımsız sınıflara bölünür.

## Uygulama Şablonları

### 1. İzin Servisi Şablonu (`lib/core/permissions/permission_service.dart`)

```dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> ensureCameraAndMicPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    final micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    return cameraGranted && micGranted;
  }
}
```

### 2. Agora v6.x Controller Şablonu (`lib/features/controllers/conference_controller.dart`)

```dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/agora_config.dart';
import '../../core/permissions/permission_service.dart';

class ConferenceController {
  RtcEngine? _engine;
  final ValueNotifier<bool> isJoined = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMicMuted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCameraOff = ValueNotifier<bool>(false);
  final ValueNotifier<List<int>> remoteUids = ValueNotifier<List<int>>([]);

  RtcEngine? get engine => _engine;

  Future<bool> initAndJoinChannel(String channelName) async {
    final hasPermission = await PermissionService.ensureCameraAndMicPermissions();
    if (!hasPermission) return false;

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(
      const RtcEngineContext(
        appId: AgoraConfig.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (!remoteUids.value.contains(remoteUid)) {
            remoteUids.value = [...remoteUids.value, remoteUid];
          }
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          remoteUids.value = remoteUids.value.where((id) => id != remoteUid).toList();
        },
      ),
    );

    await _engine!.enableVideo();
    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: '',
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
    return true;
  }

  Future<void> toggleMic() async {
    isMicMuted.value = !isMicMuted.value;
    await _engine?.muteLocalAudioStream(isMicMuted.value);
  }

  Future<void> toggleCamera() async {
    isCameraOff.value = !isCameraOff.value;
    await _engine?.muteLocalVideoStream(isCameraOff.value);
  }

  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  Future<void> setMicVolume(double volume) async {
    await _engine?.adjustRecordingSignalVolume(volume.toInt());
  }

  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    isJoined.value = false;
    remoteUids.value = [];
  }
}
```

### 3. Yuvarlak Modern Kontrol Butonu Şablonu (`lib/features/widgets/call_control_bar.dart`)

```dart
import 'package:flutter/material.dart';

class CircularCallButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final String tooltip;

  const CircularCallButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ),
      ),
    );
  }
}
```
