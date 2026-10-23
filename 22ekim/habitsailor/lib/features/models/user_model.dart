class UserModel {
  final String username;
  final int avatarIndex;
  final int totalStreak;
  final bool notificationsEnabled;

  const UserModel({
    required this.username,
    this.avatarIndex = 0,
    this.totalStreak = 0,
    this.notificationsEnabled = true,
  });

  UserModel copyWith({
    String? username,
    int? avatarIndex,
    int? totalStreak,
    bool? notificationsEnabled,
  }) {
    return UserModel(
      username: username ?? this.username,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      totalStreak: totalStreak ?? this.totalStreak,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'avatarIndex': avatarIndex,
      'totalStreak': totalStreak,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      username: map['username'] as String? ?? '',
      avatarIndex: (map['avatarIndex'] as num?)?.toInt() ?? 0,
      totalStreak: (map['totalStreak'] as num?)?.toInt() ?? 0,
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
    );
  }
}
