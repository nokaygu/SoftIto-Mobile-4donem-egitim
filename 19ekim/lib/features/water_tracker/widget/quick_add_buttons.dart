import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuickAddButtons extends StatelessWidget {
  final void Function(int amount) onAddWater;

  const QuickAddButtons({
    super.key,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickAddButton(
          amount: 150,
          label: '150 ml',
          icon: Icons.local_cafe_outlined,
          onTap: () => onAddWater(150),
        ),
        _QuickAddButton(
          amount: 250,
          label: '250 ml',
          icon: Icons.water_drop_outlined,
          onTap: () => onAddWater(250),
        ),
        _QuickAddButton(
          amount: 500,
          label: '500 ml',
          icon: Icons.sports_bar_outlined,
          onTap: () => onAddWater(500),
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.neonCyan, size: 24),
            const SizedBox(height: 6),
            Text(
              '+$label',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
