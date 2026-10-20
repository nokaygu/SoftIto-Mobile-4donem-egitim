import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../widgets/admin_approval_action_card.dart';

class AdminStartupReviewView extends StatelessWidget {
  const AdminStartupReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<DealStartup>>(
      valueListenable: AuthRoleController.instance.dealStartupsNotifier,
      builder: (context, startups, _) {
        final pendingCount = startups.where((s) => !s.isApprovedByAdmin).length;

        return ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 110),
          children: [
            _buildStatBanner(isDark, pendingCount, startups.length),
            const SizedBox(height: 14),
            for (final startup in startups)
              AdminApprovalActionCard(startup: startup),
          ],
        );
      },
    );
  }

  Widget _buildStatBanner(bool isDark, int pending, int total) {
    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 8),
              Text(
                'Girişimci Başvuru Havuzu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$pending Onay Bekliyor / $total Toplam',
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B)),
            ),
          ),
        ],
      ),
    );
  }
}
