import 'package:hive_flutter/hive_flutter.dart';
import '../../features/models/habit_task_model.dart';

class HiveTaskStorage {
  static const String boxName = 'habitsailor_tasks_box';
  static const String _legacyBoxName = 'habitsailer_tasks_box';
  Box<dynamic>? boxInstance;

  HiveTaskStorage({this.boxInstance});

  Future<void> init() async {
    await Hive.initFlutter();
    boxInstance = await Hive.openBox<dynamic>(boxName);

    // Backward compatibility: migrate from legacy box if new box is empty
    if (boxInstance!.isEmpty && await Hive.boxExists(_legacyBoxName)) {
      final legacyBox = await Hive.openBox<dynamic>(_legacyBoxName);
      if (legacyBox.isNotEmpty) {
        for (var i = 0; i < legacyBox.length; i++) {
          final item = legacyBox.getAt(i);
          if (item is Map && item['id'] != null) {
            await boxInstance!.put(item['id'], item);
          } else {
            await boxInstance!.add(item);
          }
        }
      }
      await legacyBox.close();
    }
  }

  Box<dynamic> get box {
    final b = boxInstance;
    if (b == null || !b.isOpen) {
      throw StateError('HiveTaskStorage has not been initialized. Call init() first.');
    }
    return b;
  }

  /// O(1) indexed or user-filtered list of tasks.
  List<HabitTaskModel> getTasksForUser(String username) {
    final List<HabitTaskModel> tasks = [];
    final cleanUsername = username.trim().toLowerCase();

    for (final item in box.values) {
      if (item is Map) {
        final task = HabitTaskModel.fromMap(item);
        final taskUser = task.userId.trim().toLowerCase();

        // Matches this user, or legacy tasks without userId assigned to current user
        if (taskUser == cleanUsername || taskUser.isEmpty) {
          tasks.add(task.userId.isEmpty ? task.copyWith(userId: username) : task);
        }
      }
    }
    return tasks;
  }

  List<HabitTaskModel> getAllTasks() {
    final List<HabitTaskModel> tasks = [];
    for (final item in box.values) {
      if (item is Map) {
        tasks.add(HabitTaskModel.fromMap(item));
      }
    }
    return tasks;
  }

  /// O(1) Key-Value Put into Hive using task.id
  Future<void> saveOrUpdateTask(HabitTaskModel task) async {
    await box.put(task.id, task.toMap());
  }

  /// O(1) Key-Value Delete from Hive using task.id
  Future<void> deleteTask(String taskId) async {
    await box.delete(taskId);

    // Fallback cleanup if task was previously added with auto-increment key
    for (final key in box.keys) {
      final item = box.get(key);
      if (item is Map && item['id'] == taskId) {
        await box.delete(key);
        break;
      }
    }
  }

  /// Seeds demo tasks specifically for a given user if they don't have tasks yet.
  Future<void> seedDemoTasksIfEmptyForUser(String username) async {
    final cleanUsername = username.trim();
    if (cleanUsername.isEmpty) return;

    final existing = getTasksForUser(cleanUsername);
    if (existing.isNotEmpty) return;

    final now = DateTime.now();
    final todayIso = HabitTaskModel.formatDateToIso(now);
    final tomorrowIso = HabitTaskModel.formatDateToIso(now.add(const Duration(days: 1)));

    final demoTasks = [
      HabitTaskModel(
        id: '${cleanUsername}_sail_task_1',
        userId: cleanUsername,
        title: 'Sabah Rotasını ve Hedefleri Belirle',
        timeString: '08:00',
        difficulty: 1, // Normal Mavi
        isRecurring: true,
        repeatWeekdays: const [1, 2, 3, 4, 5, 6, 7], // Every day
        streakCount: 5,
        completedDatesIso: const [],
      ),
      HabitTaskModel(
        id: '${cleanUsername}_sail_task_2',
        userId: cleanUsername,
        title: 'Acil Fırtına Tedbirleri ve Güverte Kontrolü',
        timeString: '10:30',
        difficulty: 2, // Lacivert / Acil
        isRecurring: true,
        repeatWeekdays: const [1, 3, 5],
        streakCount: 8,
        completedDatesIso: const [],
      ),
      HabitTaskModel(
        id: '${cleanUsername}_sail_task_3',
        userId: cleanUsername,
        title: 'Deniz Haritası İncelemesi ve Seyir Defteri',
        timeString: '14:00',
        difficulty: 0, // Bebek Mavisi
        isRecurring: false,
        specificDateIso: todayIso,
        streakCount: 0,
        completedDatesIso: const [],
      ),
      HabitTaskModel(
        id: '${cleanUsername}_sail_task_4',
        userId: cleanUsername,
        title: 'Yelken Donanımı Bakımı ve İp Kontrolü',
        timeString: '16:45',
        difficulty: 1, // Normal Mavi
        isRecurring: false,
        specificDateIso: tomorrowIso,
        streakCount: 0,
        completedDatesIso: const [],
      ),
    ];

    for (final task in demoTasks) {
      await box.put(task.id, task.toMap());
    }
  }
}
