import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../widgets/deal_evaluation_modal.dart';

class IncomingPitchesView extends StatelessWidget {
  const IncomingPitchesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<DealStartup>>(
      valueListenable: AuthRoleController.instance.dealStartupsNotifier,
      builder: (context, startups, _) {
        final withPitches = startups.where((s) => s.hasPitchDeck).toList();

        return ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 110),
          children: [
            _buildHeaderBadge(isDark, withPitches.length),
            const SizedBox(height: 12),
            for (final startup in withPitches)
              _buildPitchItem(context, startup, isDark),
          ],
        );
      },
    );
  }

  Widget _buildHeaderBadge(bool isDark, int count) {
    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.inbox_rounded, color: AppColors.investorAccentLight, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$count Girişim Doğrudan Size Pitch Deck İletti',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPitchItem(BuildContext context, DealStartup startup, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  startup.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.darkSuccess.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'PDF / Pitch Deck Hazır',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.darkSuccess),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${startup.founder} • Talep: ${startup.fundingGoal} (${startup.equityOffered} Pay)',
              style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DealEvaluationModal(startup: startup),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.investorAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Sunumu İncele & Karar Ver', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
