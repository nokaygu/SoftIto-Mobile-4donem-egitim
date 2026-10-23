class HabitTaskModel {
  final String id;
  final String userId;
  final String title;
  final String? timeString;
  final int difficulty; // 0: Baby Blue, 1: Normal Blue, 2: Navy Urgent
  final bool isRecurring;
  final List<int> repeatWeekdays; // 1 = Monday, 7 = Sunday
  final String? specificDateIso; // YYYY-MM-DD for non-recurring
  final List<String> completedDatesIso; // YYYY-MM-DD list
  final int streakCount;
  final Map<String, String> completionNotes; // dateIso -> Captain's reflection/note

  const HabitTaskModel({
    required this.id,
    this.userId = '',
    required this.title,
    this.timeString,
    this.difficulty = 0,
    this.isRecurring = false,
    this.repeatWeekdays = const <int>[],
    this.specificDateIso,
    this.completedDatesIso = const <String>[],
    this.streakCount = 0,
    this.completionNotes = const <String, String>{},
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

  String? getNoteForDate(DateTime date) {
    final key = formatDateToIso(date);
    return completionNotes[key];
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

  /// Calculates the streak based on consecutive completed due dates up to [referenceDate].
  /// Follows the "Don't Break The Chain" principle.
  int calculateStreak(DateTime referenceDate) {
    if (!isRecurring || repeatWeekdays.isEmpty) {
      return 0;
    }

    final completedSet = completedDatesIso.toSet();
    var current = DateTime(referenceDate.year, referenceDate.month, referenceDate.day);
    var streak = 0;

    final isDueToday = repeatWeekdays.contains(current.weekday);
    final todayIso = formatDateToIso(current);

    if (isDueToday) {
      if (completedSet.contains(todayIso)) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        // Due today but not yet completed. Look from previous due day without breaking chain.
        current = current.subtract(const Duration(days: 1));
      }
    } else {
      // Not due today, start from previous days
      current = current.subtract(const Duration(days: 1));
    }

    // Inspect historical days (up to 365 days back)
    for (var i = 0; i < 365; i++) {
      if (repeatWeekdays.contains(current.weekday)) {
        final dateIso = formatDateToIso(current);
        if (completedSet.contains(dateIso)) {
          streak++;
        } else {
          // Missed due date found -> streak stops here
          break;
        }
      }
      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  }

  HabitTaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? timeString,
    int? difficulty,
    bool? isRecurring,
    List<int>? repeatWeekdays,
    String? specificDateIso,
    List<String>? completedDatesIso,
    int? streakCount,
    Map<String, String>? completionNotes,
  }) {
    return HabitTaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      timeString: timeString ?? this.timeString,
      difficulty: difficulty ?? this.difficulty,
      isRecurring: isRecurring ?? this.isRecurring,
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      specificDateIso: specificDateIso ?? this.specificDateIso,
      completedDatesIso: completedDatesIso ?? this.completedDatesIso,
      streakCount: streakCount ?? this.streakCount,
      completionNotes: completionNotes ?? this.completionNotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'timeString': timeString,
      'difficulty': difficulty,
      'isRecurring': isRecurring,
      'repeatWeekdays': repeatWeekdays,
      'specificDateIso': specificDateIso,
      'completedDatesIso': completedDatesIso,
      'streakCount': streakCount,
      'completionNotes': completionNotes,
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

    final rawNotes = map['completionNotes'];
    final Map<String, String> notes = {};
    if (rawNotes is Map) {
      for (final entry in rawNotes.entries) {
        if (entry.key != null && entry.value != null) {
          notes[entry.key.toString()] = entry.value.toString();
        }
      }
    }

    return HabitTaskModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      timeString: map['timeString'] as String?,
      difficulty: (map['difficulty'] as num?)?.toInt() ?? 0,
      isRecurring: map['isRecurring'] as bool? ?? false,
      repeatWeekdays: weekdays,
      specificDateIso: map['specificDateIso'] as String?,
      completedDatesIso: completed,
      streakCount: (map['streakCount'] as num?)?.toInt() ?? 0,
      completionNotes: notes,
    );
  }
}
