import 'package:flutter/foundation.dart';
import '../models/chat_message_model.dart';
import '../models/friend_model.dart';

/// Arkadaş listesi, durumları ve özel mesajlaşma kontrolcüsü
class FriendsController {
  final ValueNotifier<List<FriendModel>> friends = ValueNotifier<List<FriendModel>>([
    const FriendModel(
      username: 'ayse',
      displayName: 'Ayşe Demir',
      avatarId: 2,
      isOnline: true,
      inCall: false,
      statusMessage: 'VizyonMeet projesini inceliyorum 🚀',
    ),
    const FriendModel(
      username: 'mehmet',
      displayName: 'Mehmet Can',
      avatarId: 3,
      isOnline: true,
      inCall: true,
      currentRoom: 'proje_toplantisi',
      statusMessage: 'Toplantıdayım, acilse yazın.',
    ),
    const FriendModel(
      username: 'zeynep',
      displayName: 'Zeynep Yıldız',
      avatarId: 4,
      isOnline: false,
      inCall: false,
      statusMessage: 'Yarın görüşmek üzere.',
    ),
  ]);

  final ValueNotifier<Map<String, List<ChatMessageModel>>> privateChats =
      ValueNotifier<Map<String, List<ChatMessageModel>>>({});

  bool isFriend(String username) {
    return friends.value.any((f) => f.username.toLowerCase() == username.toLowerCase());
  }

  bool addFriend({
    required String username,
    required String displayName,
    required int avatarId,
  }) {
    if (isFriend(username)) return false;

    final newFriend = FriendModel(
      username: username,
      displayName: displayName,
      avatarId: avatarId,
      isOnline: true,
      statusMessage: 'Yeni arkadaş eklendi!',
    );

    friends.value = [...friends.value, newFriend];
    return true;
  }

  void sendPrivateMessage({
    required String toUsername,
    required String senderUsername,
    required String senderDisplayName,
    required int senderAvatarId,
    required String message,
  }) {
    final clean = message.trim();
    if (clean.isEmpty) return;

    final msg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderUsername: senderUsername,
      senderDisplayName: senderDisplayName,
      senderAvatarId: senderAvatarId,
      message: clean,
      timestamp: DateTime.now(),
      isPrivate: true,
    );

    final currentMap = Map<String, List<ChatMessageModel>>.from(privateChats.value);
    final list = List<ChatMessageModel>.from(currentMap[toUsername] ?? []);
    list.add(msg);
    currentMap[toUsername] = list;

    privateChats.value = currentMap;
  }

  List<ChatMessageModel> getMessagesFor(String friendUsername) {
    return privateChats.value[friendUsername] ?? [];
  }
}
