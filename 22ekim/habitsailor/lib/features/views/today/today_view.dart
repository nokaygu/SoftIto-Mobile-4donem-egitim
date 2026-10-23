import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../controllers/task_controller.dart';
import '../../models/habit_task_model.dart';
import '../../widgets/celebrations/harbor_arrival_dialog.dart';
import '../../widgets/celebrations/voyage_celebration_dialog.dart';
import '../../widgets/habit_sailor_brand_header.dart';
import '../../widgets/habit_task_card.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  // 0: Bugün Bitirilenler, 1: Bugünün Rotası, 2: Planlananlar
  int _selectedTabIndex = 1;
  final Set<String> _selectedTaskIds = <String>{};

  Future<void> _handleCompleteRoute(
    TaskController taskController,
    DateTime now,
    List<HabitTaskModel> pendingTasks,
  ) async {
    final cs = Theme.of(context).colorScheme;

    final targetIds = _selectedTaskIds.isNotEmpty
        ? _selectedTaskIds.toList()
        : pendingTasks.map((t) => t.id).toList();

    if (targetIds.isEmpty) return;

    final noteController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.sailing_rounded, color: cs.primary, size: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Rotayı Bitirdiniz mi? ⚓',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seçtiğiniz ${targetIds.length} görevi tamamladığınızı onaylıyor musunuz? '
                  'Görevler yapılacaklar listesinden silinip "Bugün Bitirilenler" ve "Seyir Defteri"ne aktarılacaktır.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.85),
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: '📝 Seyir Notu / Deneyim (İsteğe Bağlı)',
                    hintText: 'Örn: Sabah erkenden başladım, rotayı fırtınaya yakalanmadan bitirdim...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.35),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: cs.outlineVariant),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('Henüz Değil', style: TextStyle(color: cs.onSurface)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Evet, Bitirdim! ⚓', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );

    final noteText = noteController.text.trim();
    noteController.dispose();

    if (confirmed != true || !mounted) return;

    final earnedPoints = await taskController.batchCompleteTasks(
      targetIds,
      now,
      optionalNote: noteText.isNotEmpty ? noteText : null,
    );

    // If user entered a note, also record it as a Captain's Logbook reflection
    if (noteText.isNotEmpty) {
      final nowTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      await AppState.instance.logbookController.addOrUpdateLog(
        dateIso: HabitTaskModel.formatDateToIso(now),
        timeString: nowTime,
        title: 'Tamamlanan Rota Notu (${targetIds.length} Görev)',
        content: noteText,
        weather: '⛵ Pupayelken',
      );
    }

    setState(() {
      _selectedTaskIds.clear();
    });

    if (!mounted) return;

    final isWeeklyDone = taskController.isWeeklyRouteCompleted(now);

    if (isWeeklyDone) {
      if (!mounted) return;
      await HarborArrivalDialog.show(
        context,
        bonusPoints: 50,
        onDismiss: () {
          if (mounted) {
            setState(() => _selectedTabIndex = 0); // Switch to "Bugün Bitirilenler"
          }
        },
      );
    } else {
      if (!mounted) return;
      await VoyageCelebrationDialog.show(
        context,
        earnedPoints: earnedPoints,
        onDismiss: () {
          if (mounted) {
            setState(() => _selectedTabIndex = 0); // Switch to "Bugün Bitirilenler"
          }
        },
      );
    }
  }

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
            final completedTasks = taskController.getCompletedTasksForDate(now);
            final pendingTasks = taskController.getPendingTasksForDate(now);
            final upcomingTasks = taskController.getUpcomingTasks(now);

            List<HabitTaskModel> displayTasks;
            if (_selectedTabIndex == 0) {
              displayTasks = completedTasks;
            } else if (_selectedTabIndex == 1) {
              displayTasks = pendingTasks;
            } else {
              displayTasks = upcomingTasks;
            }

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                        child: Column(
                          children: [
                            const HabitSailorBrandHeader(compact: true),
                            const SizedBox(height: 16),

                            // 3-Tab Switcher: [Bitirilenler] [Bugünün Rotası] [Planlananlar]
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: cs.outlineVariant),
                              ),
                              child: Row(
                                children: [
                                  // Tab 0: Bugün Bitirilenler (Solda)
                                  _buildTabButton(
                                    context,
                                    index: 0,
                                    label: 'Bitirilenler',
                                    badgeCount: completedTasks.length,
                                    icon: Icons.check_circle_rounded,
                                    colorScheme: cs,
                                  ),
                                  // Tab 1: Bugünün Rotası (Ortada)
                                  _buildTabButton(
                                    context,
                                    index: 1,
                                    label: 'Bugünün Rotası',
                                    badgeCount: pendingTasks.length,
                                    icon: Icons.sailing_rounded,
                                    colorScheme: cs,
                                  ),
                                  // Tab 2: Planlananlar (Sağda)
                                  _buildTabButton(
                                    context,
                                    index: 2,
                                    label: 'Planlananlar',
                                    badgeCount: upcomingTasks.length,
                                    icon: Icons.schedule_rounded,
                                    colorScheme: cs,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Top Banner for Bitirilenler tab
                    if (_selectedTabIndex == 0 && completedTasks.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: cs.outlineVariant),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.bolt_rounded, color: cs.onPrimary, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bugünün Rotası Fethedildi! ⛵',
                                        style: TextStyle(
                                          color: cs.onPrimaryContainer,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Bugün Toplam: +${completedTasks.fold<int>(0, (sum, t) => sum + (t.difficulty + 1) * 10)} Zincir Puanı',
                                        style: TextStyle(
                                          color: cs.primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                                      ? Icons.done_all_rounded
                                      : (_selectedTabIndex == 1
                                          ? Icons.sailing_rounded
                                          : Icons.event_available_rounded),
                                  size: 64,
                                  color: cs.primary,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  _selectedTabIndex == 0
                                      ? 'Bugün henüz bitirilen görev yok!'
                                      : (_selectedTabIndex == 1
                                          ? 'Tüm rota tamamlandı! Harika bir iş! 🎉'
                                          : 'Yaklaşan görev bulunmuyor.'),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: cs.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _selectedTabIndex == 0
                                      ? 'Bugünün Rotası sekmesine gidip tamamladığın görevleri onaylayabilirsin.'
                                      : 'Görevle sekmesine geçerek yeni bir rota başlatabilirsin.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: cs.onSurface.withValues(alpha: 0.75),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          _selectedTabIndex == 1 ? 100 : 24, // Space for bottom button
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final task = displayTasks[index];

                              if (_selectedTabIndex == 0) {
                                // Bitirilenler: Shows earned points, note, and undo option
                                return HabitTaskCard(
                                  task: task,
                                  isCompletedToday: true,
                                  pointsEarned: (task.difficulty + 1) * 10,
                                  completionNote: task.getNoteForDate(now),
                                  onEditNote: () => _showEditTaskNoteModal(
                                    task,
                                    now,
                                    taskController,
                                  ),
                                  onUncomplete: () async {
                                    await taskController.uncompleteTask(task.id, now);
                                  },
                                );
                              } else if (_selectedTabIndex == 1) {
                                // Bugünün Rotası: Selection mode for batch completion
                                final isSelected = _selectedTaskIds.contains(task.id);
                                return HabitTaskCard(
                                  task: task,
                                  isSelected: isSelected,
                                  onToggleComplete: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedTaskIds.remove(task.id);
                                      } else {
                                        _selectedTaskIds.add(task.id);
                                      }
                                    });
                                  },
                                );
                              } else {
                                // Planlananlar: Locked against early completion
                                return HabitTaskCard(
                                  task: task,
                                  isCompletedToday: false,
                                  isLocked: true,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Bu görev geleceğe aittir. Günü geldiğinde Bugünün Rotası üzerinden tamamlayabilirsiniz ⚓',
                                        ),
                                        backgroundColor: cs.primary,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            childCount: displayTasks.length,
                          ),
                        ),
                      ),
                  ],
                ),

                // Floating Bottom "Rotayı Tamamla" Button on Tab 1
                if (_selectedTabIndex == 1 && pendingTasks.isNotEmpty)
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: cs.shadow.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _handleCompleteRoute(
                          taskController,
                          now,
                          pendingTasks,
                        ),
                        icon: const Icon(Icons.anchor_rounded, size: 24),
                        label: Text(
                          _selectedTaskIds.isNotEmpty
                              ? '⚓ Rotayı Tamamla (${_selectedTaskIds.length} Görev)'
                              : '⚓ Rotayı Tamamla (Tümünü Bitir)',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
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

  Widget _buildTabButton(
    BuildContext context, {
    required int index,
    required String label,
    required int badgeCount,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onPrimaryContainer,
              ),
              const SizedBox(height: 3),
              Text(
                '$label ($badgeCount)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onPrimaryContainer,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditTaskNoteModal(
    HabitTaskModel task,
    DateTime now,
    TaskController taskController,
  ) async {
    final cs = Theme.of(context).colorScheme;
    final currentNote = task.getNoteForDate(now) ?? '';
    final controller = TextEditingController(text: currentNote);

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.edit_note_rounded, color: cs.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Görevin Seyir Notu',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Bu görevi tamamlarken deneyiminiz nasıldı? (İsteğe bağlı)',
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.35),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await taskController.updateTaskCompletionNote(
                task.id,
                now,
                controller.text,
              );
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    controller.dispose();
  }
}
