import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';

class AdminMetricsView extends StatelessWidget {
  const AdminMetricsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 110),
      children: [
        _buildOverviewCards(isDark),
        const SizedBox(height: 16),
        _buildSectionTitle('Sektörel Dağılım & Hacim', isDark),
        const SizedBox(height: 10),
        _buildProgressTile('Yapay Zeka & Derin Teknoloji', '42 Girişim (%38)', 0.38, const Color(0xFF6366F1), isDark),
        _buildProgressTile('Fintech & Açık Bankacılık', '28 Girişim (%25)', 0.25, const Color(0xFF10B981), isDark),
        _buildProgressTile('Biyoteknoloji & Sağlık', '19 Girişim (%17)', 0.17, const Color(0xFFF59E0B), isDark),
        _buildProgressTile('Agritech & İklim Teknolojisi', '14 Girişim (%12)', 0.12, const Color(0xFF06B6D4), isDark),
      ],
    );
  }

  Widget _buildOverviewCards(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard('Toplam Fonlama Hacmi', '85.4M ₺', Icons.payments_rounded, const Color(0xFF10B981), isDark),
            const SizedBox(width: 10),
            _buildStatCard('Doğrulanan Girişim', '98 / 142', Icons.rocket_rounded, const Color(0xFF6366F1), isDark),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildStatCard('Akredite Yatırımcı', '45 Fon & Melek', Icons.verified_user_rounded, AppColors.investorAccentLight, isDark),
            const SizedBox(width: 10),
            _buildStatCard('Aktif Hukuki Süreç', '24 Şirket', Icons.gavel_rounded, const Color(0xFFF59E0B), isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color accent, bool isDark) {
    return Expanded(
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: accent),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    );
  }

  Widget _buildProgressTile(String label, String meta, double progress, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                Text(meta, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
