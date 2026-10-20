import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/ambient_background.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../widgets/role_card.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  void _selectRole(BuildContext context, UserRole role) {
    AuthRoleController.instance.setRole(role);
  }

  @override
  Widget build(BuildContext context) {
    return AmbientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context),
                const SizedBox(height: 24),
                _buildWelcomeHeader(context),
                const SizedBox(height: 24),
                _buildRoleCards(context),
                const SizedBox(height: 16),
                _buildSecurityFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LiquidGlassContainer(
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.darkSuccess,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'KURUCU ECOSYSTEM v2.0',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          onPressed: () => ThemeController.instance.toggleTheme(),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Erişim Modunu Seçin',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Kurucu ekosisteminde rolünüze göre özelleştirilmiş araçlar, denetim masaları ve yatırım vitrini sizi bekliyor.',
          style: TextStyle(
            fontSize: 13.5,
            height: 1.4,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCards(BuildContext context) {
    return Column(
      children: [
        RoleCard(
          role: UserRole.entrepreneur,
          badge: 'GİRİŞİMCİ & YATIRIM ALAN',
          title: 'Yatırım Alan Portalı',
          subtitle: 'İş fikrini şirketleştir, ücretsiz hukuk ve mali destek al, yatırımcılara sun.',
          features: const [
            'Şirketleşme & Hukuki Stepper (Ücretsiz Avukat & SMMM)',
            'Melek ve VC Yatırımcılara Pitch Deck Gönderimi',
            'KOSGEB & TÜBİTAK Hibe Başvuru Portalı',
          ],
          accentColor: AppColors.lightAccent,
          icon: Icons.rocket_launch_rounded,
          onTap: () => _selectRole(context, UserRole.entrepreneur),
        ),
        RoleCard(
          role: UserRole.investor,
          badge: 'YATIRIMCI & FON YÖNETİMİ',
          title: 'Yatırımcı Portalı (Deal Flow)',
          subtitle: 'Yatırım arayan start-up havuzunu incele, değerlendir ve doğrudan niyet mektubu sun.',
          features: const [
            'Canlı Girişim Havuzu & Pitch Deck İnceleme',
            'Gelen Başvuruları Onaylama & Term Sheet İletme',
            'Portföy Takibi & Ortak Yatırım (Sendika) Ağı',
          ],
          accentColor: AppColors.investorAccentLight,
          icon: Icons.account_balance_wallet_rounded,
          onTap: () => _selectRole(context, UserRole.investor),
        ),
        RoleCard(
          role: UserRole.admin,
          badge: 'SİSTEM YÖNETİCİSİ & DENETİM',
          title: 'Admin Kontrol & Denetim Masası',
          subtitle: 'Girişim başvurularını denetle, hukukçu ve mali müşavir ata, yatırımcıları akredite et.',
          features: const [
            'Girişim Başvuru Onay/Red & Uzman Atama Masası',
            'Yatırımcı Akreditasyon & Güvenilirlik Onayı',
            'Canlı Ekosistem KPI & Finansman Hacmi Takibi',
          ],
          accentColor: const Color(0xFFF59E0B), // Altın Amber
          icon: Icons.admin_panel_settings_rounded,
          onTap: () => _selectRole(context, UserRole.admin),
        ),
      ],
    );
  }

  Widget _buildSecurityFooter(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          const SizedBox(width: 6),
          Text(
            'Apple Liquid Glass Güvenlik & Denetim Standardı',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
