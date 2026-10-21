import 'package:flutter/material.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/state/app_state.dart';
import '../../widgets/responsive_wrapper.dart';

/// Mikrofon ayarları ve ses testi bileşeni
class MicrophoneSettingsCard extends StatefulWidget {
  const MicrophoneSettingsCard({super.key});

  @override
  State<MicrophoneSettingsCard> createState() => _MicrophoneSettingsCardState();
}

class _MicrophoneSettingsCardState extends State<MicrophoneSettingsCard> {
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
                Icon(Icons.mic_rounded, color: theme.primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoFitText(
                    lang.text('mic_settings'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // İzin Durumu
            ValueListenableBuilder<bool>(
              valueListenable: AppState.settings.isMicGranted,
              builder: (context, isGranted, _) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${lang.text('mic_permission')}: ${isGranted ? lang.text('permission_granted') : lang.text('permission_denied')}',
                        style: TextStyle(
                          color: isGranted ? theme.success : theme.fail,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (!isGranted)
                      TextButton(
                        onPressed: () async {
                          await PermissionService.requestMicrophone();
                          await AppState.settings.checkPermissions();
                        },
                        child: Text(lang.text('grant_permission')),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),

            // Mikrofon Test Butonu ve Canlı Ses Seviyesi Barı
            ValueListenableBuilder<bool>(
              valueListenable: AppState.settings.isMicTesting,
              builder: (context, isTesting, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (isTesting) {
                          AppState.settings.stopMicTest();
                        } else {
                          AppState.settings.startMicTest();
                        }
                      },
                      icon: Icon(isTesting ? Icons.stop_rounded : Icons.graphic_eq_rounded),
                      label: Text(isTesting ? lang.text('stop_test') : lang.text('test_mic')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isTesting ? theme.fail : theme.primary,
                      ),
                    ),
                    if (isTesting) ...[
                      const SizedBox(height: 14),
                      Text(
                        lang.text('mic_level'),
                        style: TextStyle(color: theme.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      ValueListenableBuilder<double>(
                        valueListenable: AppState.settings.liveAudioLevel,
                        builder: (context, level, _) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: level,
                              minHeight: 12,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                level > 0.75 ? theme.fail : theme.success,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Agora Mikrofon Kayıt Ses Düzeyi (0 - 200)
            Text(
              lang.text('mic_volume_adjust'),
              style: TextStyle(color: theme.textSecondary, fontSize: 12),
            ),
            ValueListenableBuilder<double>(
              valueListenable: AppState.conference.micVolume,
              builder: (context, volume, _) {
                return Row(
                  children: [
                    Icon(Icons.volume_down_rounded, color: theme.textSecondary, size: 18),
                    Expanded(
                      child: Slider(
                        value: volume,
                        min: 0,
                        max: 200,
                        divisions: 20,
                        activeColor: theme.primary,
                        label: '${volume.toInt()}%',
                        onChanged: (val) {
                          AppState.conference.setMicVolume(val);
                        },
                      ),
                    ),
                    Text(
                      '${volume.toInt()}%',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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
