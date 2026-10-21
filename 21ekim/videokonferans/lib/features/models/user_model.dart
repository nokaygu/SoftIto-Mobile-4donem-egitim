/// Kullanıcı Modeli
class UserModel {
  final String username;
  final String displayName;
  final int avatarId;
  final bool isOnline;
  final bool inCall;
  final String? currentRoom;

  const UserModel({
    required this.username,
    required this.displayName,
    this.avatarId = 0,
    this.isOnline = true,
    this.inCall = false,
    this.currentRoom,
  });

  UserModel copyWith({
    String? username,
    String? displayName,
    int? avatarId,
    bool? isOnline,
    bool? inCall,
    String? currentRoom,
  }) {
    return UserModel(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarId: avatarId ?? this.avatarId,
      isOnline: isOnline ?? this.isOnline,
      inCall: inCall ?? this.inCall,
      currentRoom: currentRoom ?? this.currentRoom,
    );
  }
}
