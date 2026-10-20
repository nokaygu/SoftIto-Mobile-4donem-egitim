import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../../onboarding/models/business_application.dart';

class AssignedSpecialistsCard extends StatelessWidget {
  const AssignedSpecialistsCard({
    required this.application,
    super.key,
  });

  final BusinessApplication application;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isApproved = application.isApproved;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(26),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildGuaranteeBadge(isApproved, isDark),
          const SizedBox(height: 16),
          _buildSpecialistTile(
            title: 'Atanan Ücretsiz Hukuk Danışmanı',
            name: application.assignedLawyer ?? 'Av. Selin Kaya (Beklemede)',
            subtitle: 'Start-up Hukuku, Esas Sözleşme, Ortaklar Sözleşmesi (SHA)',
            icon: Icons.gavel_rounded,
            isApproved: isApproved,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _buildSpecialistTile(
            title: 'Atanan Şirket Mali Müşaviri',
            name: application.assignedAccountant ?? 'SMMM Emre Demir (Beklemede)',
            subtitle: 'Teknokent Muafiyetleri, Kuruluş Defterleri, Vergi Planlama',
            icon: Icons.account_balance_rounded,
            isApproved: isApproved,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeBadge(bool isApproved, bool isDark) {
    final successColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
    final bg = isApproved ? successColor.withValues(alpha: 0.16) : Colors.amber.withValues(alpha: 0.14);
    final textCol = isApproved ? successColor : Colors.amber.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textCol.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        children: [
          Icon(isApproved ? Icons.workspace_premium_rounded : Icons.pending_actions_rounded, color: textCol, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isApproved ? 'Maddi Destek Garantisi Sertifikalı' : 'Uzman Onayı Bekleniyor',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textCol),
                ),
                Text(
                  isApproved
                      ? 'Devlet ve özel fonlardan %100 kuruluş & avukat hibesi güvencesi.'
                      : 'Yukarıdaki Dynamic Island simülasyonundan onayı vererek aktif edin.',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistTile({
    required String title,
    required String name,
    required String subtitle,
    required IconData icon,
    required bool isApproved,
    required bool isDark,
  }) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.07) : Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isApproved
                  ? accent.withValues(alpha: 0.20)
                  : (isDark ? Colors.white.withValues(alpha: 0.10) : Colors.grey.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isApproved ? accent : (isDark ? const Color(0xFF94A3B8) : Colors.grey),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isApproved
                        ? (isDark ? Colors.white : AppColors.lightTextPrimary)
                        : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildActionButton(isApproved, isDark),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool isApproved, bool isDark) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: isApproved
            ? accent
            : (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isApproved
              ? accent.withValues(alpha: 0.6)
              : (isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Text(
        isApproved ? 'Görüş' : 'Kilitli',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isApproved
              ? Colors.white
              : (isDark ? const Color(0xFFCBD5E1) : Colors.black87),
        ),
      ),
    );
  }
}
