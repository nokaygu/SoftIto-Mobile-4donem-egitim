import 'package:flutter/material.dart';
import '../../../core/constants/avatar_constants.dart';
import '../../../core/security/auth_validator.dart';
import '../../../core/state/app_state.dart';
import '../../widgets/user_avatar_badge.dart';
import 'leaderboard_dashboard_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled =
        AppState.instance.authController.currentUser?.notificationsEnabled ?? true;
  }

  void _handleLogout() async {
    final cs = Theme.of(context).colorScheme;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Çıkış Yap',
          style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
        content: Text(
          'Oturumunuz kapatılacaktır. Devam etmek istiyor musunuz?',
          style: TextStyle(color: cs.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('İptal', style: TextStyle(color: cs.onSurface)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cs.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Çıkış'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await AppState.instance.authController.logout();
    }
  }

  void _openChangePasswordDialog() {
    final cs = Theme.of(context).colorScheme;
    final controller = TextEditingController();
    final confirmController = TextEditingController();
    bool obscure = true;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            'Şifre Değiştir',
            style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                obscureText: obscure,
                style: TextStyle(color: cs.onSurface),
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre (En az 4 karakter)',
                  prefixIcon: Icon(Icons.key_rounded, color: cs.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      color: cs.primary,
                    ),
                    onPressed: () => setDialogState(() => obscure = !obscure),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmController,
                obscureText: obscure,
                style: TextStyle(color: cs.onSurface),
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre Tekrar',
                  prefixIcon: Icon(Icons.lock_reset_rounded, color: cs.primary),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('İptal', style: TextStyle(color: cs.onSurface)),
            ),
            ElevatedButton(
              onPressed: () async {
                final newPass = controller.text;
                final confirmPass = confirmController.text;

                final passError = AuthValidator.validatePassword(newPass);
                if (passError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(passError),
                      backgroundColor: cs.error,
                    ),
                  );
                  return;
                }

                if (newPass != confirmPass) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Girdiğiniz yeni şifreler eşleşmiyor!'),
                      backgroundColor: cs.error,
                    ),
                  );
                  return;
                }

                final navigator = Navigator.of(ctx);
                final messenger = ScaffoldMessenger.of(context);
                final auth = AppState.instance.authController;

                final success = await auth.updatePassword(newPass);

                if (mounted) {
                  navigator.pop();
                  if (success) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: const Text('Şifreniz başarıyla güncellendi.'),
                        backgroundColor: cs.primary,
                      ),
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: const Text('Şifre güncellenirken bir hata oluştu.'),
                        backgroundColor: cs.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authController = AppState.instance.authController;
    final taskController = AppState.instance.taskController;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kaptan Profili',
          style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: authController,
          builder: (context, _) {
            final user = authController.currentUser;
            final avatarIndex = user?.avatarIndex ?? 0;
            final currentAvatar = AvatarConstants.getByIndex(avatarIndex);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Top Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        UserAvatarBadge(
                          avatarIndex: avatarIndex,
                          radius: 40,
                          isSelected: true,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.username ?? 'Kaptan',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            authController.sailorRank,
                            style: TextStyle(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentAvatar.roleDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5 Denizci Avatarı Seçimi
                  Text(
                    'Denizci Avatarını Seç (5 Seçenek)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: AvatarConstants.avatars.map((av) {
                      final isSelected = av.index == avatarIndex;
                      return Expanded(
                        child: Column(
                          children: [
                            UserAvatarBadge(
                              avatarIndex: av.index,
                              radius: 26,
                              isSelected: isSelected,
                              onTap: () {
                                authController.updateAvatar(av.index);
                              },
                            ),
                            const SizedBox(height: 6),
                            Text(
                              av.title.split(' ').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                color: isSelected ? cs.primary : cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Dashboard / Liderlik Tablosu Entry Card
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardDashboardView(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: cs.outlineVariant,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cs.onPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.leaderboard_rounded,
                              color: cs.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dashboard / Liderlik Tablosu',
                                  style: TextStyle(
                                    color: cs.onPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Toplam ⚡ ${taskController.getTotalStreakPoints()} Puan • Sıralamanı Gör',
                                  style: TextStyle(
                                    color: cs.onPrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: cs.onPrimary,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Additional preferences & settings
                  Material(
                    color: cs.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: cs.outlineVariant),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        SwitchListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          secondary: Icon(Icons.notifications_active_rounded, color: cs.primary),
                          title: Text(
                            'Hatırlatıcı Bildirimler',
                            style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'Günlük rotanı kaçırmamak için bildirim al.',
                            style: TextStyle(color: cs.onSurface, fontSize: 12),
                          ),
                          value: _notificationsEnabled,
                          onChanged: (val) {
                            setState(() {
                              _notificationsEnabled = val;
                            });
                            AppState.instance.authController.updateNotificationsEnabled(val);
                          },
                        ),
                        Divider(height: 1, color: cs.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.password_rounded, color: cs.primary),
                          title: Text(
                            'Şifre Değiştir',
                            style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: cs.onSurface),
                          onTap: _openChangePasswordDialog,
                        ),
                        Divider(height: 1, color: cs.outlineVariant),
                        ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                          ),
                          leading: Icon(Icons.logout_rounded, color: cs.error),
                          title: Text(
                            'Çıkış Yap',
                            style: TextStyle(color: cs.error, fontWeight: FontWeight.w800),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: cs.error),
                          onTap: _handleLogout,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
