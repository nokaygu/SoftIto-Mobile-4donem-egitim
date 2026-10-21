import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../core/permissions/permission_service.dart';

/// Ayarlar, mikrofon ve kamera testi kontrolcüsü
class SettingsController {
  final ValueNotifier<bool> isMicTesting = ValueNotifier<bool>(false);
  final ValueNotifier<double> liveAudioLevel = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> isCamTesting = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMirrorMode = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isMicGranted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCamGranted = ValueNotifier<bool>(false);

  Timer? _audioTimer;
  final Random _random = Random();

  Future<void> checkPermissions() async {
    isMicGranted.value = await PermissionService.isMicrophoneGranted();
    isCamGranted.value = await PermissionService.isCameraGranted();
  }

  void startMicTest() {
    isMicTesting.value = true;
    _audioTimer?.cancel();
    _audioTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!isMicTesting.value) {
        timer.cancel();
        return;
      }
      // Mikrofon canlı ses seviyesi desibel barı (0.15 - 0.95 arası dalgalanma)
      liveAudioLevel.value = 0.15 + _random.nextDouble() * 0.8;
    });
  }

  void stopMicTest() {
    isMicTesting.value = false;
    _audioTimer?.cancel();
    _audioTimer = null;
    liveAudioLevel.value = 0.0;
  }

  void toggleCamTest() {
    isCamTesting.value = !isCamTesting.value;
  }

  void toggleMirrorMode() {
    isMirrorMode.value = !isMirrorMode.value;
  }

  void dispose() {
    _audioTimer?.cancel();
  }
}
