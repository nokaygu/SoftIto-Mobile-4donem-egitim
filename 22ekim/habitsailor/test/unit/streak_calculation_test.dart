import 'package:flutter_test/flutter_test.dart';
import 'package:habitsailor/features/models/habit_task_model.dart';

void main() {
  group('Streak Calculation Tests ("Don\'t Break The Chain")', () {
    test('calculateStreak returns 0 for non-recurring tasks', () {
      const task = HabitTaskModel(
        id: '1',
        title: 'Non-recurring',
        isRecurring: false,
        streakCount: 5,
      );

      expect(task.calculateStreak(DateTime(2026, 10, 23)), equals(0));
    });

    test('calculateStreak counts consecutive completed due days', () {
      // Habit runs every day (1..7)
      // Friday 2026-10-23, Thursday 2026-10-22, Wednesday 2026-10-21 all completed
      const task = HabitTaskModel(
        id: '2',
        title: 'Günlük Meditasyon',
        isRecurring: true,
        repeatWeekdays: [1, 2, 3, 4, 5, 6, 7],
        completedDatesIso: ['2026-10-21', '2026-10-22', '2026-10-23'],
      );

      final streak = task.calculateStreak(DateTime(2026, 10, 23));
      expect(streak, equals(3));
    });

    test('calculateStreak breaks when a past due date was missed', () {
      // Completed Friday (23rd) and Wednesday (21st), but missed Thursday (22nd)
      const task = HabitTaskModel(
        id: '3',
        title: 'Günlük Kitap',
        isRecurring: true,
        repeatWeekdays: [1, 2, 3, 4, 5, 6, 7],
        completedDatesIso: ['2026-10-21', '2026-10-23'], // 2026-10-22 missed!
      );

      final streak = task.calculateStreak(DateTime(2026, 10, 23));
      // Only today is in the current consecutive chain
      expect(streak, equals(1));
    });

    test('today due but not yet completed maintains yesterday streak', () {
      // Completed Thursday (22nd) and Wednesday (21st). Friday (23rd) is today and not yet completed.
      const task = HabitTaskModel(
        id: '4',
        title: 'Sabah Sporu',
        isRecurring: true,
        repeatWeekdays: [1, 2, 3, 4, 5, 6, 7],
        completedDatesIso: ['2026-10-21', '2026-10-22'],
      );

      final streak = task.calculateStreak(DateTime(2026, 10, 23));
      // Streak is 2 (yesterday's chain is preserved during the day)
      expect(streak, equals(2));
    });

    test('skips non-due days properly for custom repeat patterns', () {
      // Task repeats only Mon (1), Wed (3), Fri (5)
      // 2026-10-19: Mon (done)
      // 2026-10-21: Wed (done)
      // 2026-10-23: Fri (done)
      // Tue (20th) and Thu (22nd) are NOT due days and should NOT break streak
      const task = HabitTaskModel(
        id: '5',
        title: 'Haftada 3 Gün Yüzme',
        isRecurring: true,
        repeatWeekdays: [1, 3, 5],
        completedDatesIso: ['2026-10-19', '2026-10-21', '2026-10-23'],
      );

      final streak = task.calculateStreak(DateTime(2026, 10, 23));
      expect(streak, equals(3));
    });
  });
}
