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
  final _formKey = GlobalKey<FormState>();
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
      backgroundColor: context.scaffoldColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildThemeToggleRow(),
                const SizedBox(height: 12),
                _buildLogoHeader(),
                const SizedBox(height: 24),
                _buildLoginFormCard(),
                const SizedBox(height: 20),
                _buildQuickLoginCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggleRow() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(
          context.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          color: context.textSecondaryColor,
        ),
        tooltip: context.isDark ? 'Aydınlık Mod' : 'Karanlık Mod',
        onPressed: () => AppState.theme.toggleTheme(),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.burgundyPrimary.withValues(alpha: context.isDark ? 0.45 : 0.25),
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
              width: 84,
              height: 84,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'V İ T E S',
          style: TextStyle(
            color: context.textPrimaryColor,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Merkeziyetsiz Sosyal Araç Kiralama Platformu',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.textSecondaryColor,
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Giriş Yap',
              style: TextStyle(
                color: context.textPrimaryColor,
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
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Kullanıcı adı boş bırakılamaz';
                }
                if (v.trim().length < 3) {
                  return 'Kullanıcı adı en az 3 karakter olmalıdır';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            LiquidTextField(
              controller: _sifreCtrl,
              label: 'Şifre',
              hintText: '123',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Şifre boş bırakılamaz';
                }
                if (v.trim().length < 3) {
                  return 'Şifre en az 3 karakter olmalıdır';
                }
                return null;
              },
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hızlı Rol Seçimi (Tek Tıkla Giriş)',
                  style: TextStyle(
                    color: context.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildQuickButton(
            title: 'Kiraya Veren',
            subtitle: 'Giriş: veren / 123 (Araç Sahibi)',
            badgeText: 'İlan & Kiracı',
            icon: Icons.vpn_key_rounded,
            badgeType: LiquidBadgeType.burgundy,
            onTap: () => _handleQuickLogin(KullaniciRolu.veren),
          ),
          const SizedBox(height: 10),
          _buildQuickButton(
            title: 'Kiralayan',
            subtitle: 'Giriş: alan / 123 (Müşteri)',
            badgeText: 'Araç Kirala',
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
        color: context.surfaceVariantColor.withValues(alpha: context.isDark ? 0.45 : 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.glassBorderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.burgundyPrimary.withValues(alpha: context.isDark ? 0.22 : 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.burgundyAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: context.isDark ? AppColors.textWhite : AppColors.burgundyPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: context.textPrimaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          LiquidBadge(text: badgeText, type: badgeType),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: context.textMutedColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleManualLogin() {
    setState(() => _hataMesaji = null);
    if (!_formKey.currentState!.validate()) return;

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
