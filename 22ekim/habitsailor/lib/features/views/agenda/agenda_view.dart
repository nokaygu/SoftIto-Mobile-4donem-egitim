import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../models/habit_task_model.dart';
import '../../widgets/habit_sailor_brand_header.dart';
import '../../widgets/task_form_bottom_sheet.dart';
import 'day_detail_view.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  static const List<String> _monthNames = [
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

  static const List<String> _shortWeekdays = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  static const List<String> _fullWeekdays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month, 1);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _displayedMonth = DateTime(now.year, now.month, 1);
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
  }

  void _openAddTaskSheet(DateTime date) {
    TaskFormBottomSheet.show(
      context: context,
      initialIsRecurring: false,
      initialSpecificDate: date,
      onSave: (HabitTaskModel task) {
        AppState.instance.taskController.createOrUpdateTask(task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailorThemeExtension>()!;
    final taskController = AppState.instance.taskController;

    final now = DateTime.now();
    final year = _displayedMonth.year;
    final month = _displayedMonth.month;

    // First day of current displayed month (1 = Monday, 7 = Sunday)
    final firstDayWeekday = _displayedMonth.weekday;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingEmptyCells = firstDayWeekday - 1;
    final totalCells = leadingEmptyCells + daysInMonth;

    final isLookingAtCurrentMonth = now.year == year && now.month == month;
    final selectedDayTasks = taskController.getTasksForDate(_selectedDate);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: taskController,
          builder: (context, _) {
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: HabitSailorBrandHeader(compact: true),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Screen Title & Subtitle
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                color: cs.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Seyir Ajandası',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: cs.onSurface,
                                        ),
                                  ),
                                  Text(
                                    'Aylık rota haritası ve görev takvimi',
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
                            if (!isLookingAtCurrentMonth)
                              TextButton.icon(
                                onPressed: _goToToday,
                                icon: Icon(Icons.today_rounded, size: 16, color: cs.primary),
                                label: Text(
                                  'Bugün',
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: cs.primaryContainer.withValues(alpha: 0.5),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Month navigation card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: cs.outlineVariant),
                            boxShadow: [
                              BoxShadow(
                                color: cs.shadow.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new_rounded,
                                    size: 18, color: cs.primary),
                                onPressed: _previousMonth,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.sailing_rounded, size: 18, color: cs.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_monthNames[month - 1]} $year',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: cs.onSurface,
                                        ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios_rounded,
                                    size: 18, color: cs.primary),
                                onPressed: _nextMonth,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Weekday names
                        Row(
                          children: _shortWeekdays
                              .map(
                                (name) => Expanded(
                                  child: Center(
                                    child: Text(
                                      name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: cs.onSurface.withValues(alpha: 0.65),
                                          ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 8),

                        // Calendar Grid
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: totalCells,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                            childAspectRatio: 0.90,
                          ),
                          itemBuilder: (context, index) {
                            if (index < leadingEmptyCells) {
                              return const SizedBox.shrink();
                            }

                            final dayNumber = index - leadingEmptyCells + 1;
                            final dayDate = DateTime(year, month, dayNumber);
                            final isToday = dayDate.year == now.year &&
                                dayDate.month == now.month &&
                                dayDate.day == now.day;
                            final isSelected = dayDate.year == _selectedDate.year &&
                                dayDate.month == _selectedDate.month &&
                                dayDate.day == _selectedDate.day;

                            final hasUrgent = taskController.hasUrgentTaskOnDate(dayDate);
                            final hasAny = taskController.hasAnyTaskOnDate(dayDate);
                            final taskSnippet =
                                taskController.getMeaningfulTaskSnippetForDate(dayDate);
                            final taskCount = taskController.getTasksForDate(dayDate).length;

                            // Determine day cell colors
                            final Color cellBg;
                            final Color cellFg;
                            final Color cellBorder;

                            if (isSelected) {
                              cellBg = cs.primary;
                              cellFg = cs.onPrimary;
                              cellBorder = ext.lightningYellow;
                            } else if (hasUrgent) {
                              cellBg = ext.urgentDayBg;
                              cellFg = ext.urgentDayFg;
                              cellBorder = ext.urgentNavyBorder;
                            } else if (hasAny) {
                              cellBg = ext.normalDayBg;
                              cellFg = ext.normalDayFg;
                              cellBorder = cs.primary.withValues(alpha: 0.4);
                            } else {
                              cellBg = cs.surface;
                              cellFg = cs.onSurface;
                              cellBorder = isToday ? ext.lightningYellow : cs.outlineVariant;
                            }

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedDate = dayDate;
                                });
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cellBg,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? ext.lightningYellow
                                        : (isToday ? ext.lightningYellow : cellBorder),
                                    width: isSelected || isToday ? 2.2 : 1.0,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: cs.primary.withValues(alpha: 0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : (hasUrgent
                                          ? [
                                              BoxShadow(
                                                color: ext.deepNavyShadow,
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$dayNumber',
                                          style: TextStyle(
                                            color: cellFg,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                          ),
                                        ),
                                        if (isToday && !isSelected) ...[
                                          const SizedBox(width: 2),
                                          Icon(
                                            Icons.bolt_rounded,
                                            size: 11,
                                            color: ext.lightningYellow,
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (taskSnippet != null) ...[
                                      const SizedBox(height: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? cs.onPrimary.withValues(alpha: 0.2)
                                              : (hasUrgent
                                                  ? cs.primary
                                                  : cs.primaryContainer),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          taskSnippet,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isSelected
                                                ? cs.onPrimary
                                                : (hasUrgent
                                                    ? cs.onPrimary
                                                    : cs.onPrimaryContainer),
                                            fontSize: 8.5,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ),
                                    ] else if (hasAny && taskCount > 0) ...[
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? cs.onPrimary
                                                  : (hasUrgent ? ext.lightningYellow : cs.primary),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 18),

                        // Interactive Day Preview Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: cs.outlineVariant),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.anchor_rounded, color: cs.primary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_fullWeekdays[_selectedDate.weekday - 1]} Rotası',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: cs.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_task_rounded, color: cs.primary, size: 20),
                                tooltip: 'Güne Görev Ekle',
                                onPressed: () => _openAddTaskSheet(_selectedDate),
                              ),
                              IconButton(
                                icon: Icon(Icons.open_in_new_rounded,
                                    color: cs.primary, size: 18),
                                tooltip: 'Detay Sayfası',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DayDetailView(selectedDate: _selectedDate),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Selected Day Tasks List
                if (selectedDayTasks.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.sailing_outlined,
                              size: 40,
                              color: cs.primary.withValues(alpha: 0.7),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bu Gün İçin Seyir Görevi Yok ⛵',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sağdaki butona tıklayarak güne özel yeni bir görev ekleyebilirsin.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
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
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = selectedDayTasks[index];
                          final isCompleted = task.isCompletedOn(_selectedDate);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: ext.difficultyBackground(task.difficulty),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ext.difficultyBorder(task.difficulty),
                                width: task.difficulty == 2 ? 1.8 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: cs.shadow.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isCompleted
                                      ? Icons.check_circle_rounded
                                      : (task.difficulty == 2
                                          ? Icons.warning_amber_rounded
                                          : Icons.radio_button_unchecked_rounded),
                                  color: isCompleted
                                      ? cs.primary
                                      : ext.difficultyForeground(task.difficulty),
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                          color: ext.difficultyForeground(task.difficulty),
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          if (task.timeString != null &&
                                              task.timeString!.isNotEmpty) ...[
                                            Icon(
                                              Icons.access_time_filled_rounded,
                                              size: 13,
                                              color: ext.difficultyForeground(task.difficulty)
                                                  .withValues(alpha: 0.8),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              task.timeString!,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: ext.difficultyForeground(task.difficulty)
                                                    .withValues(alpha: 0.8),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                          if (task.isRecurring)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: ext.streakNeonColor(task.streakCount),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                '⚡ ${task.streakCount} Gün',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                  color: ext.onStreakNeon,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (task.difficulty == 2)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: ext.urgentNavyFg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Acil',
                                      style: TextStyle(
                                        color: ext.urgentNavyBg,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                        childCount: selectedDayTasks.length,
                      ),
                    ),
                  ),

                // Color Legend
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          _buildLegendDot(
                            color: ext.urgentDayBg,
                            borderColor: ext.urgentNavyBorder,
                            label: 'Acil (Lacivert)',
                            textColor: cs.onSurface,
                          ),
                          _buildLegendDot(
                            color: ext.normalDayBg,
                            borderColor: cs.primary,
                            label: 'Normal (Mavi)',
                            textColor: cs.onSurface,
                          ),
                          _buildLegendDot(
                            color: cs.surface,
                            borderColor: ext.lightningYellow,
                            label: 'Bugün / Seçili',
                            textColor: cs.onSurface,
                          ),
                        ],
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

  Widget _buildLegendDot({
    required Color color,
    required Color borderColor,
    required String label,
    required Color textColor,
  }) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor, width: 1.5),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.85),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
