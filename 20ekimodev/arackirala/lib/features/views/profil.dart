import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/state/app_state.dart';
import '../models/user_model.dart';
import '../widgets/liquid_app_bar.dart';
import '../widgets/liquid_badge.dart';
import '../widgets/liquid_button.dart';
import '../widgets/liquid_dialog.dart';
import '../widgets/liquid_glass_card.dart';
import '../widgets/liquid_text_field.dart';

/// Profil Ekranı: Skor, Yorumlar, Avatar Seçimi, Tema Geçişi ve Çıkış Yap
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
          backgroundColor: context.scaffoldColor,
          appBar: const LiquidAppBar(title: 'Profilim'),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileHeaderCard(context, user),
              const SizedBox(height: 14),
              _buildThemeSettingsCard(context),
              const SizedBox(height: 14),
              _buildScoreOverviewCard(context, user),
              const SizedBox(height: 14),
              _buildReviewsSection(context, user),
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
          _buildAvatarStack(context, user),
          const SizedBox(height: 12),
          Text(
            user.adSoyad,
            style: TextStyle(
              color: context.textPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: context.textSecondaryColor, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            user.telefon,
            style: TextStyle(color: context.textMutedColor, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _buildRoleAndEditRow(context, user),
        ],
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context, UserModel user) {
    return Stack(
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
    );
  }

  Widget _buildRoleAndEditRow(BuildContext context, UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LiquidBadge(
          text: user.isKirayaVeren ? 'Kiraya Veren' : 'Kiralayan',
          type: user.isKirayaVeren ? LiquidBadgeType.burgundy : LiquidBadgeType.success,
          icon: user.isKirayaVeren ? Icons.vpn_key : Icons.directions_car,
        ),
        const SizedBox(width: 8),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _showEditProfileDialog(context, user),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: context.surfaceVariantColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.glassBorderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit_note_rounded, size: 14, color: AppColors.burgundyLight),
                const SizedBox(width: 4),
                Text(
                  'Düzenle',
                  style: TextStyle(
                    color: context.textPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSettingsCard(BuildContext context) {
    final isDark = context.isDark;

    return LiquidGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.burgundyPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: AppColors.burgundyLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Görünüm & Tema',
                  style: TextStyle(
                    color: context.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  isDark ? 'Karanlık Mod (Karbon & Bordo)' : 'Aydınlık Mod (Gümüş & Bordo)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.textMutedColor, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isDark,
            activeThumbColor: AppColors.burgundyLight,
            activeTrackColor: AppColors.burgundyPrimary.withValues(alpha: 0.5),
            inactiveThumbColor: AppColors.burgundyPrimary,
            inactiveTrackColor: AppColors.surfaceVariantLight,
            onChanged: (_) => AppState.theme.toggleTheme(),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreOverviewCard(BuildContext context, UserModel user) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricColumn(context, 'Güven Skoru', '${user.skor} ★', AppColors.starActive),
          Container(height: 36, width: 1, color: context.glassBorderColor),
          _buildMetricColumn(context, 'Puan Sayısı', '${user.puanSayisi}', context.textPrimaryColor),
          Container(height: 36, width: 1, color: context.glassBorderColor),
          _buildMetricColumn(context, 'Yorumlar', '${user.yorumlar.length}', AppColors.burgundyLight),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: context.textMutedColor, fontSize: 12)),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context, UserModel user) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hakkımdaki Değerlendirmeler',
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${user.yorumlar.length} Adet',
                style: TextStyle(color: context.textMutedColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (user.yorumlar.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Henüz hakkınızda bir yorum yapılmamış.',
                style: TextStyle(color: context.textMutedColor, fontSize: 13),
              ),
            )
          else
            ...user.yorumlar.map((y) => _buildReviewItem(context, y)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, KullaniciYorumu y) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.glassBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                y.yorumYapanAd,
                style: TextStyle(
                  color: context.textPrimaryColor,
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
                    style: TextStyle(
                      color: context.textSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(y.yorum, style: TextStyle(color: context.textSecondaryColor, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return LiquidButton(
      text: 'Oturumu Kapat',
      icon: Icons.logout_rounded,
      isPrimary: false,
      onPressed: () => _handleLogoutConfirmation(context),
    );
  }

  Future<void> _handleLogoutConfirmation(BuildContext context) async {
    final confirmed = await showLiquidConfirmationDialog(
      context,
      title: 'Oturumu Kapat',
      message: 'Hesabınızdan çıkış yapmak istediğinize emin misiniz? Tekrar giriş yapmanız gerekecektir.',
      confirmText: 'Çıkış Yap',
      cancelText: 'Vazgeç',
      isDestructive: true,
      icon: Icons.logout_rounded,
    );

    if (confirmed == true) {
      AppState.userProfile.logout();
      onLogout();
    }
  }

  void _showEditProfileDialog(BuildContext context, UserModel user) {
    final formKey = GlobalKey<FormState>();
    final adCtrl = TextEditingController(text: user.adSoyad);
    final emailCtrl = TextEditingController(text: user.email);
    final telefonCtrl = TextEditingController(text: user.telefon);

    showLiquidDialog(
      context: context,
      title: 'Profili Düzenle',
      icon: Icons.edit_rounded,
      iconColor: AppColors.burgundyLight,
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LiquidTextField(
              controller: adCtrl,
              label: 'Ad Soyad',
              prefixIcon: Icons.person_outline,
              validator: (v) => v == null || v.trim().length < 3 ? 'En az 3 karakter giriniz' : null,
            ),
            const SizedBox(height: 12),
            LiquidTextField(
              controller: emailCtrl,
              label: 'E-posta',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || !v.contains('@') || !v.contains('.')) {
                  return 'Geçerli bir e-posta adresi giriniz';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            LiquidTextField(
              controller: telefonCtrl,
              label: 'Telefon Numarası',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().length < 10 ? 'Geçerli bir telefon giriniz' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('İptal', style: TextStyle(color: context.textMutedColor)),
        ),
        const SizedBox(width: 8),
        LiquidButton(
          text: 'Kaydet',
          height: 40,
          isFullWidth: false,
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            AppState.userProfile.updateProfile(
              adSoyad: adCtrl.text,
              email: emailCtrl.text,
              telefon: telefonCtrl.text,
            );
            Navigator.pop(context);
            await showLiquidSuccessDialog(
              context,
              title: 'Profil Güncellendi',
              message: 'Bilgileriniz başarıyla güncellendi.',
            );
          },
        ),
      ],
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
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: context.glassBorderColor),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil İkonunu Seç',
                style: TextStyle(
                  color: context.textPrimaryColor,
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
                          backgroundColor: context.surfaceVariantColor,
                          child: Icon(opt.$2, color: AppColors.burgundyLight, size: 28),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          opt.$3,
                          style: TextStyle(color: context.textSecondaryColor, fontSize: 11),
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
