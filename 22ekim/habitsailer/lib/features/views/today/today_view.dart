import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../widgets/habit_sailer_brand_header.dart';
import '../../widgets/habit_task_card.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  // 0: Bugün, 1: Planlananlar
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final taskController = AppState.instance.taskController;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: taskController,
          builder: (context, _) {
            final now = DateTime.now();
            final todayTasks = taskController.getTasksForDate(now);
            final upcomingTasks = taskController.getUpcomingTasks(now);

            final displayTasks = _selectedTabIndex == 0 ? todayTasks : upcomingTasks;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Column(
                      children: [
                        const HabitSailerBrandHeader(compact: true),
                        const SizedBox(height: 18),

                        // Switcher between "Bugün" and "Planlananlar"
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: cs.outlineVariant),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => setState(() => _selectedTabIndex = 0),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _selectedTabIndex == 0
                                          ? cs.primary
                                          : cs.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Bugünün Rotası (${todayTasks.length})',
                                      style: TextStyle(
                                        color: _selectedTabIndex == 0
                                            ? cs.onPrimary
                                            : cs.onPrimaryContainer,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => setState(() => _selectedTabIndex = 1),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _selectedTabIndex == 1
                                          ? cs.primary
                                          : cs.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Planlananlar (${upcomingTasks.length})',
                                      style: TextStyle(
                                        color: _selectedTabIndex == 1
                                            ? cs.onPrimary
                                            : cs.onPrimaryContainer,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (displayTasks.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedTabIndex == 0
                                  ? Icons.sailing_rounded
                                  : Icons.event_available_rounded,
                              size: 64,
                              color: cs.primary,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _selectedTabIndex == 0
                                  ? 'Bugün için planlanan görev yok!'
                                  : 'Yaklaşan görev bulunmuyor.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: cs.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Görevle sekmesine geçerek yeni bir rota başlatabilirsin.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: cs.onSurface,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = displayTasks[index];
                          final isCompletedToday = task.isCompletedOn(now);

                          return HabitTaskCard(
                            task: task,
                            isCompletedToday: isCompletedToday,
                            onToggleComplete: () {
                              taskController.toggleTaskCompletion(task.id, now);
                            },
                          );
                        },
                        childCount: displayTasks.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
