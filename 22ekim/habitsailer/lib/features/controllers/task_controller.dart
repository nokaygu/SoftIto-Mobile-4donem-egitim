import 'package:flutter/foundation.dart';
import '../../core/storage/hive_task_storage.dart';
import '../models/habit_task_model.dart';

class TaskController extends ChangeNotifier {
  final HiveTaskStorage storage;
  List<HabitTaskModel> _tasks = [];
  bool _isLoading = false;

  TaskController({required this.storage});

  List<HabitTaskModel> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;

  void loadTasks() {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = storage.getAllTasks();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<HabitTaskModel> getTasksForDate(DateTime date) {
    final list = _tasks.where((t) => t.isDueOn(date)).toList();
    // Sort urgent (2) first, then (1), then (0)
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
        // Recurring tasks are upcoming if they repeat in next 7 days
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

  String? getFirstWordForDate(DateTime date) {
    final dueTasks = getTasksForDate(date);
    if (dueTasks.isEmpty) return null;
    final firstTitle = dueTasks.first.title.trim();
    if (firstTitle.isEmpty) return null;
    final words = firstTitle.split(RegExp(r'\s+'));
    return words.isNotEmpty ? words.first : null;
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
    await storage.saveOrUpdateTask(task);
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
    var updatedStreak = task.streakCount;

    if (isAlreadyCompleted) {
      updatedCompleted.remove(dateKey);
      if (task.isRecurring && updatedStreak > 0) {
        updatedStreak -= 1;
      }
    } else {
      updatedCompleted.add(dateKey);
      if (task.isRecurring) {
        updatedStreak += 1;
      }
    }

    final updatedTask = task.copyWith(
      completedDatesIso: updatedCompleted,
      streakCount: updatedStreak,
    );

    await storage.saveOrUpdateTask(updatedTask);
    loadTasks();
  }
}
