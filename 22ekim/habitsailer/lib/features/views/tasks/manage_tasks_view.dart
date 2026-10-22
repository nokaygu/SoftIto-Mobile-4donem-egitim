import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../models/habit_task_model.dart';
import '../../widgets/habit_task_card.dart';
import '../../widgets/task_form_bottom_sheet.dart';

class ManageTasksView extends StatelessWidget {
  const ManageTasksView({super.key});

  void _confirmAndDelete(BuildContext context, HabitTaskModel task) {
    final cs = Theme.of(context).colorScheme;

    final String message;
    if (task.isRecurring) {
      message =
          'Emin misiniz? Bu görev haftada ${task.repeatWeekdays.length} gün tekrarlanıyor. '
          'Silerseniz artık tekrarlanmayacak ve ${task.streakCount} zincir puanınız kaybolacaktır.';
    } else {
      message = 'Emin misiniz? "${task.title}" görevi kalıcı olarak silinecektir.';
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: cs.error),
            const SizedBox(width: 8),
            Text(
              'Görevi Sil',
              style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: cs.onSurface, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Vazgeç', style: TextStyle(color: cs.onSurface)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cs.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              AppState.instance.taskController.deleteTask(task.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _openEditTask(BuildContext context, HabitTaskModel task) {
    TaskFormBottomSheet.show(
      context: context,
      initialTask: task,
      onSave: (updatedTask) {
        AppState.instance.taskController.createOrUpdateTask(updatedTask);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final taskController = AppState.instance.taskController;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Görevlerimi Düzenle',
          style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: taskController,
          builder: (context, _) {
            final tasks = taskController.tasks;

            if (tasks.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist_rounded, size: 60, color: cs.primary),
                      const SizedBox(height: 12),
                      Text(
                        'Henüz hiç görev bulunmuyor.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final now = DateTime.now();

                return HabitTaskCard(
                  task: task,
                  isCompletedToday: task.isCompletedOn(now),
                  onTap: () => _openEditTask(context, task),
                  onDeleteTap: () => _confirmAndDelete(context, task),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
