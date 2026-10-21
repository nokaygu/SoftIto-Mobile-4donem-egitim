import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Kamera ve Mikrofon izinlerini yöneten servis
class PermissionService {
  PermissionService._();

  static bool get _isDesktop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  /// Kamera ve mikrofon izinlerinin verildiğinden emin olur, verilmemişse talep eder.
  static Future<bool> ensureCameraAndMicPermissions() async {
    if (_isDesktop) {
      return true;
    }

    try {
      final statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();

      final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
      final micGranted = statuses[Permission.microphone]?.isGranted ?? false;

      return cameraGranted && micGranted;
    } catch (_) {
      return true;
    }
  }

  /// Kamera izin durumunu kontrol eder
  static Future<bool> isCameraGranted() async {
    if (_isDesktop) return true;
    try {
      return await Permission.camera.isGranted;
    } catch (_) {
      return true;
    }
  }

  /// Mikrofon izin durumunu kontrol eder
  static Future<bool> isMicrophoneGranted() async {
    if (_isDesktop) return true;
    try {
      return await Permission.microphone.isGranted;
    } catch (_) {
      return true;
    }
  }

  /// Sadece kamera izni ister
  static Future<bool> requestCamera() async {
    if (_isDesktop) return true;
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (_) {
      return true;
    }
  }

  /// Sadece mikrofon izni ister
  static Future<bool> requestMicrophone() async {
    if (_isDesktop) return true;
    try {
      final status = await Permission.microphone.request();
      return status.isGranted;
    } catch (_) {
      return true;
    }
  }

  /// Kullanıcı kalıcı olarak reddettiyse cihaz ayarlarını açar
  static Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (_) {
      return false;
    }
  }
}
