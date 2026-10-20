import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/grant.dart';

class GrantFilterBar extends StatelessWidget {
  const GrantFilterBar({
    required this.selectedCategory,
    required this.onSelect,
    super.key,
  });

  final GrantCategory selectedCategory;
  final ValueChanged<GrantCategory> onSelect;

  static const _filters = [
    (GrantCategory.all, 'Tümü'),
    (GrantCategory.kosgeb, 'KOSGEB'),
    (GrantCategory.tubitak, 'TÜBİTAK'),
    (GrantCategory.international, 'Global / AB'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          for (final (category, label) in _filters)
            _buildItem(category, label, isDark),
        ],
      ),
    );
  }

  Widget _buildItem(GrantCategory category, String label, bool isDark) {
    final isSelected = selectedCategory == category;
    final activeColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isSelected ? Border.all(color: activeColor.withValues(alpha: 0.5)) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? activeColor : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
