import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AddWorkoutSheet extends StatefulWidget {
  final void Function(String title, int duration, int calories, IconData icon)
      onAdd;

  const AddWorkoutSheet({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddWorkoutSheet> createState() => _AddWorkoutSheetState();
}

class _AddWorkoutSheetState extends State<AddWorkoutSheet> {
  final _titleController = TextEditingController(text: 'Squat & Bacak');
  final _durationController = TextEditingController(text: '30');
  final _caloriesController = TextEditingController(text: '220');
  IconData _selectedIcon = Icons.fitness_center;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final duration = int.tryParse(_durationController.text) ?? 20;
    final calories = int.tryParse(_caloriesController.text) ?? 150;

    if (title.isNotEmpty) {
      widget.onAdd(title, duration, calories, _selectedIcon);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SheetHeader(),
          const SizedBox(height: 16),
          _IconSelector(
            selectedIcon: _selectedIcon,
            onSelect: (icon) => setState(() => _selectedIcon = icon),
          ),
          const SizedBox(height: 16),
          _FormFields(
            titleController: _titleController,
            durationController: _durationController,
            caloriesController: _caloriesController,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.add),
            label: const Text('Egzersizi Ekle'),
          ),
        ],
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Yeni Egzersiz Kartı Ekle',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _IconSelector extends StatelessWidget {
  final IconData selectedIcon;
  final ValueChanged<IconData> onSelect;

  static const List<IconData> _availableIcons = [
    Icons.fitness_center,
    Icons.directions_run,
    Icons.pedal_bike,
    Icons.sports_mma,
    Icons.pool,
    Icons.self_improvement,
  ];

  const _IconSelector({
    required this.selectedIcon,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _availableIcons.map((icon) {
        final isSelected = selectedIcon == icon;
        return IconButton.filledTonal(
          onPressed: () => onSelect(icon),
          style: IconButton.styleFrom(
            backgroundColor: isSelected
                ? AppColors.neonCyan
                : AppColors.surfaceElevated,
            foregroundColor: isSelected
                ? AppColors.background
                : AppColors.textSecondary,
          ),
          icon: Icon(icon),
        );
      }).toList(),
    );
  }
}

class _FormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController durationController;
  final TextEditingController caloriesController;

  const _FormFields({
    required this.titleController,
    required this.durationController,
    required this.caloriesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Egzersiz Adı',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Süre (dk)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kalori (kcal)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
