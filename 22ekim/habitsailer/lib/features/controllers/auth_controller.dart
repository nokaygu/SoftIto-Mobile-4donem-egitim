import 'package:flutter/foundation.dart';
import '../../core/storage/secure_auth_storage.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final SecureAuthStorage secureStorage;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController({required this.secureStorage});

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
      _currentUser = await secureStorage.getActiveUser();
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
      final user = await secureStorage.loginUser(
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
      _errorMessage = 'Giriş sırasında bir hata oluştu.';
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
      final success = await secureStorage.registerUser(
        username: username,
        password: password,
      );
      if (success) {
        _currentUser = await secureStorage.getActiveUser();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Bu kullanıcı adı zaten kayıtlı!';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Kayıt sırasında bir hata oluştu.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateAvatar(int avatarIndex) async {
    if (_currentUser == null) return;
    await secureStorage.updateActiveUserAvatar(avatarIndex);
    _currentUser = _currentUser!.copyWith(avatarIndex: avatarIndex);
    notifyListeners();
  }

  Future<void> syncTotalStreak(int totalStreak) async {
    if (_currentUser == null) return;
    if (_currentUser!.totalStreak != totalStreak) {
      await secureStorage.updateActiveUserTotalStreak(totalStreak);
      _currentUser = _currentUser!.copyWith(totalStreak: totalStreak);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await secureStorage.logout();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
