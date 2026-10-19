import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_record_model.dart';

/// Tekil su geçmişi kaydı öğesi
class WaterRecordTile extends StatelessWidget {
  final WaterRecord record;
  final VoidCallback onDelete;

  const WaterRecordTile({
    super.key,
    required this.record,
    required this.onDelete,
  });

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.borderDark : AppColors.lightBorder;
    final primaryAccent = isDark ? AppColors.neonCyan : AppColors.lightPrimary;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.water_drop, color: primaryAccent, size: 20),
          const SizedBox(width: 12),
          Text(
            '+${record.amountMl} ml',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            _formatTime(record.timestamp),
            style: TextStyle(color: mutedColor, fontSize: 12),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.close, size: 16, color: mutedColor),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
