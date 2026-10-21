import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme_model.dart';
import '../../widgets/responsive_wrapper.dart';
import 'camera_settings.dart';
import 'language_settings.dart';
import 'microphone_settings.dart';

/// Sekme 3: Ayarlar Ekranı (Mikrofon, Kamera ve Dil Ayarları)
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppState.settings.checkPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeModel>(
      valueListenable: AppState.theme.currentTheme,
      builder: (context, theme, _) {
        return ValueListenableBuilder<String>(
          valueListenable: AppState.language.currentLanguage,
          builder: (context, langCode, _) {
            return ResponsiveScrollBody(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MicrophoneSettingsCard(),
                      SizedBox(height: 14),
                      CameraSettingsCard(),
                      SizedBox(height: 14),
                      LanguageSettingsCard(),
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
}
