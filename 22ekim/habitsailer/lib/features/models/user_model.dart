class UserModel {
  final String username;
  final int avatarIndex;
  final int totalStreak;

  const UserModel({
    required this.username,
    this.avatarIndex = 0,
    this.totalStreak = 0,
  });

  UserModel copyWith({
    String? username,
    int? avatarIndex,
    int? totalStreak,
  }) {
    return UserModel(
      username: username ?? this.username,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      totalStreak: totalStreak ?? this.totalStreak,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'avatarIndex': avatarIndex,
      'totalStreak': totalStreak,
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      username: map['username'] as String? ?? '',
      avatarIndex: (map['avatarIndex'] as num?)?.toInt() ?? 0,
      totalStreak: (map['totalStreak'] as num?)?.toInt() ?? 0,
    );
  }
}
