import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/state/app_state.dart';
import '../models/user_model.dart';
import '../widgets/liquid_app_bar.dart';
import '../widgets/liquid_badge.dart';
import '../widgets/liquid_button.dart';
import '../widgets/liquid_glass_card.dart';

/// Profil Ekranı: Skor, Yorumlar, Avatar Seçimi ve Çıkış Yap
class ProfilScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfilScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: AppState.userProfile.currentUser,
      builder: (context, user, _) {
        if (user == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: const LiquidAppBar(title: 'Profilim'),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileHeaderCard(context, user),
              const SizedBox(height: 14),
              _buildScoreOverviewCard(user),
              const SizedBox(height: 14),
              _buildReviewsSection(user),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeaderCard(BuildContext context, UserModel user) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: AppColors.burgundyPrimary.withValues(alpha: 0.35),
                child: Icon(_resolveAvatarIcon(user.avatarUrl), size: 44, color: AppColors.textWhite),
              ),
              GestureDetector(
                onTap: () => _showAvatarPicker(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.burgundyAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, size: 16, color: AppColors.textWhite),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.adSoyad,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 10),
          LiquidBadge(
            text: user.isKirayaVeren ? 'Kiraya Veren (Araç Sahibi)' : 'Kiralayan (Kiracı)',
            type: user.isKirayaVeren ? LiquidBadgeType.burgundy : LiquidBadgeType.success,
            icon: user.isKirayaVeren ? Icons.vpn_key : Icons.directions_car,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreOverviewCard(UserModel user) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricColumn('Güven Skoru', '${user.skor} ★', AppColors.starActive),
          Container(height: 36, width: 1, color: AppColors.glassBorder),
          _buildMetricColumn('Puan Sayısı', '${user.puanSayisi}', AppColors.textPrimary),
          Container(height: 36, width: 1, color: AppColors.glassBorder),
          _buildMetricColumn('Yorumlar', '${user.yorumlar.length}', AppColors.burgundyLight),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _buildReviewsSection(UserModel user) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hakkımdaki Değerlendirmeler',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${user.yorumlar.length} Adet',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (user.yorumlar.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Henüz hakkınızda bir yorum yapılmamış.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            )
          else
            ...user.yorumlar.map(_buildReviewItem),
        ],
      ),
    );
  }

  Widget _buildReviewItem(KullaniciYorumu y) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                y.yorumYapanAd,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 14, color: AppColors.starActive),
                  const SizedBox(width: 2),
                  Text(
                    '${y.puan}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(y.yorum, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return LiquidButton(
      text: 'Oturumu Kapat',
      icon: Icons.logout_rounded,
      isPrimary: false,
      onPressed: () {
        AppState.userProfile.logout();
        onLogout();
      },
    );
  }

  void _showAvatarPicker(BuildContext context) {
    final avatarSecenekleri = [
      ('speed', Icons.speed_rounded, 'Hız Tutkunu'),
      ('directions_car', Icons.directions_car_rounded, 'Klasik Sürücü'),
      ('electric_car', Icons.electric_bolt_rounded, 'Elektrikli'),
      ('sports_car', Icons.sports_motorsports_rounded, 'Yarışçı'),
      ('person', Icons.person_pin_rounded, 'Kurumsal'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.glassBorder),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profil İkonunu Seç',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: avatarSecenekleri.map((opt) {
                  return GestureDetector(
                    onTap: () {
                      AppState.userProfile.updateAvatar(opt.$1);
                      Navigator.pop(ctx);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.surfaceVariant,
                          child: Icon(opt.$2, color: AppColors.burgundyLight, size: 28),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          opt.$3,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  IconData _resolveAvatarIcon(String key) {
    switch (key) {
      case 'speed':
        return Icons.speed_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'electric_car':
        return Icons.electric_bolt_rounded;
      case 'sports_car':
        return Icons.sports_motorsports_rounded;
      default:
        return Icons.person_rounded;
    }
  }
}
