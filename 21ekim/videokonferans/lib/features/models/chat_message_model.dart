/// Konferans içi ve özel sohbet mesaj modeli
class ChatMessageModel {
  final String id;
  final String senderUsername;
  final String senderDisplayName;
  final int senderAvatarId;
  final String message;
  final DateTime timestamp;
  final bool isSystem;
  final bool isPrivate;

  const ChatMessageModel({
    required this.id,
    required this.senderUsername,
    required this.senderDisplayName,
    required this.senderAvatarId,
    required this.message,
    required this.timestamp,
    this.isSystem = false,
    this.isPrivate = false,
  });
}
