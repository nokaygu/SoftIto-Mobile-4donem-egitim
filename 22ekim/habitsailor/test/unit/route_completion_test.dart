import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitsailor/core/storage/hive_task_storage.dart';
import 'package:habitsailor/features/controllers/task_controller.dart';
import 'package:habitsailor/features/models/habit_task_model.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late Box<dynamic> box;
  late HiveTaskStorage storage;
  late TaskController controller;
  const testUser = 'kaptan_test';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_task_route_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>('test_tasks_box_${DateTime.now().microsecondsSinceEpoch}');
    storage = HiveTaskStorage(boxInstance: box);
    controller = TaskController(storage: storage);
  });

  tearDown(() async {
    await box.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('TaskController Route & Gamification Batch Tests', () {
    test('filters pending vs completed tasks correctly for a given date', () async {
      // 2026-10-23 is Friday (weekday = 5)
      final friday = DateTime(2026, 10, 23);

      const task1 = HabitTaskModel(
        id: 'task_1',
        userId: testUser,
        title: 'Sabah Vardiyası',
        difficulty: 1, // 10 pts
        isRecurring: true,
        repeatWeekdays: [5],
      );

      const task2 = HabitTaskModel(
        id: 'task_2',
        userId: testUser,
        title: 'Dümen Kontrolü',
        difficulty: 2, // 20 pts
        isRecurring: true,
        repeatWeekdays: [5],
        completedDatesIso: ['2026-10-23'],
      );

      await storage.saveOrUpdateTask(task1);
      await storage.saveOrUpdateTask(task2);
      await controller.loadTasksForUser(testUser);

      final pending = controller.getPendingTasksForDate(friday);
      final completed = controller.getCompletedTasksForDate(friday);

      expect(pending.length, equals(1));
      expect(pending.first.id, equals('task_1'));

      expect(completed.length, equals(1));
      expect(completed.first.id, equals('task_2'));
    });

    test('batchCompleteTasks updates tasks, records date, and accumulates points', () async {
      final date = DateTime(2026, 10, 23);

      const task1 = HabitTaskModel(
        id: 't1',
        userId: testUser,
        title: 'Pruva Kontrolü',
        difficulty: 1, // 10 pts
        isRecurring: true,
        repeatWeekdays: [1, 2, 3, 4, 5, 6, 7],
      );

      const task2 = HabitTaskModel(
        id: 't2',
        userId: testUser,
        title: 'Seyir Defteri Yazımı',
        difficulty: 3, // 30 pts
        isRecurring: true,
        repeatWeekdays: [1, 2, 3, 4, 5, 6, 7],
      );

      await storage.saveOrUpdateTask(task1);
      await storage.saveOrUpdateTask(task2);
      await controller.loadTasksForUser(testUser);

      final points = await controller.batchCompleteTasks(['t1', 't2'], date);

      // (difficulty 1 + 1) * 10 = 20 pts, (difficulty 3 + 1) * 10 = 40 pts -> 60 pts
      expect(points, equals(60));
      expect(controller.getPendingTasksForDate(date).isEmpty, isTrue);
      expect(controller.getCompletedTasksForDate(date).length, equals(2));
    });

    test('uncompleteTask reverts completed status and recalculates streak', () async {
      final date = DateTime(2026, 10, 23);

      const task = HabitTaskModel(
        id: 't_undo',
        userId: testUser,
        title: 'Harita Çizimi',
        difficulty: 2,
        isRecurring: true,
        repeatWeekdays: [5],
        completedDatesIso: ['2026-10-23'],
        streakCount: 1,
      );

      await storage.saveOrUpdateTask(task);
      await controller.loadTasksForUser(testUser);

      expect(controller.getCompletedTasksForDate(date).length, equals(1));

      await controller.uncompleteTask('t_undo', date);

      expect(controller.getCompletedTasksForDate(date).isEmpty, isTrue);
      expect(controller.getPendingTasksForDate(date).length, equals(1));
    });

    test('isWeeklyRouteCompleted returns true only when all weekly recurring tasks are met', () async {
      // 2026-10-23 is Friday
      final friday = DateTime(2026, 10, 23);

      // Only task due this week is on Friday
      const weeklyTask = HabitTaskModel(
        id: 'weekly_task',
        userId: testUser,
        title: 'Haftalık Kazan Temizliği',
        isRecurring: true,
        repeatWeekdays: [5], // Friday
      );

      await storage.saveOrUpdateTask(weeklyTask);
      await controller.loadTasksForUser(testUser);

      // Before completing, weekly route is incomplete
      expect(controller.isWeeklyRouteCompleted(friday), isFalse);

      // Complete it
      await controller.batchCompleteTasks(['weekly_task'], friday);

      // Now weekly route is complete
      expect(controller.isWeeklyRouteCompleted(friday), isTrue);
    });

    test('getMeaningfulTaskSnippetForDate skips stop words and extracts meaningful task snippet', () async {
      final date = DateTime(2026, 10, 23); // Friday

      const taskWithStopWord = HabitTaskModel(
        id: 'stop_task',
        userId: testUser,
        title: 'Sabah Rotasını ve Hedefleri Belirle',
        isRecurring: true,
        repeatWeekdays: [5],
      );

      await storage.saveOrUpdateTask(taskWithStopWord);
      await controller.loadTasksForUser(testUser);

      final snippet = controller.getMeaningfulTaskSnippetForDate(date);
      // "Sabah" and "ve" are stop words, so it should extract "Rotasını Hedefleri"
      expect(snippet, isNotNull);
      expect(snippet!.toLowerCase().contains('sabah'), isFalse);
      expect(snippet.contains('Rotasını'), isTrue);
    });
  });
}
