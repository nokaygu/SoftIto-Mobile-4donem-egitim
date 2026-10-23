import 'package:flutter_test/flutter_test.dart';
import 'package:habitsailor/features/models/habit_task_model.dart';

void main() {
  group('HabitTaskModel Tests', () {
    test('toMap and fromMap serialize and deserialize accurately', () {
      const task = HabitTaskModel(
        id: 'task_001',
        userId: 'kaptan_ali',
        title: 'Pruva Yelkenini Çek',
        timeString: '09:30',
        difficulty: 2,
        isRecurring: true,
        repeatWeekdays: [1, 3, 5],
        specificDateIso: null,
        completedDatesIso: ['2026-10-20', '2026-10-22'],
        streakCount: 2,
        completionNotes: {'2026-10-22': 'Rüzgar sertti ama başardım.'},
      );

      final map = task.toMap();
      expect(map['id'], equals('task_001'));
      expect(map['userId'], equals('kaptan_ali'));
      expect(map['difficulty'], equals(2));
      expect(map['repeatWeekdays'], equals([1, 3, 5]));

      final restored = HabitTaskModel.fromMap(map);
      expect(restored.id, equals(task.id));
      expect(restored.userId, equals(task.userId));
      expect(restored.title, equals(task.title));
      expect(restored.difficulty, equals(task.difficulty));
      expect(restored.isRecurring, isTrue);
      expect(restored.repeatWeekdays, equals([1, 3, 5]));
      expect(restored.completedDatesIso, equals(['2026-10-20', '2026-10-22']));
      expect(restored.streakCount, equals(2));
      expect(
        restored.getNoteForDate(DateTime(2026, 10, 22)),
        equals('Rüzgar sertti ama başardım.'),
      );
    });

    test('isDueOn calculates correctly for recurring and specific dates', () {
      const recurringTask = HabitTaskModel(
        id: 'rec_1',
        title: 'Hafta İçi Görevi',
        isRecurring: true,
        repeatWeekdays: [1, 2, 3, 4, 5], // Mon-Fri
      );

      // 2026-10-23 is Friday (weekday = 5)
      final friday = DateTime(2026, 10, 23);
      // 2026-10-24 is Saturday (weekday = 6)
      final saturday = DateTime(2026, 10, 24);

      expect(recurringTask.isDueOn(friday), isTrue);
      expect(recurringTask.isDueOn(saturday), isFalse);

      const oneTimeTask = HabitTaskModel(
        id: 'one_1',
        title: 'Tek Seferlik Görev',
        isRecurring: false,
        specificDateIso: '2026-10-25',
      );

      expect(oneTimeTask.isDueOn(DateTime(2026, 10, 25)), isTrue);
      expect(oneTimeTask.isDueOn(DateTime(2026, 10, 24)), isFalse);
    });

    test('isCompletedOn checks completion date correctly', () {
      const task = HabitTaskModel(
        id: 'task_c',
        title: 'Tamamlanma Testi',
        completedDatesIso: ['2026-10-22', '2026-10-23'],
      );

      expect(task.isCompletedOn(DateTime(2026, 10, 22)), isTrue);
      expect(task.isCompletedOn(DateTime(2026, 10, 23)), isTrue);
      expect(task.isCompletedOn(DateTime(2026, 10, 24)), isFalse);
    });
  });
}
