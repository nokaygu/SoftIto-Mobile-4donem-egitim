class HabitTaskModel {
  final String id;
  final String title;
  final String? timeString;
  final int difficulty; // 0: Baby Blue, 1: Normal Blue, 2: Navy Urgent
  final bool isRecurring;
  final List<int> repeatWeekdays; // 1 = Monday, 7 = Sunday
  final String? specificDateIso; // YYYY-MM-DD for non-recurring
  final List<String> completedDatesIso; // YYYY-MM-DD list
  final int streakCount;

  const HabitTaskModel({
    required this.id,
    required this.title,
    this.timeString,
    this.difficulty = 0,
    this.isRecurring = false,
    this.repeatWeekdays = const <int>[],
    this.specificDateIso,
    this.completedDatesIso = const <String>[],
    this.streakCount = 0,
  });

  static String formatDateToIso(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  bool isCompletedOn(DateTime date) {
    final key = formatDateToIso(date);
    return completedDatesIso.contains(key);
  }

  bool isDueOn(DateTime date) {
    if (isRecurring) {
      return repeatWeekdays.contains(date.weekday);
    } else {
      if (specificDateIso == null || specificDateIso!.isEmpty) {
        return false;
      }
      return specificDateIso == formatDateToIso(date);
    }
  }

  HabitTaskModel copyWith({
    String? id,
    String? title,
    String? timeString,
    int? difficulty,
    bool? isRecurring,
    List<int>? repeatWeekdays,
    String? specificDateIso,
    List<String>? completedDatesIso,
    int? streakCount,
  }) {
    return HabitTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      timeString: timeString ?? this.timeString,
      difficulty: difficulty ?? this.difficulty,
      isRecurring: isRecurring ?? this.isRecurring,
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      specificDateIso: specificDateIso ?? this.specificDateIso,
      completedDatesIso: completedDatesIso ?? this.completedDatesIso,
      streakCount: streakCount ?? this.streakCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'timeString': timeString,
      'difficulty': difficulty,
      'isRecurring': isRecurring,
      'repeatWeekdays': repeatWeekdays,
      'specificDateIso': specificDateIso,
      'completedDatesIso': completedDatesIso,
      'streakCount': streakCount,
    };
  }

  factory HabitTaskModel.fromMap(Map<dynamic, dynamic> map) {
    final rawWeekdays = map['repeatWeekdays'];
    final List<int> weekdays = [];
    if (rawWeekdays is List) {
      for (final item in rawWeekdays) {
        if (item is num) {
          weekdays.add(item.toInt());
        }
      }
    }

    final rawCompleted = map['completedDatesIso'];
    final List<String> completed = [];
    if (rawCompleted is List) {
      for (final item in rawCompleted) {
        if (item is String) {
          completed.add(item);
        }
      }
    }

    return HabitTaskModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      timeString: map['timeString'] as String?,
      difficulty: (map['difficulty'] as num?)?.toInt() ?? 0,
      isRecurring: map['isRecurring'] as bool? ?? false,
      repeatWeekdays: weekdays,
      specificDateIso: map['specificDateIso'] as String?,
      completedDatesIso: completed,
      streakCount: (map['streakCount'] as num?)?.toInt() ?? 0,
    );
  }
}
