import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/investor.dart';

class InvestorFilterBar extends StatelessWidget {
  const InvestorFilterBar({
    required this.selectedType,
    required this.onSelect,
    super.key,
  });

  final InvestorType? selectedType; // null means all
  final ValueChanged<InvestorType?> onSelect;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _buildFilterChip('Tüm Yatırımcılar', null, isDark),
          _buildFilterChip('Melek Yatırımcılar', InvestorType.angel, isDark),
          _buildFilterChip('Kurumsal / VC', InvestorType.vc, isDark),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, InvestorType? type, bool isDark) {
    final isSelected = selectedType == type;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
