import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı su ekleme ve sıfırlama butonları grubu
class WaterQuickButtons extends StatelessWidget {
  final ValueChanged<int> onAdd;
  final VoidCallback onReset;

  const WaterQuickButtons({
    super.key,
    required this.onAdd,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildButton(context, '+200 ml', () => onAdd(200))),
            const SizedBox(width: 10),
            Expanded(child: _buildButton(context, '+250 ml', () => onAdd(250))),
            const SizedBox(width: 10),
            Expanded(child: _buildButton(context, '+500 ml', () => onAdd(500))),
          ],
        ),
        const SizedBox(height: 10),
        _buildResetButton(),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final fgColor = isDark ? AppColors.neonCyan : AppColors.lightPrimary;
    final borderColor =
        isDark ? AppColors.borderGlow : AppColors.lightBorderGlow;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        side: BorderSide(color: borderColor),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonCoral,
          side: const BorderSide(color: AppColors.neonCoral),
        ),
        onPressed: onReset,
        icon: const Icon(Icons.restart_alt, size: 18),
        label: const Text('Sayacı Sıfırla'),
      ),
    );
  }
}
