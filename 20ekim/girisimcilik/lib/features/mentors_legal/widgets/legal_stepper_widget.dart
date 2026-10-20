import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/legal_step.dart';

class LegalStepperWidget extends StatelessWidget {
  const LegalStepperWidget({
    required this.steps,
    required this.onToggleStep,
    super.key,
  });

  final List<LegalStep> steps;
  final ValueChanged<int> onToggleStep;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completedCount = steps.where((s) => s.isCompleted).length;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(26),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(completedCount, isDark),
          const SizedBox(height: 14),
          _buildProgressBar(completedCount, isDark),
          const SizedBox(height: 16),
          for (int i = 0; i < steps.length; i++)
            _buildStepRow(i, steps[i], isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(int completedCount, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Şirket Kuruluş & Hukuk Adımları',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$completedCount / ${steps.length} Tamamlandı',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(int completedCount, bool isDark) {
    final progress = steps.isEmpty ? 0.0 : completedCount / steps.length;
    final color = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 6,
        backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildStepRow(int index, LegalStep step, bool isDark) {
    final successColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;

    return InkWell(
      onTap: () => onToggleStep(index),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              step.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: step.isCompleted ? successColor : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      decoration: step.isCompleted ? TextDecoration.lineThrough : null,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
