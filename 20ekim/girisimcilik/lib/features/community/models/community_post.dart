class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.startupName,
    required this.isVerifiedFounder,
    required this.content,
    required this.timestamp,
    required this.likesCount,
    required this.isLiked,
    required this.commentsCount,
  });

  final String id;
  final String authorName;
  final String authorHandle;
  final String startupName;
  final bool isVerifiedFounder;
  final String content;
  final String timestamp;
  final int likesCount;
  final bool isLiked;
  final int commentsCount;

  CommunityPost copyWith({
    String? id,
    String? authorName,
    String? authorHandle,
    String? startupName,
    bool? isVerifiedFounder,
    String? content,
    String? timestamp,
    int? likesCount,
    bool? isLiked,
    int? commentsCount,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorHandle: authorHandle ?? this.authorHandle,
      startupName: startupName ?? this.startupName,
      isVerifiedFounder: isVerifiedFounder ?? this.isVerifiedFounder,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
