import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/avatar_constants.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme_model.dart';
import '../../widgets/responsive_wrapper.dart';

/// Kamera ayarları ve canlı test bileşeni
class CameraSettingsCard extends StatelessWidget {
  const CameraSettingsCard({super.key});

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
                Icon(Icons.videocam_rounded, color: theme.secondary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoFitText(
                    lang.text('cam_settings'),
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
              valueListenable: AppState.settings.isCamGranted,
              builder: (context, isGranted, _) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${lang.text('cam_permission')}: ${isGranted ? lang.text('permission_granted') : lang.text('permission_denied')}',
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
                          await PermissionService.requestCamera();
                          await AppState.settings.checkPermissions();
                        },
                        child: Text(lang.text('grant_permission')),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),

            // Kamera Test Butonu
            ValueListenableBuilder<bool>(
              valueListenable: AppState.settings.isCamTesting,
              builder: (context, isTesting, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => AppState.settings.toggleCamTest(),
                      icon: Icon(isTesting ? Icons.videocam_off_rounded : Icons.videocam_rounded),
                      label: Text(isTesting ? lang.text('stop_test') : lang.text('test_cam')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isTesting ? theme.fail : theme.secondary,
                      ),
                    ),
                    if (isTesting) ...[
                      const SizedBox(height: 14),
                      Text(
                        lang.text('camera_preview'),
                        style: TextStyle(color: theme.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 180,
                          color: Colors.black,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _buildPreview(theme),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton.filledTonal(
                                  icon: const Icon(Icons.flip_camera_ios_rounded, size: 20),
                                  onPressed: () => AppState.conference.switchCamera(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 12),

            // Ayna Modu Switch
            ValueListenableBuilder<bool>(
              valueListenable: AppState.settings.isMirrorMode,
              builder: (context, isMirror, _) {
                return SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    lang.text('mirror_mode'),
                    style: TextStyle(color: theme.textPrimary, fontSize: 14),
                  ),
                  value: isMirror,
                  activeThumbColor: theme.secondary,
                  onChanged: (val) => AppState.settings.toggleMirrorMode(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(AppThemeModel theme) {
    final localController = AppState.conference.localVideoController;
    if (localController != null) {
      return AgoraVideoView(controller: localController);
    }

    final avatar = AvatarConstants.getById(AppState.auth.currentUser.value?.avatarId ?? 0);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: avatar.gradientColors),
            ),
            child: Icon(avatar.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kamera Önizleme Aktif',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
