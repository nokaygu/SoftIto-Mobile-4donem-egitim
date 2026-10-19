import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Hızlı su ekleme, azaltma ve sıfırlama butonlarını barındıran widget.
class WaterQuickActions extends StatelessWidget {
  const WaterQuickActions({
    super.key,
    required this.onAdd200,
    required this.onAdd250,
    required this.onAdd500,
    required this.onRemove250,
    required this.onReset,
  });

  final VoidCallback onAdd200;
  final VoidCallback onAdd250;
  final VoidCallback onAdd500;
  final VoidCallback onRemove250;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Hızlı Su Ekle', style: context.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            ElevatedButton.icon(
              key: const Key('add_200_btn'),
              onPressed: onAdd200,
              icon: const Icon(Icons.local_cafe_outlined),
              label: const Text('+200 ml'),
            ),
            ElevatedButton.icon(
              key: const Key('add_250_btn'),
              onPressed: onAdd250,
              icon: const Icon(Icons.local_drink),
              label: const Text('+250 ml'),
            ),
            ElevatedButton.icon(
              key: const Key('add_500_btn'),
              onPressed: onAdd500,
              icon: const Icon(Icons.water_drop),
              label: const Text('+500 ml'),
            ),
            OutlinedButton.icon(
              key: const Key('remove_250_btn'),
              onPressed: onRemove250,
              icon: const Icon(Icons.remove),
              label: const Text('-250 ml'),
            ),
            OutlinedButton.icon(
              key: const Key('reset_water_btn'),
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Sıfırla'),
            ),
          ],
        ),
      ],
    );
  }
}
