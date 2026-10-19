import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WaterProgressIndicator extends StatelessWidget {
  final double progress;
  final int consumedMl;
  final int goalMl;

  const WaterProgressIndicator({
    super.key,
    required this.progress,
    required this.consumedMl,
    required this.goalMl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 16,
              backgroundColor: AppColors.surfaceElevated,
              color: AppColors.neonCyan,
              strokeCap: StrokeCap.round,
            ),
          ),
          _WaterProgressLabels(
            consumedMl: consumedMl,
            goalMl: goalMl,
          ),
        ],
      ),
    );
  }
}

class _WaterProgressLabels extends StatelessWidget {
  final int consumedMl;
  final int goalMl;

  const _WaterProgressLabels({
    required this.consumedMl,
    required this.goalMl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/app_logo.png',
          width: 44,
          height: 44,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 6),
        Text(
          '$consumedMl ml',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'Hedef: $goalMl ml',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
