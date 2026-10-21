/// Aktif ve Açık Konferans Odası Modeli (Agora RTC Uyumlu)
class MeetingRoomModel {
  final String id;
  final String channelName;
  final String title;
  final String description;
  final String hostUsername;
  final String hostDisplayName;
  final int hostAvatarId;
  final int participantCount;
  final List<int> participantAvatars;
  final String category;
  final DateTime createdAt;
  final bool isLive;

  const MeetingRoomModel({
    required this.id,
    required this.channelName,
    required this.title,
    required this.description,
    required this.hostUsername,
    required this.hostDisplayName,
    required this.hostAvatarId,
    required this.participantCount,
    this.participantAvatars = const <int>[],
    required this.category,
    required this.createdAt,
    this.isLive = true,
  });

  MeetingRoomModel copyWith({
    String? id,
    String? channelName,
    String? title,
    String? description,
    String? hostUsername,
    String? hostDisplayName,
    int? hostAvatarId,
    int? participantCount,
    List<int>? participantAvatars,
    String? category,
    DateTime? createdAt,
    bool? isLive,
  }) {
    return MeetingRoomModel(
      id: id ?? this.id,
      channelName: channelName ?? this.channelName,
      title: title ?? this.title,
      description: description ?? this.description,
      hostUsername: hostUsername ?? this.hostUsername,
      hostDisplayName: hostDisplayName ?? this.hostDisplayName,
      hostAvatarId: hostAvatarId ?? this.hostAvatarId,
      participantCount: participantCount ?? this.participantCount,
      participantAvatars: participantAvatars ?? this.participantAvatars,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isLive: isLive ?? this.isLive,
    );
  }
}
