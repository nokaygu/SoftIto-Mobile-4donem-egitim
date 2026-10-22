import 'package:flutter/material.dart';
import '../../../core/localization/language_controller.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme_model.dart';
import '../widgets/responsive_wrapper.dart';
import 'conference/conference_room_view.dart';
import 'main_shell_view.dart';

/// Giriş Ekranı (LoginView)
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _quickRoomController = TextEditingController(text: 'deneme');
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _quickRoomController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final success = AppState.auth.login(username, password);
    if (success) {
      _navigateToShell();
    } else {
      setState(() {
        _errorMessage = AppState.language.text('invalid_credentials');
      });
    }
  }

  void _handleQuickLogin(String username) {
    AppState.auth.quickLogin(username);
    _navigateToShell();
  }

  Future<void> _handleQuickRoomJoin() async {
    final room = _quickRoomController.text.trim();
    if (room.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppState.language.text('room_name_empty'))),
      );
      return;
    }

    // Kullanıcı henüz giriş yapmadıysa varsayılan 'ali' ile giriş yap
    if (!AppState.auth.isLoggedIn) {
      AppState.auth.quickLogin('ali');
    }

    final user = AppState.auth.currentUser.value!;
    final success = await AppState.conference.joinChannel(
      channelName: room,
      username: user.username,
      displayName: user.displayName,
      avatarId: user.avatarId,
    );

    if (!success) {
      if (mounted) {
        final err = AppState.conference.lastError.value ?? 'Odaya katılırken bir hata oluştu.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade800,
            content: Text(err),
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    if (mounted) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => ConferenceRoomView(channelName: room),
        ),
      );
    }
  }

  void _navigateToShell() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(builder: (context) => const MainShellView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppState.theme.theme;
    final lang = AppState.language;

    return Scaffold(
      body: ResponsiveScrollBody(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(theme, lang),
                const SizedBox(height: 24),
                _buildLoginForm(theme, lang),
                const SizedBox(height: 20),
                _buildQuickLoginCard(theme, lang),
                const SizedBox(height: 16),
                _buildQuickRoomCard(theme, lang),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppThemeModel theme, LanguageController lang) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: <Color>[theme.primary, theme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.video_camera_front_rounded, size: 36, color: Colors.white),
        ),
        const SizedBox(height: 16),
        AutoFitText(
          lang.text('app_title'),
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          lang.text('app_subtitle'),
          style: TextStyle(color: theme.textSecondary, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              style: TextStyle(color: theme.textPrimary),
              decoration: InputDecoration(
                labelText: lang.text('username'),
                prefixIcon: Icon(Icons.person_outline_rounded, color: theme.primary),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: theme.textPrimary),
              decoration: InputDecoration(
                labelText: lang.text('password'),
                prefixIcon: Icon(Icons.lock_outline_rounded, color: theme.primary),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: TextStyle(color: theme.fail, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text(lang.text('login_button')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLoginCard(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on_rounded, color: theme.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoFitText(
                    lang.text('quick_login_title'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _handleQuickLogin('ali'),
                  icon: const Icon(Icons.account_circle_rounded, size: 18),
                  label: Text(lang.text('quick_login_ali')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primary,
                    side: BorderSide(color: theme.primary.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _handleQuickLogin('veli'),
                  icon: const Icon(Icons.account_circle_rounded, size: 18),
                  label: Text(lang.text('quick_login_veli')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.secondary,
                    side: BorderSide(color: theme.secondary.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickRoomCard(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.meeting_room_rounded, color: theme.secondary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoFitText(
                    lang.text('quick_room_title'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quickRoomController,
                    style: TextStyle(color: theme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: lang.text('room_name_hint'),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _handleQuickRoomJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  child: Text(lang.text('join_room_button')),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.flash_on_rounded, size: 14, color: Colors.amber),
                    label: const Text('#deneme', style: TextStyle(fontSize: 12)),
                    backgroundColor: theme.card,
                    onPressed: () {
                      _quickRoomController.text = 'deneme';
                      _handleQuickRoomJoin();
                    },
                  ),
                  const SizedBox(width: 6),
                  ActionChip(
                    avatar: Icon(Icons.code_rounded, size: 14, color: theme.primary),
                    label: const Text('#yazilim_ekibi', style: TextStyle(fontSize: 12)),
                    backgroundColor: theme.card,
                    onPressed: () {
                      _quickRoomController.text = 'yazilim_ekibi';
                      _handleQuickRoomJoin();
                    },
                  ),
                  const SizedBox(width: 6),
                  ActionChip(
                    avatar: Icon(Icons.palette_rounded, size: 14, color: theme.secondary),
                    label: const Text('#tasarim_inceleme', style: TextStyle(fontSize: 12)),
                    backgroundColor: theme.card,
                    onPressed: () {
                      _quickRoomController.text = 'tasarim_inceleme';
                      _handleQuickRoomJoin();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
