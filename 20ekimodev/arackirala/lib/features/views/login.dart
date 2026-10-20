import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/state/app_state.dart';
import '../models/user_model.dart';
import '../widgets/liquid_badge.dart';
import '../widgets/liquid_button.dart';
import '../widgets/liquid_glass_card.dart';
import '../widgets/liquid_text_field.dart';

/// Giriş Ekranı (Mock Auth: veren/123 & alan/123)
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _kullaniciAdiCtrl = TextEditingController();
  final _sifreCtrl = TextEditingController();
  String? _hataMesaji;

  @override
  void dispose() {
    _kullaniciAdiCtrl.dispose();
    _sifreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogoHeader(),
                const SizedBox(height: 28),
                _buildLoginFormCard(),
                const SizedBox(height: 24),
                _buildQuickLoginCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.burgundyPrimary.withValues(alpha: 0.45),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(color: AppColors.burgundyAccent.withValues(alpha: 0.6), width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 88,
              height: 88,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'V İ T E S',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Merkeziyetsiz Sosyal Araç Kiralama Platformu',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginFormCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Giriş Yap',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          LiquidTextField(
            controller: _kullaniciAdiCtrl,
            label: 'Kullanıcı Adı',
            hintText: 'veren veya alan',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 14),
          LiquidTextField(
            controller: _sifreCtrl,
            label: 'Şifre',
            hintText: '123',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          if (_hataMesaji != null) ...[
            const SizedBox(height: 12),
            _buildErrorMessage(),
          ],
          const SizedBox(height: 20),
          LiquidButton(
            text: 'Giriş Yap',
            icon: Icons.login_rounded,
            onPressed: _handleManualLogin,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _hataMesaji!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLoginCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt_rounded, color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Text(
                'Hızlı Rol Seçimi (Tek Tıkla Giriş)',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildQuickButton(
            title: 'Hızlı Giriş: Kiraya Veren',
            subtitle: 'veren / 123 (Araç Sahibi)',
            badgeText: 'İlan & Kiracı Yönetimi',
            icon: Icons.vpn_key_rounded,
            badgeType: LiquidBadgeType.burgundy,
            onTap: () => _handleQuickLogin(KullaniciRolu.veren),
          ),
          const SizedBox(height: 10),
          _buildQuickButton(
            title: 'Hızlı Giriş: Kiralayan',
            subtitle: 'alan / 123 (Kiracı)',
            badgeText: 'Araç Kirala & Keşfet',
            icon: Icons.directions_car_rounded,
            badgeType: LiquidBadgeType.success,
            onTap: () => _handleQuickLogin(KullaniciRolu.alan),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton({
    required String title,
    required String subtitle,
    required String badgeText,
    required IconData icon,
    required LiquidBadgeType badgeType,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          dense: true,
          leading: CircleAvatar(
            backgroundColor: AppColors.burgundyPrimary.withValues(alpha: 0.2),
            child: Icon(icon, color: AppColors.textWhite, size: 18),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          trailing: LiquidBadge(text: badgeText, type: badgeType),
        ),
      ),
    );
  }

  void _handleManualLogin() {
    final success = AppState.userProfile.login(
      _kullaniciAdiCtrl.text,
      _sifreCtrl.text,
    );

    if (success) {
      widget.onLoginSuccess();
    } else {
      setState(() {
        _hataMesaji = 'Hatalı kullanıcı adı veya şifre! (veren/123 veya alan/123)';
      });
    }
  }

  void _handleQuickLogin(KullaniciRolu rol) {
    AppState.userProfile.quickLogin(rol);
    widget.onLoginSuccess();
  }
}
