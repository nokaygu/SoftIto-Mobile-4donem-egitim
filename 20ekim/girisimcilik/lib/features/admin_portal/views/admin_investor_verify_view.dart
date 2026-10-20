import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';

class AdminInvestorVerifyView extends StatelessWidget {
  const AdminInvestorVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<InvestorVerificationItem>>(
      valueListenable: AuthRoleController.instance.investorVerificationsNotifier,
      builder: (context, items, _) {
        return ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 110),
          children: [
            _buildInfoCard(isDark),
            const SizedBox(height: 14),
            for (final item in items)
              _buildInvestorItem(context, item, isDark),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: Color(0xFFF59E0B), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Yatırımcı Akreditasyon Masası: Yetki belgelerini doğrulayarak melek ve VC’lere mavi rozet tanımlayın.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestorItem(BuildContext context, InvestorVerificationItem item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                      if (item.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded, size: 14, color: AppColors.darkSuccess),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.type} • ${item.organization}\nBütçe: ${item.ticketSize} • ${item.requestDate}',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => AuthRoleController.instance.toggleInvestorVerification(item.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: item.isVerified ? Colors.redAccent.withValues(alpha: 0.8) : AppColors.darkSuccess,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                item.isVerified ? 'Askıya Al' : 'Akredite Et',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
