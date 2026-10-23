class CaptainLogModel {
  final String id;
  final String userId;
  final String dateIso; // YYYY-MM-DD
  final String timeString; // HH:mm
  final String title;
  final String content;
  final String weather; // ☀️ Sakin Deniz, ⛵ Pupayelken, 🌊 Dalgalı, ⚡ Fırtına, ⚓ Liman
  final String createdAtIso;

  const CaptainLogModel({
    required this.id,
    required this.userId,
    required this.dateIso,
    required this.timeString,
    required this.title,
    required this.content,
    this.weather = '☀️ Sakin Deniz',
    required this.createdAtIso,
  });

  CaptainLogModel copyWith({
    String? id,
    String? userId,
    String? dateIso,
    String? timeString,
    String? title,
    String? content,
    String? weather,
    String? createdAtIso,
  }) {
    return CaptainLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateIso: dateIso ?? this.dateIso,
      timeString: timeString ?? this.timeString,
      title: title ?? this.title,
      content: content ?? this.content,
      weather: weather ?? this.weather,
      createdAtIso: createdAtIso ?? this.createdAtIso,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'dateIso': dateIso,
      'timeString': timeString,
      'title': title,
      'content': content,
      'weather': weather,
      'createdAtIso': createdAtIso,
    };
  }

  factory CaptainLogModel.fromMap(Map<dynamic, dynamic> map) {
    return CaptainLogModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      dateIso: map['dateIso'] as String? ?? '',
      timeString: map['timeString'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      weather: map['weather'] as String? ?? '☀️ Sakin Deniz',
      createdAtIso: map['createdAtIso'] as String? ?? '',
    );
  }
}
