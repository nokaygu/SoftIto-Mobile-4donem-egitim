/// Takvim ızgarasındaki (Grid) tek bir gün hücresinin durumunu temsil eden değişmez (immutable) model.
class CalendarDayModel {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final String? moodEmoji;

  const CalendarDayModel({
    required this.date,
    required this.isToday,
    required this.isSelected,
    this.moodEmoji,
  });

  int get dayNumber => date.day;

  bool get hasEntry => moodEmoji != null && moodEmoji!.isNotEmpty;

  CalendarDayModel copyWith({
    DateTime? date,
    bool? isToday,
    bool? isSelected,
    String? moodEmoji,
  }) {
    return CalendarDayModel(
      date: date ?? this.date,
      isToday: isToday ?? this.isToday,
      isSelected: isSelected ?? this.isSelected,
      moodEmoji: moodEmoji ?? this.moodEmoji,
    );
  }
}
