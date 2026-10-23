import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../security/auth_validator.dart';
import '../../features/models/user_model.dart';

class RegisterResult {
  final bool success;
  final String? errorMessage;
  final UserModel? user;

  const RegisterResult({
    required this.success,
    this.errorMessage,
    this.user,
  });
}

/// Single-Engine Hive-based Auth Storage.
/// Eliminates flutter_secure_storage and crypto dependencies.
/// Provides deterministic O(1) performance and cross-platform reliability.
class HiveAuthStorage {
  static const String boxName = 'habitsailor_users_box';
  static const String _activeUserKey = 'active_user_name';
  static const String _userKeyPrefix = 'user_';

  // Legacy fallback box for migration
  static const String _legacyFallbackBoxName = 'habitsailor_auth_fallback_box';

  Box<dynamic>? box;

  HiveAuthStorage({this.box});

  Future<Box<dynamic>> _getBox() async {
    if (box != null && box!.isOpen) {
      return box!;
    }
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<dynamic>(boxName);
    } else {
      box = await Hive.openBox<dynamic>(boxName);
    }
    await _migrateLegacyDataIfPresent(box!);
    return box!;
  }

  Future<void> _migrateLegacyDataIfPresent(Box<dynamic> currentBox) async {
    try {
      if (currentBox.isNotEmpty) return;

      if (Hive.isBoxOpen(_legacyFallbackBoxName)) {
        final legacyBox = Hive.box<dynamic>(_legacyFallbackBoxName);
        final rawUsers = legacyBox.get('habitsailor_users_json') as String?;
        if (rawUsers != null && rawUsers.isNotEmpty) {
          final decoded = jsonDecode(rawUsers);
          if (decoded is Map<String, dynamic>) {
            for (final entry in decoded.entries) {
              final userMap = entry.value;
              if (userMap is Map) {
                await currentBox.put('$_userKeyPrefix${entry.key}', userMap);
              }
            }
          }
        }
        final active = legacyBox.get('habitsailor_active_user') as String?;
        if (active != null && active.isNotEmpty) {
          await currentBox.put(_activeUserKey, active);
        }
      }
    } catch (_) {}
  }

  /// Registers a new user with strict case-insensitive duplicate username check.
  Future<RegisterResult> registerUser({
    required String username,
    required String password,
  }) async {
    final usernameError = AuthValidator.validateUsername(username);
    if (usernameError != null) {
      return RegisterResult(success: false, errorMessage: usernameError);
    }

    final passwordError = AuthValidator.validatePassword(password);
    if (passwordError != null) {
      return RegisterResult(success: false, errorMessage: passwordError);
    }

    final box = await _getBox();
    final cleanName = username.trim();
    final userKey = '$_userKeyPrefix${cleanName.toLowerCase()}';

    // Strict duplicate check: do NOT allow re-registration with existing username
    if (box.containsKey(userKey)) {
      return const RegisterResult(
        success: false,
        errorMessage: 'Bu kullanıcı adı zaten alınmış! Lütfen farklı bir kaptan adı seçin.',
      );
    }

    final userMap = <String, dynamic>{
      'username': cleanName,
      'password': password,
      'avatarIndex': 0,
      'totalStreak': 0,
      'notificationsEnabled': true,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await box.put(userKey, userMap);
    await box.put(_activeUserKey, cleanName);

    final createdUser = UserModel(
      username: cleanName,
      avatarIndex: 0,
      totalStreak: 0,
      notificationsEnabled: true,
    );

    return RegisterResult(success: true, user: createdUser);
  }

  /// Verifies credentials and logs in the user.
  Future<UserModel?> loginUser({
    required String username,
    required String password,
  }) async {
    final cleanName = username.trim();
    if (cleanName.isEmpty || password.isEmpty) return null;

    final box = await _getBox();
    final userKey = '$_userKeyPrefix${cleanName.toLowerCase()}';

    final rawData = box.get(userKey);
    if (rawData is! Map) return null;

    final userMap = Map<String, dynamic>.from(rawData);
    final storedPass = userMap['password'] as String? ?? userMap['passwordHash'] as String?;

    if (storedPass == null) return null;

    // Check direct match or legacy match
    final isMatch = storedPass == password || storedPass.endsWith(password);
    if (!isMatch) return null;

    // Normalize to direct password in Hive
    if (userMap['password'] != password) {
      userMap['password'] = password;
      userMap.remove('passwordHash');
      userMap.remove('salt');
      await box.put(userKey, userMap);
    }

    await box.put(_activeUserKey, userMap['username'] as String);

    return UserModel.fromMap(userMap);
  }

  /// Updates a user's password in O(1) time.
  Future<bool> updatePassword({
    required String username,
    required String newPassword,
  }) async {
    final passwordError = AuthValidator.validatePassword(newPassword);
    if (passwordError != null) return false;

    final box = await _getBox();
    final cleanName = username.trim();
    final userKey = '$_userKeyPrefix${cleanName.toLowerCase()}';

    final rawData = box.get(userKey);
    if (rawData is! Map) return false;

    final userMap = Map<String, dynamic>.from(rawData);
    userMap['password'] = newPassword;
    userMap.remove('passwordHash');
    userMap.remove('salt');

    await box.put(userKey, userMap);
    return true;
  }

  /// Gets the currently logged in active user.
  Future<UserModel?> getActiveUser() async {
    final box = await _getBox();
    final activeUsername = box.get(_activeUserKey) as String?;
    if (activeUsername == null || activeUsername.isEmpty) return null;

    final userKey = '$_userKeyPrefix${activeUsername.toLowerCase()}';
    final rawData = box.get(userKey);
    if (rawData is! Map) return null;

    return UserModel.fromMap(Map<String, dynamic>.from(rawData));
  }

  Future<void> updateActiveUserAvatar(int avatarIndex) async {
    final box = await _getBox();
    final activeUsername = box.get(_activeUserKey) as String?;
    if (activeUsername == null) return;

    final userKey = '$_userKeyPrefix${activeUsername.toLowerCase()}';
    final rawData = box.get(userKey);
    if (rawData is! Map) return;

    final userMap = Map<String, dynamic>.from(rawData);
    userMap['avatarIndex'] = avatarIndex;
    await box.put(userKey, userMap);
  }

  Future<void> updateActiveUserTotalStreak(int totalStreak) async {
    final box = await _getBox();
    final activeUsername = box.get(_activeUserKey) as String?;
    if (activeUsername == null) return;

    final userKey = '$_userKeyPrefix${activeUsername.toLowerCase()}';
    final rawData = box.get(userKey);
    if (rawData is! Map) return;

    final userMap = Map<String, dynamic>.from(rawData);
    userMap['totalStreak'] = totalStreak;
    await box.put(userKey, userMap);
  }

  Future<void> updateActiveUserNotifications(bool enabled) async {
    final box = await _getBox();
    final activeUsername = box.get(_activeUserKey) as String?;
    if (activeUsername == null) return;

    final userKey = '$_userKeyPrefix${activeUsername.toLowerCase()}';
    final rawData = box.get(userKey);
    if (rawData is! Map) return;

    final userMap = Map<String, dynamic>.from(rawData);
    userMap['notificationsEnabled'] = enabled;
    await box.put(userKey, userMap);
  }

  /// Returns all registered users for leaderboard sorted by streak.
  Future<List<UserModel>> getAllUsers() async {
    final box = await _getBox();
    final list = <UserModel>[];

    for (final key in box.keys) {
      if (key is String && key.startsWith(_userKeyPrefix)) {
        final val = box.get(key);
        if (val is Map) {
          list.add(UserModel.fromMap(Map<String, dynamic>.from(val)));
        }
      }
    }

    list.sort((a, b) => b.totalStreak.compareTo(a.totalStreak));
    return list;
  }

  Future<void> logout() async {
    final box = await _getBox();
    await box.delete(_activeUserKey);
  }
}
