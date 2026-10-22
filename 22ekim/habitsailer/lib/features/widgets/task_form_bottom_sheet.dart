import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/habit_task_model.dart';
import 'weekday_selector_bar.dart';

class TaskFormBottomSheet extends StatefulWidget {
  final HabitTaskModel? initialTask;
  final bool initialIsRecurring;
  final DateTime? initialSpecificDate;
  final void Function(HabitTaskModel task) onSave;

  const TaskFormBottomSheet({
    super.key,
    this.initialTask,
    this.initialIsRecurring = false,
    this.initialSpecificDate,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    HabitTaskModel? initialTask,
    bool initialIsRecurring = false,
    DateTime? initialSpecificDate,
    required void Function(HabitTaskModel task) onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => TaskFormBottomSheet(
        initialTask: initialTask,
        initialIsRecurring: initialIsRecurring,
        initialSpecificDate: initialSpecificDate,
        onSave: onSave,
      ),
    );
  }

  @override
  State<TaskFormBottomSheet> createState() => _TaskFormBottomSheetState();
}

class _TaskFormBottomSheetState extends State<TaskFormBottomSheet> {
  late final TextEditingController _titleController;
  late bool _isRecurring;
  late int _difficulty;
  late List<int> _selectedDays;
  late DateTime _specificDate;
  String? _timeString;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _isRecurring = task?.isRecurring ?? widget.initialIsRecurring;
    _difficulty = task?.difficulty ?? 0;
    _selectedDays = task != null
        ? List<int>.from(task.repeatWeekdays)
        : (_isRecurring ? [1, 2, 3, 4, 5] : <int>[]);
    _specificDate = widget.initialSpecificDate ??
        (task?.specificDateIso != null
            ? DateTime.tryParse(task!.specificDateIso!) ?? DateTime.now()
            : DateTime.now());
    _timeString = task?.timeString;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      setState(() {
        _timeString = '$hour:$minute';
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _specificDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _specificDate = picked;
      });
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen görev başlığı girin.')),
      );
      return;
    }

    if (_isRecurring && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir tekrar günü seçin.')),
      );
      return;
    }

    final id = widget.initialTask?.id ??
        'task_${DateTime.now().millisecondsSinceEpoch}_${title.hashCode}';

    final updatedTask = HabitTaskModel(
      id: id,
      title: title,
      timeString: _timeString,
      difficulty: _difficulty,
      isRecurring: _isRecurring,
      repeatWeekdays: _isRecurring ? _selectedDays : const [],
      specificDateIso: _isRecurring
          ? null
          : HabitTaskModel.formatDateToIso(_specificDate),
      completedDatesIso: widget.initialTask?.completedDatesIso ?? const [],
      streakCount: widget.initialTask?.streakCount ?? 0,
    );

    widget.onSave(updatedTask);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailerThemeExtension>()!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final isEditing = widget.initialTask != null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Görevi Düzenle' : 'Yeni Görev Ekle',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: cs.onSurface),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title field
              TextField(
                controller: _titleController,
                style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  labelText: 'Görev Adı',
                  hintText: 'Örn: Sabah Rotası, Seyir Defteri...',
                  prefixIcon: Icon(Icons.edit_note_rounded, color: cs.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Time picker and Date / Recurring info
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.onSurface,
                        side: BorderSide(color: cs.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _pickTime,
                      icon: Icon(Icons.access_time_rounded, color: cs.primary),
                      label: Text(
                        _timeString != null ? 'Saat: $_timeString' : 'Saat Seç',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  if (_timeString != null) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: () => setState(() => _timeString = null),
                      icon: Icon(Icons.clear_rounded, color: cs.error),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Difficulty label & selector
              Text(
                'Zorluk / Öncelik Seviyesi',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildDifficultyOption(
                    context: context,
                    level: 0,
                    title: 'Bebek Mavisi\n(Sıradan)',
                    bgColor: ext.babyBlueBg,
                    fgColor: ext.babyBlueFg,
                    borderColor: ext.babyBlueBorder,
                    hasDeepShadow: false,
                  ),
                  const SizedBox(width: 8),
                  _buildDifficultyOption(
                    context: context,
                    level: 1,
                    title: 'Normal Mavi\n(Orta)',
                    bgColor: ext.normalBlueBg,
                    fgColor: ext.normalBlueFg,
                    borderColor: ext.normalBlueBorder,
                    hasDeepShadow: false,
                  ),
                  const SizedBox(width: 8),
                  _buildDifficultyOption(
                    context: context,
                    level: 2,
                    title: 'Lacivert\n(Acil / Zor)',
                    bgColor: ext.urgentNavyBg,
                    fgColor: ext.urgentNavyFg,
                    borderColor: ext.urgentNavyBorder,
                    hasDeepShadow: true,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Recurring vs Specific Date
              if (_isRecurring) ...[
                Text(
                  'Tekrarlanacak Günler (Samsung Alarm Tarzı)',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                ),
                const SizedBox(height: 10),
                WeekdaySelectorBar(
                  selectedDays: _selectedDays,
                  onChanged: (days) => setState(() => _selectedDays = days),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tarih: ${HabitTaskModel.formatDateToIso(_specificDate)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                    ),
                    TextButton.icon(
                      onPressed: _pickDate,
                      icon: Icon(Icons.calendar_month_rounded, color: cs.primary),
                      label: Text(
                        'Değiştir',
                        style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(
                  isEditing ? Icons.check_circle_rounded : Icons.sailing_rounded,
                  color: cs.onPrimary,
                ),
                label: Text(isEditing ? 'Değişiklikleri Kaydet' : 'Görevi Başlat'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyOption({
    required BuildContext context,
    required int level,
    required String title,
    required Color bgColor,
    required Color fgColor,
    required Color borderColor,
    required bool hasDeepShadow,
  }) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailerThemeExtension>()!;
    final isSelected = _difficulty == level;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _difficulty = level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? ext.lightningYellow : borderColor,
              width: isSelected ? 2.8 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: hasDeepShadow ? ext.deepNavyShadow : cs.outlineVariant,
                blurRadius: hasDeepShadow ? 12 : 6,
                offset: Offset(0, hasDeepShadow ? 5 : 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: fgColor,
                size: 20,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fgColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
