import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/investor.dart';

class InvestorCard extends StatelessWidget {
  const InvestorCard({
    required this.investor,
    required this.onSendPitch,
    required this.onContact,
    super.key,
  });

  final Investor investor;
  final VoidCallback onSendPitch;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopRow(isDark),
          const SizedBox(height: 12),
          _buildSectorChips(isDark),
          const SizedBox(height: 12),
          _buildInfoRow(isDark),
          const SizedBox(height: 14),
          _buildActionButtons(isDark),
        ],
      ),
    );
  }

  Widget _buildTopRow(bool isDark) {
    final isAngel = investor.type == InvestorType.angel;
    final badgeColor = isAngel ? AppColors.investorAccentLight : AppColors.lightAccent;

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: badgeColor.withValues(alpha: 0.16),
          child: Icon(isAngel ? Icons.person_rounded : Icons.apartment_rounded, color: badgeColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                investor.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                investor.fundName,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isAngel ? 'Melek' : 'VC / Kurumsal',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: badgeColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSectorChips(bool isDark) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: investor.focusSectors.map((sector) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08),
            ),
          ),
          child: Text(
            sector,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.attach_money_rounded, size: 16, color: Colors.grey),
            Text(
              'Aralık: ${investor.ticketSize}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        Text('${investor.portfolioCount} Portföy Girişimi', style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionButtons(bool isDark) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final isMatched = investor.isMatched;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.15)),
            ),
            onPressed: onContact,
            child: const Text('İletişime Geç', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isMatched ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess) : accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            onPressed: onSendPitch,
            icon: Icon(isMatched ? Icons.check_circle_rounded : Icons.send_rounded, size: 14),
            label: Text(
              isMatched ? 'Sunum İletildi' : 'Pitch Gönder',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
