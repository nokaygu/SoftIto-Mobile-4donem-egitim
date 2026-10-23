import 'package:flutter/foundation.dart';
import '../../core/storage/hive_auth_storage.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final HiveAuthStorage authStorage;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController({required this.authStorage});

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get sailorRank {
    final streak = _currentUser?.totalStreak ?? 0;
    if (streak >= 30) {
      return 'Açık Deniz Kaptanı ⚓';
    } else if (streak >= 10) {
      return 'Usta Dümenci 🧭';
    } else {
      return 'Hevesli Tayfa ⛵';
    }
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await authStorage.getActiveUser();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await authStorage.loginUser(
        username: username,
        password: password,
      );
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Kullanıcı adı veya şifre hatalı!';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Giriş sırasında bir hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await authStorage.registerUser(
        username: username,
        password: password,
      );

      if (result.success && result.user != null) {
        _currentUser = result.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage ?? 'Kayıt sırasında bir hata oluştu.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Kayıt sırasında bir hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final success = await authStorage.updatePassword(
        username: _currentUser!.username,
        newPassword: newPassword,
      );
      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAvatar(int avatarIndex) async {
    if (_currentUser == null) return;
    await authStorage.updateActiveUserAvatar(avatarIndex);
    _currentUser = _currentUser!.copyWith(avatarIndex: avatarIndex);
    notifyListeners();
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    if (_currentUser == null) return;
    await authStorage.updateActiveUserNotifications(enabled);
    _currentUser = _currentUser!.copyWith(notificationsEnabled: enabled);
    notifyListeners();
  }

  Future<void> syncTotalStreak(int totalStreak) async {
    if (_currentUser == null) return;
    if (_currentUser!.totalStreak != totalStreak) {
      await authStorage.updateActiveUserTotalStreak(totalStreak);
      _currentUser = _currentUser!.copyWith(totalStreak: totalStreak);
      notifyListeners();
    }
  }

  Future<List<UserModel>> getLeaderboardUsers() async {
    return await authStorage.getAllUsers();
  }

  Future<void> logout() async {
    await authStorage.logout();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
