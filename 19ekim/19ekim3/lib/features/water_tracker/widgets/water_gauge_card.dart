import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Su tüketim ilerlemesini gösteren dairesel neon gösterge kartı
class WaterGaugeCard extends StatelessWidget {
  final int currentWater;
  final int dailyGoal;

  const WaterGaugeCard({
    super.key,
    required this.currentWater,
    required this.dailyGoal,
  });

  double get _progress => (currentWater / dailyGoal).clamp(0.0, 1.0);
  int get _percentage => (_progress * 100).toInt();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardSurface : AppColors.lightCardSurface;
    final borderColor = isDark ? AppColors.borderGlow : AppColors.lightBorder;
    final shadowColor = isDark ? const Color(0x2200E5FF) : const Color(0x110284C7);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCircularProgress(context),
          const SizedBox(height: 16),
          _buildSubtitle(context),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final trackColor = isDark ? AppColors.surface : AppColors.lightSurfaceElevated;
    final accentColor = theme.colorScheme.primary;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 170,
          height: 170,
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 14,
            backgroundColor: trackColor,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop, color: accentColor, size: 36),
            const SizedBox(height: 4),
            Text(
              '$currentWater ml',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              '%$_percentage Hedef',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      'Günlük Hedef: $dailyGoal ml',
      style: TextStyle(
        fontSize: 14,
        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
