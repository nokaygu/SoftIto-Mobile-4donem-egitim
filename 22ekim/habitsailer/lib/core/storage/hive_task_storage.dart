import 'package:hive_flutter/hive_flutter.dart';
import '../../features/models/habit_task_model.dart';

class HiveTaskStorage {
  static const String boxName = 'habitsailer_tasks_box';
  Box<dynamic>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(boxName);
    await seedDemoTasksIfEmpty();
  }

  Box<dynamic> get box {
    final b = _box;
    if (b == null || !b.isOpen) {
      throw StateError('HiveTaskStorage has not been initialized. Call init() first.');
    }
    return b;
  }

  List<HabitTaskModel> getAllTasks() {
    final List<HabitTaskModel> tasks = [];
    for (var i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item is Map) {
        tasks.add(HabitTaskModel.fromMap(item));
      }
    }
    return tasks;
  }

  Future<void> saveOrUpdateTask(HabitTaskModel task) async {
    // Check if task exists by id
    int? foundIndex;
    for (var i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item is Map && item['id'] == task.id) {
        foundIndex = i;
        break;
      }
    }

    if (foundIndex != null) {
      await box.putAt(foundIndex, task.toMap());
    } else {
      await box.add(task.toMap());
    }
  }

  Future<void> deleteTask(String taskId) async {
    int? foundIndex;
    for (var i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item is Map && item['id'] == taskId) {
        foundIndex = i;
        break;
      }
    }
    if (foundIndex != null) {
      await box.deleteAt(foundIndex);
    }
  }

  Future<void> seedDemoTasksIfEmpty() async {
    if (box.isNotEmpty) return;

    final now = DateTime.now();
    final todayIso = HabitTaskModel.formatDateToIso(now);
    final tomorrowIso = HabitTaskModel.formatDateToIso(now.add(const Duration(days: 1)));

    final demoTasks = [
      const HabitTaskModel(
        id: 'sail_task_1',
        title: 'Sabah Rotasını ve Hedefleri Belirle',
        timeString: '08:00',
        difficulty: 1, // Normal Mavi
        isRecurring: true,
        repeatWeekdays: [1, 2, 3, 4, 5, 6, 7], // Every day
        streakCount: 5,
        completedDatesIso: [],
      ),
      const HabitTaskModel(
        id: 'sail_task_2',
        title: 'Acil Fırtına Tedbirleri ve Güverte Kontrolü',
        timeString: '10:30',
        difficulty: 2, // Lacivert / Acil
        isRecurring: true,
        repeatWeekdays: [1, 3, 5],
        streakCount: 8,
        completedDatesIso: [],
      ),
      HabitTaskModel(
        id: 'sail_task_3',
        title: 'Deniz Haritası İncelemesi ve Seyir Defteri',
        timeString: '14:00',
        difficulty: 0, // Bebek Mavisi
        isRecurring: false,
        specificDateIso: todayIso,
        streakCount: 0,
        completedDatesIso: const [],
      ),
      HabitTaskModel(
        id: 'sail_task_4',
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
      await box.add(task.toMap());
    }
  }
}
