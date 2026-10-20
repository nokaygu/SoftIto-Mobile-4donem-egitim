import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import 'specialist_assign_modal.dart';

class AdminApprovalActionCard extends StatelessWidget {
  const AdminApprovalActionCard({
    super.key,
    required this.startup,
  });

  final DealStartup startup;

  void _openSpecialistModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpecialistAssignModal(startupName: startup.name),
    );
  }

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
            _buildHeader(isDark),
            const SizedBox(height: 10),
            _buildDetails(isDark),
            const SizedBox(height: 14),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  startup.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                if (startup.isApprovedByAdmin)
                  const Icon(Icons.verified_rounded, size: 16, color: AppColors.darkSuccess)
                else
                  const Icon(Icons.hourglass_top_rounded, size: 15, color: Color(0xFFF59E0B)),
              ],
            ),
            Text(
              '${startup.founder} • ${startup.sector}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: startup.isApprovedByAdmin
                ? AppColors.darkSuccess.withValues(alpha: 0.15)
                : const Color(0xFFF59E0B).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            startup.isApprovedByAdmin ? 'ONAYLI' : 'BEKLEMEDE',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: startup.isApprovedByAdmin ? AppColors.darkSuccess : const Color(0xFFF59E0B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(bool isDark) {
    return Text(
      'Hedef Yatırım: ${startup.fundingGoal} • Aşama: ${startup.stage}\nÖzet: ${startup.summary}',
      style: TextStyle(
        fontSize: 12,
        height: 1.4,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _openSpecialistModal(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 9),
              side: const BorderSide(color: Color(0xFFF59E0B)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Uzman Ata', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B))),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => AuthRoleController.instance.toggleStartupAdminApproval(startup.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: startup.isApprovedByAdmin ? Colors.redAccent.withValues(alpha: 0.8) : AppColors.darkSuccess,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              startup.isApprovedByAdmin ? 'Onayı Kaldır' : 'Başvuruyu Onayla',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
