import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/models/user_model.dart';

class SecureAuthStorage {
  static const String _usersKey = 'habitsailer_users_json';
  static const String _activeUserKey = 'habitsailer_active_user';

  final FlutterSecureStorage _storage;

  SecureAuthStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<Map<String, dynamic>> _getAllUsersMap() async {
    final raw = await _storage.read(key: _usersKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return {};
  }

  Future<bool> registerUser({
    required String username,
    required String password,
  }) async {
    final cleanName = username.trim();
    if (cleanName.isEmpty || password.isEmpty) {
      return false;
    }

    final users = await _getAllUsersMap();
    if (users.containsKey(cleanName.toLowerCase())) {
      // User already exists
      return false;
    }

    final userMap = {
      'username': cleanName,
      'password': password,
      'avatarIndex': 0,
      'totalStreak': 0,
    };

    users[cleanName.toLowerCase()] = userMap;
    await _storage.write(key: _usersKey, value: jsonEncode(users));
    await _storage.write(key: _activeUserKey, value: cleanName);
    return true;
  }

  Future<UserModel?> loginUser({
    required String username,
    required String password,
  }) async {
    final cleanName = username.trim();
    final users = await _getAllUsersMap();
    final userMap = users[cleanName.toLowerCase()];
    if (userMap != null && userMap['password'] == password) {
      await _storage.write(key: _activeUserKey, value: userMap['username'] as String);
      return UserModel(
        username: userMap['username'] as String,
        avatarIndex: (userMap['avatarIndex'] as num?)?.toInt() ?? 0,
        totalStreak: (userMap['totalStreak'] as num?)?.toInt() ?? 0,
      );
    }
    return null;
  }

  Future<UserModel?> getActiveUser() async {
    final activeUsername = await _storage.read(key: _activeUserKey);
    if (activeUsername == null || activeUsername.isEmpty) {
      return null;
    }
    final users = await _getAllUsersMap();
    final userMap = users[activeUsername.toLowerCase()];
    if (userMap != null) {
      return UserModel(
        username: userMap['username'] as String,
        avatarIndex: (userMap['avatarIndex'] as num?)?.toInt() ?? 0,
        totalStreak: (userMap['totalStreak'] as num?)?.toInt() ?? 0,
      );
    }
    return null;
  }

  Future<void> updateActiveUserAvatar(int avatarIndex) async {
    final activeUsername = await _storage.read(key: _activeUserKey);
    if (activeUsername == null) return;

    final users = await _getAllUsersMap();
    final key = activeUsername.toLowerCase();
    if (users.containsKey(key)) {
      final userMap = Map<String, dynamic>.from(users[key] as Map);
      userMap['avatarIndex'] = avatarIndex;
      users[key] = userMap;
      await _storage.write(key: _usersKey, value: jsonEncode(users));
    }
  }

  Future<void> updateActiveUserTotalStreak(int totalStreak) async {
    final activeUsername = await _storage.read(key: _activeUserKey);
    if (activeUsername == null) return;

    final users = await _getAllUsersMap();
    final key = activeUsername.toLowerCase();
    if (users.containsKey(key)) {
      final userMap = Map<String, dynamic>.from(users[key] as Map);
      userMap['totalStreak'] = totalStreak;
      users[key] = userMap;
      await _storage.write(key: _usersKey, value: jsonEncode(users));
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _activeUserKey);
  }
}
