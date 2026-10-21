import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Kimlik doğrulama, kullanıcı oturumu ve profil kontrolcüsü
class AuthController {
  final ValueNotifier<UserModel?> currentUser = ValueNotifier<UserModel?>(null);

  bool get isLoggedIn => currentUser.value != null;

  /// Örnek demo hesaplar
  static const Map<String, String> _demoAccounts = {
    'ali': '123',
    'veli': '123',
  };

  /// Kullanıcı adı ve şifre ile giriş
  bool login(String username, String password) {
    final cleanUsername = username.trim().toLowerCase();
    if (_demoAccounts.containsKey(cleanUsername) && _demoAccounts[cleanUsername] == password) {
      final avatarId = cleanUsername == 'ali' ? 0 : 1;
      final displayName = cleanUsername == 'ali' ? 'Ali Yılmaz' : 'Veli Kaya';
      currentUser.value = UserModel(
        username: cleanUsername,
        displayName: displayName,
        avatarId: avatarId,
      );
      return true;
    }
    return false;
  }

  /// Hızlı giriş yardımcısı
  void quickLogin(String username) {
    login(username, '123');
  }

  /// Aktif kullanıcının avatarını güncelleme
  void updateAvatar(int avatarId) {
    if (currentUser.value != null) {
      currentUser.value = currentUser.value!.copyWith(avatarId: avatarId);
    }
  }

  /// Oturumu kapatma
  void logout() {
    currentUser.value = null;
  }
}
