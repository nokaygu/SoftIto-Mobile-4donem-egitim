import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../models/habit_task_model.dart';
import '../../widgets/task_form_bottom_sheet.dart';
import '../../widgets/user_avatar_badge.dart';
import 'manage_tasks_view.dart';

class TasksHubView extends StatelessWidget {
  const TasksHubView({super.key});

  void _showTaskTypeDialog(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Görev Türünü Seçin',
          style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: cs.outlineVariant),
                ),
                tileColor: cs.primaryContainer,
                leading: Icon(Icons.loop_rounded, color: cs.primary),
                title: Text(
                  'Tekrarlayan Alışkanlık',
                  style: TextStyle(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  'Haftanın belirli günlerinde tekrarlanır ve Zincir Puanı kazandırır.',
                  style: TextStyle(color: cs.onPrimaryContainer, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _openTaskForm(context, isRecurring: true);
                },
              ),
            ),
            const SizedBox(height: 12),
            Material(
              color: Colors.transparent,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: cs.outlineVariant),
                ),
                tileColor: cs.surfaceContainerHighest,
                leading: Icon(Icons.calendar_today_rounded, color: cs.primary),
                title: Text(
                  'Tekrarlamayan Görev',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  'Sadece seçilen günde tamamlanacak tek seferlik görev.',
                  style: TextStyle(color: cs.onSurface, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _openTaskForm(context, isRecurring: false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openTaskForm(BuildContext context, {required bool isRecurring}) {
    TaskFormBottomSheet.show(
      context: context,
      initialIsRecurring: isRecurring,
      onSave: (HabitTaskModel task) {
        AppState.instance.taskController.createOrUpdateTask(task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authController = AppState.instance.authController;
    final taskController = AppState.instance.taskController;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Görev Merkezi',
          style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: ListenableBuilder(
              listenable: authController,
              builder: (context, _) {
                final avatarIndex = authController.currentUser?.avatarIndex ?? 0;
                return UserAvatarBadge(
                  avatarIndex: avatarIndex,
                  radius: 18,
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: taskController,
          builder: (context, _) {
            final totalTasks = taskController.tasks.length;
            final recurringTasks =
                taskController.tasks.where((t) => t.isRecurring).length;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Action Card 1: Yeni Görev Yarat
                  _buildActionCard(
                    context: context,
                    title: 'Yeni Görev Yarat',
                    subtitle:
                        'Tekrarlayan alışkanlık veya güne özel tek seferlik rota başlat.',
                    icon: Icons.add_task_rounded,
                    isPrimary: true,
                    onTap: () => _showTaskTypeDialog(context),
                  ),
                  const SizedBox(height: 16),

                  // Action Card 2: Görevlerimi Düzenle
                  _buildActionCard(
                    context: context,
                    title: 'Görevlerimi Düzenle',
                    subtitle:
                        'Kayıtlı $totalTasks görevi yönet, detayları güncelle veya sil.',
                    icon: Icons.tune_rounded,
                    isPrimary: false,
                    badgeText: '$totalTasks Görev',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ManageTasksView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Stats banner
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.insights_rounded, color: cs.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Seyir Özeti',
                              style: TextStyle(
                                color: cs.onPrimaryContainer,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatTile(
                                context,
                                'Tekrarlayan',
                                '$recurringTasks Alışkanlık',
                                Icons.loop_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildStatTile(
                                context,
                                'Toplam Streak',
                                '${taskController.getTotalStreakPoints()} Puan',
                                Icons.bolt_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Motivation quote card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.anchor_rounded, color: cs.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Zinciri kırma, rotandan şaşma! Düzenli tekrarlar seni Açık Deniz Kaptanı yapar.',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isPrimary,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPrimary ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isPrimary ? cs.primary : cs.outlineVariant,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.outlineVariant,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isPrimary ? cs.onPrimary : cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isPrimary ? cs.primary : cs.onPrimaryContainer,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isPrimary ? cs.onPrimary : cs.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isPrimary ? cs.onPrimary : cs.onSurface,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isPrimary ? cs.onPrimary : cs.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: cs.primary),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
