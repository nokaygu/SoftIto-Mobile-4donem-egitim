import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/logbook_controller.dart';
import '../../controllers/task_controller.dart';
import '../../models/captain_log_model.dart';
import '../../models/habit_task_model.dart';
import '../../widgets/habit_sailor_brand_header.dart';

class LogbookView extends StatefulWidget {
  const LogbookView({super.key});

  @override
  State<LogbookView> createState() => _LogbookViewState();
}

class _LogbookViewState extends State<LogbookView> {
  DateTime _selectedDate = DateTime.now();
  int _viewFilter = 0; // 0: Seçili Gün, 1: Tüm Seyir Kayıtları

  final List<String> _weatherOptions = const [
    '☀️ Sakin Deniz',
    '⛵ Pupayelken',
    '🌊 Dalgalı',
    '⚡ Fırtına',
    '⚓ Liman Huzuru',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailorThemeExtension>()!;
    final logbookController = AppState.instance.logbookController;
    final taskController = AppState.instance.taskController;

    return Scaffold(
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrEditLogModal(context, logbookController),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        icon: const Icon(Icons.edit_calendar_rounded),
        label: const Text(
          'Yeni Seyir Notu',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([logbookController, taskController]),
          builder: (context, _) {
            final dateKey = HabitTaskModel.formatDateToIso(_selectedDate);
            final logs = _viewFilter == 0
                ? logbookController.getLogsForDate(dateKey)
                : logbookController.logs;

            final completedTasks = taskController
                .getCompletedTasksForDate(_selectedDate)
                .where((t) => t.getNoteForDate(_selectedDate) != null &&
                    t.getNoteForDate(_selectedDate)!.trim().isNotEmpty)
                .toList();

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: HabitSailorBrandHeader(compact: true),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.auto_stories_rounded,
                                color: cs.primary,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kaptanın Seyir Defteri',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: cs.onSurface,
                                        ),
                                  ),
                                  Text(
                                    'Günün seyir notları ve görev deneyimleri',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: cs.onSurface.withValues(alpha: 0.75),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildFilterSelector(cs),
                        if (_viewFilter == 0) ...[
                          const SizedBox(height: 12),
                          _buildDateCarousel(cs, ext),
                        ],
                      ],
                    ),
                  ),
                ),

                // Task Notes Section (If any tasks have notes for selected date)
                if (_viewFilter == 0 && completedTasks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Row(
                        children: [
                          Icon(Icons.task_alt_rounded, size: 18, color: cs.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Görev Deneyimleri (${completedTasks.length})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = completedTasks[index];
                          final note = task.getNoteForDate(_selectedDate) ?? '';
                          return _buildTaskNoteCard(
                            context,
                            task,
                            note,
                            cs,
                            taskController,
                          );
                        },
                        childCount: completedTasks.length,
                      ),
                    ),
                  ),
                ],

                // Log Entries Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    child: Row(
                      children: [
                        Icon(Icons.edit_note_rounded, size: 20, color: cs.primary),
                        const SizedBox(width: 6),
                        Text(
                          _viewFilter == 0 ? 'Kaptanın Günlük Notları' : 'Tüm Seyir Defteri',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${logs.length} Kayıt',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Logs List or Empty State
                if (logs.isEmpty && completedTasks.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.import_contacts_rounded,
                              size: 64,
                              color: cs.primary.withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Bu Güne Ait Seyir Notu Yok ⚓',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: cs.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bugünkü rotanı tamamlarken veya sağ alttaki butona tıklayarak '
                              'seyir defterine ilk notunu düşebilirsin.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final log = logs[index];
                          return _buildLogCard(
                            context,
                            log,
                            cs,
                            ext,
                            logbookController,
                          );
                        },
                        childCount: logs.length,
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

  Widget _buildFilterSelector(ColorScheme cs) {
    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab(
              label: 'Seçili Gün',
              icon: Icons.calendar_today_rounded,
              isSelected: _viewFilter == 0,
              onTap: () => setState(() => _viewFilter = 0),
              cs: cs,
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              label: 'Tüm Kayıtlar',
              icon: Icons.history_edu_rounded,
              isSelected: _viewFilter == 1,
              onTap: () => setState(() => _viewFilter = 1),
              cs: cs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme cs,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? cs.onPrimary : cs.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? cs.onPrimary : cs.onSurface,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCarousel(ColorScheme cs, HabitSailorThemeExtension ext) {
    final now = DateTime.now();
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context, i) {
          // Show past 10 days and next 3 days
          final date = now.subtract(Duration(days: 9 - i));
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;
          final isToday = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;

          final weekdayName = _getWeekdayShort(date.weekday);

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 58,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primary
                    : (isToday ? cs.primaryContainer : cs.surfaceContainerHighest.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? cs.primary
                      : (isToday ? ext.lightningYellow : cs.outlineVariant),
                  width: isSelected || isToday ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekdayName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? cs.onPrimary
                          : (isToday ? cs.primary : cs.onSurface.withValues(alpha: 0.6)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? cs.onPrimary : cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskNoteCard(
    BuildContext context,
    HabitTaskModel task,
    String note,
    ColorScheme cs,
    TaskController taskController,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: cs.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
              InkWell(
                onTap: () => _showEditTaskNoteModal(context, task, taskController),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.edit_note_rounded, size: 20, color: cs.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              note,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: cs.onSurface.withValues(alpha: 0.85),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(
    BuildContext context,
    CaptainLogModel log,
    ColorScheme cs,
    HabitSailorThemeExtension ext,
    LogbookController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    log.weather,
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${log.dateIso} • ${log.timeString}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, size: 18, color: cs.onSurface.withValues(alpha: 0.6)),
                  padding: EdgeInsets.zero,
                  onSelected: (val) {
                    if (val == 'edit') {
                      _showAddOrEditLogModal(context, controller, existingLog: log);
                    } else if (val == 'delete') {
                      controller.deleteLog(log.id);
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded, size: 16),
                          SizedBox(width: 8),
                          Text('Düzenle'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 16),
                          SizedBox(width: 8),
                          Text('Sil'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              log.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              log.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.85),
                    height: 1.45,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddOrEditLogModal(
    BuildContext context,
    LogbookController controller, {
    CaptainLogModel? existingLog,
  }) async {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final todayIso = HabitTaskModel.formatDateToIso(_selectedDate);
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final titleCtrl = TextEditingController(text: existingLog?.title ?? '');
    final contentCtrl = TextEditingController(text: existingLog?.content ?? '');
    var selectedWeather = existingLog?.weather ?? _weatherOptions.first;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: cs.outlineVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.edit_note_rounded, color: cs.primary, size: 26),
                        const SizedBox(width: 8),
                        Text(
                          existingLog == null ? 'Yeni Seyir Notu Düş ⚓' : 'Seyir Notunu Düzenle',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Deniz / Rüzgar Durumu',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _weatherOptions.map((w) {
                        final isSel = selectedWeather == w;
                        return ChoiceChip(
                          label: Text(w),
                          selected: isSel,
                          onSelected: (_) {
                            setModalState(() => selectedWeather = w);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'Başlık (İsteğe Bağlı)',
                        hintText: 'Örn: Dalgalar Dindi, Rota Açık',
                        filled: true,
                        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.35),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Seyir Notu / Günlük Yazısı *',
                        hintText: 'Bugünkü seyir nasıl geçti? Hedefler, zorluklar ve zaferler...',
                        filled: true,
                        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.35),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (contentCtrl.text.trim().isEmpty) return;
                          Navigator.of(ctx).pop();

                          await controller.addOrUpdateLog(
                            id: existingLog?.id,
                            dateIso: existingLog?.dateIso ?? todayIso,
                            timeString: existingLog?.timeString ?? timeStr,
                            title: titleCtrl.text,
                            content: contentCtrl.text,
                            weather: selectedWeather,
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded),
                        label: const Text(
                          'Seyir Defterine Kaydet',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    titleCtrl.dispose();
    contentCtrl.dispose();
  }

  Future<void> _showEditTaskNoteModal(
    BuildContext context,
    HabitTaskModel task,
    TaskController taskController,
  ) async {
    final cs = Theme.of(context).colorScheme;
    final currentNote = task.getNoteForDate(_selectedDate) ?? '';
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
                hintText: 'Bu görevi tamamlarken deneyiminiz nasıldı?',
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
                _selectedDate,
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

  String _getWeekdayShort(int weekday) {
    switch (weekday) {
      case 1:
        return 'Pzt';
      case 2:
        return 'Sal';
      case 3:
        return 'Çar';
      case 4:
        return 'Per';
      case 5:
        return 'Cum';
      case 6:
        return 'Cmt';
      case 7:
        return 'Paz';
      default:
        return '';
    }
  }
}
