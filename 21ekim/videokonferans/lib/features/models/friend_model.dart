/// Arkadaş ve özel bağlantı modeli
class FriendModel {
  final String username;
  final String displayName;
  final int avatarId;
  final bool isOnline;
  final bool inCall;
  final String? currentRoom;
  final String statusMessage;

  const FriendModel({
    required this.username,
    required this.displayName,
    required this.avatarId,
    this.isOnline = true,
    this.inCall = false,
    this.currentRoom,
    this.statusMessage = '',
  });

  FriendModel copyWith({
    String? username,
    String? displayName,
    int? avatarId,
    bool? isOnline,
    bool? inCall,
    String? currentRoom,
    String? statusMessage,
  }) {
    return FriendModel(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarId: avatarId ?? this.avatarId,
      isOnline: isOnline ?? this.isOnline,
      inCall: inCall ?? this.inCall,
      currentRoom: currentRoom ?? this.currentRoom,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}
