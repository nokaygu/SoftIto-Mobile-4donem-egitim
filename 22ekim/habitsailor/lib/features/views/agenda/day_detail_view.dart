import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../models/habit_task_model.dart';
import '../../widgets/habit_task_card.dart';
import '../../widgets/task_form_bottom_sheet.dart';

class DayDetailView extends StatefulWidget {
  final DateTime selectedDate;

  const DayDetailView({
    super.key,
    required this.selectedDate,
  });

  @override
  State<DayDetailView> createState() => _DayDetailViewState();
}

class _DayDetailViewState extends State<DayDetailView> {
  static const List<String> _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  static const List<String> _weekdays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  String _formatDateTitle(DateTime date) {
    final day = date.day;
    final month = _months[date.month - 1];
    final year = date.year;
    final weekday = _weekdays[date.weekday - 1];
    return '$day $month $year, $weekday';
  }

  void _openAddTaskSheet() {
    TaskFormBottomSheet.show(
      context: context,
      initialIsRecurring: false,
      initialSpecificDate: widget.selectedDate,
      onSave: (HabitTaskModel task) {
        AppState.instance.taskController.createOrUpdateTask(task);
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
          'Gün Detayı',
          style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskSheet,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Güne Görev Ekle', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: taskController,
          builder: (context, _) {
            final now = DateTime.now();
            final todayStart = DateTime(now.year, now.month, now.day);
            final selectedDateStart = DateTime(
              widget.selectedDate.year,
              widget.selectedDate.month,
              widget.selectedDate.day,
            );
            final isFuture = selectedDateStart.isAfter(todayStart);
            final tasks = taskController.getTasksForDate(widget.selectedDate);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: cs.onPrimary,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDateTitle(widget.selectedDate),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: cs.onPrimaryContainer,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tasks.isEmpty
                                  ? 'Kayıtlı görev yok'
                                  : '${tasks.length} Görev Planlandı',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: cs.onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (tasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sailing_rounded,
                            size: 56,
                            color: cs.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Bu gün için henüz bir rota çizilmemiş.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Aşağıdaki butona basarak bu güne özel görev ekleyebilirsin.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...tasks.map(
                    (task) {
                      if (isFuture) {
                        return HabitTaskCard(
                          task: task,
                          isCompletedToday: false,
                          isLocked: true,
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Gelecek günlere ait görevler henüz tamamlanamaz. Günü geldiğinde açılacaktır ⚓',
                                ),
                                backgroundColor: cs.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      }

                      return HabitTaskCard(
                        task: task,
                        isCompletedToday: task.isCompletedOn(widget.selectedDate),
                        onToggleComplete: () {
                          taskController.toggleTaskCompletion(
                            task.id,
                            widget.selectedDate,
                          );
                        },
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
