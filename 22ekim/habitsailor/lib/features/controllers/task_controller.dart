import 'package:flutter/foundation.dart';
import '../../core/storage/hive_task_storage.dart';
import '../models/habit_task_model.dart';

class TaskController extends ChangeNotifier {
  final HiveTaskStorage storage;
  List<HabitTaskModel> _tasks = [];
  bool _isLoading = false;
  String? _currentUsername;

  TaskController({required this.storage});

  List<HabitTaskModel> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get currentUsername => _currentUsername;

  /// Loads tasks for a specific user and seeds demo tasks if first time.
  Future<void> loadTasksForUser(String username) async {
    _currentUsername = username;
    await storage.seedDemoTasksIfEmptyForUser(username);
    loadTasks();
  }

  void loadTasks() {
    _isLoading = true;
    notifyListeners();

    try {
      final rawTasks = (_currentUsername != null && _currentUsername!.isNotEmpty)
          ? storage.getTasksForUser(_currentUsername!)
          : storage.getAllTasks();
      final now = DateTime.now();
      _tasks = rawTasks.map((t) {
        if (t.isRecurring) {
          return t.copyWith(streakCount: t.calculateStreak(now));
        }
        return t;
      }).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearTasks() {
    _tasks = [];
    _currentUsername = null;
    notifyListeners();
  }

  List<HabitTaskModel> getTasksForDate(DateTime date) {
    final list = _tasks.where((t) => t.isDueOn(date)).toList();
    // Sort urgent (2) first, then (1), then (0)
    list.sort((a, b) => b.difficulty.compareTo(a.difficulty));
    return list;
  }

  List<HabitTaskModel> getPendingTasksForDate(DateTime date) {
    final list =
        _tasks.where((t) => t.isDueOn(date) && !t.isCompletedOn(date)).toList();
    list.sort((a, b) => b.difficulty.compareTo(a.difficulty));
    return list;
  }

  List<HabitTaskModel> getCompletedTasksForDate(DateTime date) {
    final list =
        _tasks.where((t) => t.isDueOn(date) && t.isCompletedOn(date)).toList();
    list.sort((a, b) => b.difficulty.compareTo(a.difficulty));
    return list;
  }

  List<HabitTaskModel> getUpcomingTasks(DateTime fromDate) {
    final todayIso = HabitTaskModel.formatDateToIso(fromDate);
    final upcoming = <HabitTaskModel>[];

    for (final task in _tasks) {
      if (!task.isRecurring) {
        if (task.specificDateIso != null &&
            task.specificDateIso!.compareTo(todayIso) > 0) {
          upcoming.add(task);
        }
      } else {
        // Recurring tasks that repeat on other days
        upcoming.add(task);
      }
    }
    return upcoming;
  }

  bool hasUrgentTaskOnDate(DateTime date) {
    final dueTasks = getTasksForDate(date);
    return dueTasks.any((t) => t.difficulty == 2);
  }

  bool hasAnyTaskOnDate(DateTime date) {
    return _tasks.any((t) => t.isDueOn(date));
  }

  /// Extracts a meaningful 1-2 word snippet from tasks for a given date,
  /// skipping repetitive stop-words like 'sabah', 'akşam', 'günlük', 'her'.
  /// Example: "Sabah Rotasını ve Hedefleri Belirle" -> "Rotayı Belirle"
  String? getMeaningfulTaskSnippetForDate(DateTime date) {
    final dueTasks = getTasksForDate(date);
    if (dueTasks.isEmpty) return null;

    const stopWords = <String>{
      'sabah',
      'akşam',
      'öğle',
      'günlük',
      'her',
      've',
      'bir',
      'ile',
      'için',
      'düzenli',
      'yap',
      'et',
    };

    for (final task in dueTasks) {
      final words = task.title.trim().split(RegExp(r'\s+'));
      final meaningful = words
          .where((w) => !stopWords.contains(w.toLowerCase().replaceAll(RegExp(r'[^a-zA-ZçğıöşüÇĞİÖŞÜ]'), '')))
          .toList();

      if (meaningful.isNotEmpty) {
        if (meaningful.length >= 2 && ('${meaningful[0]} ${meaningful[1]}'.length <= 15)) {
          return '${meaningful[0]} ${meaningful[1]}';
        }
        return meaningful[0];
      } else if (words.isNotEmpty) {
        return words[0];
      }
    }
    return null;
  }

  String? getFirstWordForDate(DateTime date) {
    return getMeaningfulTaskSnippetForDate(date);
  }

  int getTotalStreakPoints() {
    var total = 0;
    for (final task in _tasks) {
      if (task.isRecurring) {
        total += task.streakCount;
      }
    }
    return total;
  }

  Future<void> createOrUpdateTask(HabitTaskModel task) async {
    final assignedUserId = task.userId.isNotEmpty
        ? task.userId
        : (_currentUsername ?? '');

    final taskToSave = task.copyWith(
      userId: assignedUserId,
      streakCount: task.isRecurring ? task.calculateStreak(DateTime.now()) : 0,
    );

    await storage.saveOrUpdateTask(taskToSave);
    loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await storage.deleteTask(taskId);
    loadTasks();
  }

  Future<void> toggleTaskCompletion(String taskId, DateTime date) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _tasks[index];
    final dateKey = HabitTaskModel.formatDateToIso(date);
    final isAlreadyCompleted = task.completedDatesIso.contains(dateKey);

    final updatedCompleted = List<String>.from(task.completedDatesIso);

    if (isAlreadyCompleted) {
      updatedCompleted.remove(dateKey);
    } else {
      updatedCompleted.add(dateKey);
    }

    final tempTask = task.copyWith(completedDatesIso: updatedCompleted);
    final updatedStreak = tempTask.isRecurring
        ? tempTask.calculateStreak(DateTime.now())
        : 0;

    final updatedTask = tempTask.copyWith(streakCount: updatedStreak);

    await storage.saveOrUpdateTask(updatedTask);
    loadTasks();
  }

  Future<int> batchCompleteTasks(
    List<String> taskIds,
    DateTime date, {
    String? optionalNote,
  }) async {
    final dateKey = HabitTaskModel.formatDateToIso(date);
    var earnedPoints = 0;

    for (final taskId in taskIds) {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index == -1) continue;

      final task = _tasks[index];
      final updatedCompleted = List<String>.from(task.completedDatesIso);
      if (!updatedCompleted.contains(dateKey)) {
        updatedCompleted.add(dateKey);
      }

      final updatedNotes = Map<String, String>.from(task.completionNotes);
      if (optionalNote != null && optionalNote.trim().isNotEmpty) {
        updatedNotes[dateKey] = optionalNote.trim();
      }

      final tempTask = task.copyWith(
        completedDatesIso: updatedCompleted,
        completionNotes: updatedNotes,
      );
      final updatedStreak = tempTask.isRecurring
          ? tempTask.calculateStreak(DateTime.now())
          : 0;

      final updatedTask = tempTask.copyWith(streakCount: updatedStreak);
      earnedPoints += (task.difficulty + 1) * 10;
      await storage.saveOrUpdateTask(updatedTask);
    }

    loadTasks();
    return earnedPoints;
  }

  Future<void> updateTaskCompletionNote(
    String taskId,
    DateTime date,
    String note,
  ) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _tasks[index];
    final dateKey = HabitTaskModel.formatDateToIso(date);
    final updatedNotes = Map<String, String>.from(task.completionNotes);

    if (note.trim().isEmpty) {
      updatedNotes.remove(dateKey);
    } else {
      updatedNotes[dateKey] = note.trim();
    }

    final updatedTask = task.copyWith(completionNotes: updatedNotes);
    await storage.saveOrUpdateTask(updatedTask);
    loadTasks();
  }

  Future<void> uncompleteTask(String taskId, DateTime date) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _tasks[index];
    final dateKey = HabitTaskModel.formatDateToIso(date);
    final updatedCompleted = List<String>.from(task.completedDatesIso);
    updatedCompleted.remove(dateKey);

    final updatedNotes = Map<String, String>.from(task.completionNotes);
    updatedNotes.remove(dateKey);

    final tempTask = task.copyWith(
      completedDatesIso: updatedCompleted,
      completionNotes: updatedNotes,
    );
    final updatedStreak = tempTask.isRecurring
        ? tempTask.calculateStreak(DateTime.now())
        : 0;

    final updatedTask = tempTask.copyWith(streakCount: updatedStreak);
    await storage.saveOrUpdateTask(updatedTask);
    loadTasks();
  }

  bool isWeeklyRouteCompleted(DateTime referenceDate) {
    final recurringTasks = _tasks.where((t) => t.isRecurring).toList();
    if (recurringTasks.isEmpty) return false;

    final currentWeekday = referenceDate.weekday; // 1 (Mon) .. 7 (Sun)
    for (final task in recurringTasks) {
      for (var day = 1; day <= currentWeekday; day++) {
        if (task.repeatWeekdays.contains(day)) {
          final dayDate =
              referenceDate.subtract(Duration(days: currentWeekday - day));
          if (!task.isCompletedOn(dayDate)) {
            return false;
          }
        }
      }
    }
    return true;
  }
}
