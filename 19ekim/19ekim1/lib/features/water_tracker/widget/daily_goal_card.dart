import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DailyGoalCard extends StatelessWidget {
  final int remainingMl;
  final bool isGoalReached;
  final VoidCallback onReset;

  const DailyGoalCard({
    super.key,
    required this.remainingMl,
    required this.isGoalReached,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            _GoalStatusIcon(isGoalReached: isGoalReached),
            const SizedBox(width: 16),
            Expanded(
              child: _GoalStatusText(
                isGoalReached: isGoalReached,
                remainingMl: remainingMl,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.restart_alt, color: AppColors.textMuted),
              tooltip: 'Günü Sıfırla',
              onPressed: onReset,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalStatusIcon extends StatelessWidget {
  final bool isGoalReached;

  const _GoalStatusIcon({required this.isGoalReached});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isGoalReached
            ? AppColors.neonGreen.withAlpha(40)
            : AppColors.neonCyan.withAlpha(30),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isGoalReached ? Icons.check_circle : Icons.flag_outlined,
        color: isGoalReached ? AppColors.neonGreen : AppColors.neonCyan,
        size: 24,
      ),
    );
  }
}

class _GoalStatusText extends StatelessWidget {
  final bool isGoalReached;
  final int remainingMl;

  const _GoalStatusText({
    required this.isGoalReached,
    required this.remainingMl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isGoalReached ? 'Tebrikler! 🎉' : 'Kalan Miktar',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          isGoalReached
              ? 'Günlük su hedefine ulaştın!'
              : '$remainingMl ml daha içmelisin.',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
