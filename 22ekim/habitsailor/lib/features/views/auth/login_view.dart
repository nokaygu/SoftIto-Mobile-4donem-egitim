import 'package:flutter/material.dart';
import '../../../core/security/auth_validator.dart';
import '../../../core/state/app_state.dart';
import '../../widgets/habit_sailor_brand_header.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final userErr = AuthValidator.validateUsername(username);
    if (userErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userErr),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen şifrenizi girin.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoggingIn = true);

    final auth = AppState.instance.authController;
    final success = await auth.login(username, password);

    if (mounted) {
      setState(() => _isLoggingIn = false);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Giriş başarısız!'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      // Note: If success, MaterialApp.home in main.dart listens to authController
      // and reactively presents MainShellView. No redundant imperative route push needed!
    }
  }

  void _openRegisterBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const _RegisterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HabitSailorBrandHeader(),
                  const SizedBox(height: 36),

                  Text(
                    'Kaptan Girişi',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Zincirini kırma, alışkanlık rotana devam et.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 28),

                  // Username field
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Kullanıcı Adı (Kaptan)',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: cs.primary),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleLogin(),
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: cs.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: cs.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Login button
                  ElevatedButton.icon(
                    onPressed: _isLoggingIn ? null : _handleLogin,
                    icon: _isLoggingIn
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.onPrimary,
                            ),
                          )
                        : Icon(Icons.login_rounded, color: cs.onPrimary),
                    label: Text(_isLoggingIn ? 'Giriş Yapılıyor...' : 'Giriş Yap'),
                  ),
                  const SizedBox(height: 16),

                  // Register prompt button
                  OutlinedButton.icon(
                    onPressed: _isLoggingIn ? null : _openRegisterBottomSheet,
                    icon: Icon(Icons.person_add_alt_1_rounded, color: cs.primary),
                    label: const Text('Yeni Kaptan Kaydı Oluştur'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterBottomSheet extends StatefulWidget {
  const _RegisterBottomSheet();

  @override
  State<_RegisterBottomSheet> createState() => _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends State<_RegisterBottomSheet> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscure = true;
  bool _isRegistering = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Strict validation
    final userError = AuthValidator.validateUsername(username);
    if (userError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userError),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final passError = AuthValidator.validatePassword(password);
    if (passError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passError),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Girdiğiniz şifreler eşleşmiyor! Lütfen kontrol edin.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isRegistering = true);

    final auth = AppState.instance.authController;
    final success = await auth.register(username, password);

    if (mounted) {
      setState(() => _isRegistering = false);
      if (success) {
        Navigator.of(context).pop(); // Cleanly close bottomsheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hoş geldin, Kaptan $username! Rotan hazır.'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Kayıt başarısız!'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yeni Kaptan Kaydı',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: cs.onSurface),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Kaptan adın benzersiz olmalıdır. Şifren güvenli tuzlu hash ile saklanır.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface,
                    ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _usernameController,
                style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı (Kaptan)',
                  hintText: 'Örn: KaptanMurat',
                  prefixIcon: Icon(Icons.person_add_rounded, color: cs.primary),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Şifre (En az 4 karakter)',
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: cs.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      color: cs.primary,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscure,
                style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleRegister(),
                decoration: InputDecoration(
                  labelText: 'Şifre Tekrar',
                  prefixIcon: Icon(Icons.lock_reset_rounded, color: cs.primary),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _isRegistering ? null : _handleRegister,
                icon: _isRegistering
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : Icon(Icons.sailing_rounded, color: cs.onPrimary),
                label: Text(_isRegistering ? 'Kaydediliyor...' : 'Kayıt Ol ve Giriş Yap'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
