import 'package:flutter/material.dart';

class WeekdaySelectorBar extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;

  const WeekdaySelectorBar({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> _days = [
    {'name': 'P', 'value': 1, 'label': 'Pazartesi'},
    {'name': 'S', 'value': 2, 'label': 'Salı'},
    {'name': 'Ç', 'value': 3, 'label': 'Çarşamba'},
    {'name': 'P', 'value': 4, 'label': 'Perşembe'},
    {'name': 'C', 'value': 5, 'label': 'Cuma'},
    {'name': 'C', 'value': 6, 'label': 'Cumartesi'},
    {'name': 'P', 'value': 7, 'label': 'Pazar'},
  ];

  void _toggleDay(int dayValue) {
    final updated = List<int>.from(selectedDays);
    if (updated.contains(dayValue)) {
      updated.remove(dayValue);
    } else {
      updated.add(dayValue);
    }
    updated.sort();
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _days.map((day) {
        final val = day['value'] as int;
        final name = day['name'] as String;
        final isSelected = selectedDays.contains(val);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Semantics(
              label: day['label'] as String,
              selected: isSelected,
              button: true,
              child: InkWell(
                onTap: () => _toggleDay(val),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? cs.primary : cs.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? cs.primary : cs.outlineVariant,
                      width: isSelected ? 2 : 1.2,
                    ),
                  ),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: isSelected ? cs.onPrimary : cs.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
