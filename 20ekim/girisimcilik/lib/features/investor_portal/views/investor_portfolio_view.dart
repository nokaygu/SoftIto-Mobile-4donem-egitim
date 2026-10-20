import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';

class InvestorPortfolioView extends StatelessWidget {
  const InvestorPortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 110),
      children: [
        _buildSummaryCards(isDark),
        const SizedBox(height: 18),
        Text(
          'Aktif Yatırımlar & Portföy',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildPortfolioItem('NovaTech AI', 'Tohum Öncesi', '2.500.000 ₺', '%8', '3.8x Katlanma', isDark),
        _buildPortfolioItem('ScaleFlow SaaS', 'Tohum', '4.000.000 ₺', '%12', '2.4x Katlanma', isDark),
        _buildPortfolioItem('CyberGuard TR', 'Seri A', '12.000.000 ₺', '%6', '1.9x Katlanma', isDark),
      ],
    );
  }

  Widget _buildSummaryCards(bool isDark) {
    return Row(
      children: [
        _buildStatCard('Toplam Yatırım', '18.5M ₺', Icons.account_balance_rounded, isDark),
        const SizedBox(width: 10),
        _buildStatCard('Ortalama Çarpan', '2.7x MOIC', Icons.show_chart_rounded, isDark),
        const SizedBox(width: 10),
        _buildStatCard('Şirket Sayısı', '3 Aktif', Icons.pie_chart_rounded, isDark),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, bool isDark) {
    return Expanded(
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: AppColors.investorAccentLight),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            const SizedBox(height: 3),
            Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioItem(String name, String stage, String investment, String equity, String returnRate, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                const SizedBox(height: 2),
                Text('$stage • Yatırım: $investment • Pay: $equity', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.darkSuccess.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(returnRate, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.darkSuccess)),
            ),
          ],
        ),
      ),
    );
  }
}
