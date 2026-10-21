import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../widgets/responsive_wrapper.dart';

/// Dil seçimi ayar kartı (TR / EN)
class LanguageSettingsCard extends StatelessWidget {
  const LanguageSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppState.theme.theme;
    final lang = AppState.language;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.translate_rounded, color: theme.primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoFitText(
                    lang.text('language_settings'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              lang.text('language_desc'),
              style: TextStyle(color: theme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 14),

            // TR ve EN Seçim Butonları
            ValueListenableBuilder<String>(
              valueListenable: AppState.language.currentLanguage,
              builder: (context, currentLang, _) {
                final isTr = currentLang == 'tr';
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => AppState.language.setLanguage('tr'),
                        icon: const Text('🇹🇷', style: TextStyle(fontSize: 18)),
                        label: Text(lang.text('turkish')),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isTr ? theme.primary.withValues(alpha: 0.15) : null,
                          foregroundColor: isTr ? theme.primary : theme.textSecondary,
                          side: BorderSide(
                            color: isTr ? theme.primary : Colors.white24,
                            width: isTr ? 2 : 1,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => AppState.language.setLanguage('en'),
                        icon: const Text('🇬🇧', style: TextStyle(fontSize: 18)),
                        label: Text(lang.text('english')),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: !isTr ? theme.primary.withValues(alpha: 0.15) : null,
                          foregroundColor: !isTr ? theme.primary : theme.textSecondary,
                          side: BorderSide(
                            color: !isTr ? theme.primary : Colors.white24,
                            width: !isTr ? 2 : 1,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
