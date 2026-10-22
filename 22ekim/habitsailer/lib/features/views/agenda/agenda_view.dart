import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme.dart';
import 'day_detail_view.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  late DateTime _displayedMonth;

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

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month, 1);
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailerThemeExtension>()!;
    final taskController = AppState.instance.taskController;

    final now = DateTime.now();
    final year = _displayedMonth.year;
    final month = _displayedMonth.month;

    // First day of current displayed month (1 = Monday, 7 = Sunday)
    final firstDayWeekday = _displayedMonth.weekday;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingEmptyCells = firstDayWeekday - 1;
    final totalCells = leadingEmptyCells + daysInMonth;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seyir Ajandası',
          style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: taskController,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Month navigation bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left_rounded, color: cs.primary),
                          onPressed: _previousMonth,
                        ),
                        Text(
                          '${_monthNames[month - 1]} $year',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onPrimaryContainer,
                              ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right_rounded, color: cs.primary),
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
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: cs.onSurface,
                                    ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Calendar Grid
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: totalCells,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 0.85,
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

                      final hasUrgent = taskController.hasUrgentTaskOnDate(dayDate);
                      final hasAny = taskController.hasAnyTaskOnDate(dayDate);
                      final firstWord = taskController.getFirstWordForDate(dayDate);

                      // Determine day cell colors
                      final Color cellBg;
                      final Color cellFg;
                      final Color cellBorder;

                      if (hasUrgent) {
                        cellBg = ext.urgentDayBg;
                        cellFg = ext.urgentDayFg;
                        cellBorder = ext.urgentNavyBorder;
                      } else if (hasAny) {
                        cellBg = ext.normalDayBg;
                        cellFg = ext.normalDayFg;
                        cellBorder = cs.primary;
                      } else {
                        cellBg = cs.surface;
                        cellFg = cs.onSurface;
                        cellBorder = isToday ? cs.primary : cs.outlineVariant;
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DayDetailView(selectedDate: dayDate),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          decoration: BoxDecoration(
                            color: cellBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isToday ? ext.lightningYellow : cellBorder,
                              width: isToday ? 2.5 : 1.2,
                            ),
                            boxShadow: hasUrgent
                                ? [
                                    BoxShadow(
                                      color: ext.deepNavyShadow,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$dayNumber',
                                style: TextStyle(
                                  color: cellFg,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                              if (firstWord != null) ...[
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: hasUrgent
                                        ? cs.primary
                                        : cs.primaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    firstWord,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: hasUrgent
                                          ? cs.onPrimary
                                          : cs.onPrimaryContainer,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Legend
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajanda Renk Rehberi',
                          style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildLegendItem(
                              color: ext.urgentDayBg,
                              borderColor: ext.urgentNavyBorder,
                              label: 'Acil Görev (Lacivert)',
                              textColor: cs.onPrimaryContainer,
                            ),
                            const SizedBox(width: 14),
                            _buildLegendItem(
                              color: ext.normalDayBg,
                              borderColor: cs.primary,
                              label: 'Sıradan Görev (Bebek Mavisi)',
                              textColor: cs.onPrimaryContainer,
                            ),
                          ],
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

  Widget _buildLegendItem({
    required Color color,
    required Color borderColor,
    required String label,
    required Color textColor,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor, width: 1.5),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
