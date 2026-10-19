import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

/// Ekrana yeni egzersiz kartı eklemek için hazır egzersiz seçenekleri sunan widget.
class WorkoutPresetSelector extends StatelessWidget {
  const WorkoutPresetSelector({
    super.key,
    required this.presets,
    required this.onSelectPreset,
  });

  final List<WorkoutModel> presets;
  final ValueChanged<WorkoutModel> onSelectPreset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Hızlı Egzersiz Ekle', style: context.textTheme.titleMedium),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: presets
                .map(
                  (WorkoutModel item) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      key: Key('preset_${item.id}'),
                      avatar: Icon(
                        item.iconData,
                        size: 18,
                        color: context.colorScheme.secondary,
                      ),
                      label: Text(
                        '${item.title} (+${item.caloriesBurned} kcal)',
                      ),
                      onPressed: () => onSelectPreset(item),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
