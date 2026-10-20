import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';

class DealStartupCard extends StatelessWidget {
  const DealStartupCard({
    super.key,
    required this.startup,
    required this.onActionTap,
  });

  final DealStartup startup;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(22),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopRow(isDark),
            const SizedBox(height: 10),
            _buildSummary(isDark),
            const SizedBox(height: 14),
            _buildMetricsGrid(isDark),
            const SizedBox(height: 14),
            _buildBottomActionRow(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      startup.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  if (startup.isApprovedByAdmin) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified_rounded, size: 16, color: AppColors.darkSuccess),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Kurucu: ${startup.founder} • ${startup.sector}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildStageBadge(),
      ],
    );
  }

  Widget _buildStageBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.investorAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.investorAccentLight.withValues(alpha: 0.35)),
      ),
      child: Text(
        startup.stage,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.investorAccentLight,
        ),
      ),
    );
  }

  Widget _buildSummary(bool isDark) {
    return Text(
      startup.summary,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12.5,
        height: 1.35,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
    );
  }

  Widget _buildMetricsGrid(bool isDark) {
    return Row(
      children: [
        _buildMetricItem(isDark, 'Hedef Yatırım', startup.fundingGoal, Icons.monetization_on_outlined),
        const SizedBox(width: 10),
        _buildMetricItem(isDark, 'Teklif Edilen Hisse', startup.equityOffered, Icons.pie_chart_outline),
        const SizedBox(width: 10),
        _buildMetricItem(isDark, 'Değerleme', startup.valuation, Icons.trending_up_rounded),
      ],
    );
  }

  Widget _buildMetricItem(bool isDark, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: AppColors.darkSuccess),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionRow(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildEvaluationStatusChip(isDark),
        ElevatedButton(
          onPressed: onActionTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.investorAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.description_outlined, size: 14),
              SizedBox(width: 5),
              Text('Değerlendir / Teklif', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEvaluationStatusChip(bool isDark) {
    final (label, color) = switch (startup.evaluationStatus) {
      PitchEvaluationStatus.none => ('İncelenmedi', Colors.grey),
      PitchEvaluationStatus.pending => ('Yeni Başvuru', Colors.amber),
      PitchEvaluationStatus.reviewing => ('İncelemede', Colors.cyan),
      PitchEvaluationStatus.meetingScheduled => ('Toplantı Alındı', Colors.blue),
      PitchEvaluationStatus.termSheetSent => ('Term Sheet İletildi', AppColors.darkSuccess),
      PitchEvaluationStatus.invested => ('Yatırım Yapıldı', AppColors.darkSuccess),
    };

    return Row(
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
