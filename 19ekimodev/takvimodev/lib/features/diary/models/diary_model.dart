/// Ruh hali (Mood) seçeneği modeli.
class MoodOption {
  final String emoji;
  final String label;

  const MoodOption({required this.emoji, required this.label});

  static const List<MoodOption> presets = [
    MoodOption(emoji: '😊', label: 'Mutlu'),
    MoodOption(emoji: '😌', label: 'Huzurlu'),
    MoodOption(emoji: '🤩', label: 'Harika'),
    MoodOption(emoji: '🤔', label: 'Düşünceli'),
    MoodOption(emoji: '😔', label: 'Üzgün'),
    MoodOption(emoji: '🔥', label: 'Enerjik'),
  ];

  static String labelForEmoji(String emoji) {
    for (final option in presets) {
      if (option.emoji == emoji) return option.label;
    }
    return 'Anı';
  }
}

/// Bir güne ait günlük kaydını temsil eden değişmez (immutable) veri modeli.
class DiaryEntryModel {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final String moodEmoji;

  const DiaryEntryModel({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.moodEmoji,
  });

  DiaryEntryModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? content,
    String? moodEmoji,
  }) {
    return DiaryEntryModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      moodEmoji: moodEmoji ?? this.moodEmoji,
    );
  }

  factory DiaryEntryModel.fromJson(Map<String, dynamic> json) {
    return DiaryEntryModel(
      id: json['id'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      moodEmoji: json['mood_emoji'] as String? ?? '😊',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'content': content,
      'mood_emoji': moodEmoji,
    };
  }
}
