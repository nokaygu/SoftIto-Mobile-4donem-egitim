import 'package:flutter/material.dart';
import '../../../core/constants/avatar_constants.dart';
import '../../../core/localization/language_controller.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme_model.dart';
import '../../../core/theme/app_themes.dart';
import '../../models/user_model.dart';
import '../../widgets/responsive_wrapper.dart';
import '../login_view.dart';

/// Sekme 4: Profilim Ekranı (5 Avatar, 4 Tema Seçimi, Çıkış Yap)
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  void _handleLogout(BuildContext context) async {
    final theme = AppState.theme.theme;
    final lang = AppState.language;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surface,
          title: Text(lang.text('logout'), style: TextStyle(color: theme.textPrimary)),
          content: Text(lang.text('logout_confirm'), style: TextStyle(color: theme.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop<bool>(context, false),
              child: Text(lang.text('cancel'), style: TextStyle(color: theme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop<bool>(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: theme.fail),
              child: Text(lang.text('logout')),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      AppState.auth.logout();
      if (context.mounted) {
        await Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (context) => const LoginView()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeModel>(
      valueListenable: AppState.theme.currentTheme,
      builder: (context, theme, _) {
        return ValueListenableBuilder<String>(
          valueListenable: AppState.language.currentLanguage,
          builder: (context, langCode, _) {
            final lang = AppState.language;

            return ResponsiveScrollBody(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildUserProfileHeader(theme),
                      const SizedBox(height: 16),
                      _buildAvatarSelectionCard(theme, lang),
                      const SizedBox(height: 16),
                      _buildThemeSelectionCard(theme, lang),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _handleLogout(context),
                        icon: const Icon(Icons.logout_rounded),
                        label: Text(lang.text('logout')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.fail,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserProfileHeader(AppThemeModel theme) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: AppState.auth.currentUser,
      builder: (context, user, _) {
        final avatar = AvatarConstants.getById(user?.avatarId ?? 0);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: avatar.gradientColors),
                    boxShadow: [
                      BoxShadow(
                        color: avatar.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(avatar.icon, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoFitText(
                        user?.displayName ?? 'Kullanıcı',
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${user?.username ?? ""}',
                        style: TextStyle(color: theme.primary, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        avatar.getTitle(AppState.language.isTurkish),
                        style: TextStyle(color: theme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarSelectionCard(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.face_rounded, color: theme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoFitText(
                    lang.text('choose_avatar'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ValueListenableBuilder<UserModel?>(
              valueListenable: AppState.auth.currentUser,
              builder: (context, user, _) {
                final selectedId = user?.avatarId ?? 0;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: AvatarConstants.avatars.map((av) {
                    final isSelected = av.id == selectedId;
                    return InkWell(
                      onTap: () => AppState.auth.updateAvatar(av.id),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.primary.withValues(alpha: 0.18) : theme.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? theme.primary : Colors.white12,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: av.gradientColors),
                              ),
                              child: Icon(av.icon, color: Colors.white, size: 22),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 72,
                              child: AutoFitText(
                                av.getTitle(AppState.language.isTurkish),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected ? theme.primary : theme.textSecondary,
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelectionCard(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette_rounded, color: theme.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoFitText(
                    lang.text('choose_theme'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ValueListenableBuilder<AppThemeModel>(
              valueListenable: AppState.theme.currentTheme,
              builder: (context, activeTheme, _) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: AppThemes.allThemes.map((th) {
                    final isSelected = th.id == activeTheme.id;
                    return InkWell(
                      onTap: () => AppState.theme.setTheme(th.id),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: th.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? th.primary : Colors.white12,
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: th.primary.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: th.primary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(th.icon, color: th.primary, size: 24),
                            ),
                            const SizedBox(height: 8),
                            AutoFitText(
                              th.getName(AppState.language.isTurkish),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: th.textPrimary,
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
