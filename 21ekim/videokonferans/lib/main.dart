import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme_model.dart';
import 'features/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppState.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const VizyonMeetApp());
}

/// VizyonMeet Ana Uygulama Kök Widget'ı
class VizyonMeetApp extends StatelessWidget {
  const VizyonMeetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeModel>(
      valueListenable: AppState.theme.currentTheme,
      builder: (context, currentTheme, _) {
        return ValueListenableBuilder<String>(
          valueListenable: AppState.language.currentLanguage,
          builder: (context, langCode, _) {
            return MaterialApp(
              title: AppState.language.text('app_title'),
              debugShowCheckedModeBanner: false,
              theme: currentTheme.toThemeData(),
              home: const LoginView(),
            );
          },
        );
      },
    );
  }
}
