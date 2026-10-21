import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';

/// Çağrı kontrol barı ve yuvarlak aksiyon butonları
class CallControlBar extends StatelessWidget {
  final bool isMicMuted;
  final bool isCameraOff;
  final bool isChatOpen;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCamera;
  final VoidCallback onSwitchCamera;
  final VoidCallback onToggleChat;
  final VoidCallback onLeaveCall;

  const CallControlBar({
    super.key,
    required this.isMicMuted,
    required this.isCameraOff,
    required this.isChatOpen,
    required this.onToggleMic,
    required this.onToggleCamera,
    required this.onSwitchCamera,
    required this.onToggleChat,
    required this.onLeaveCall,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppState.theme.theme;
    final lang = AppState.language;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Mikrofon Aç / Kapat
            _CallActionButton(
              icon: isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
              tooltip: isMicMuted ? lang.text('unmute_mic') : lang.text('mute_mic'),
              backgroundColor: isMicMuted ? theme.fail.withValues(alpha: 0.2) : theme.card,
              iconColor: isMicMuted ? theme.fail : theme.textPrimary,
              onTap: onToggleMic,
            ),
            const SizedBox(width: 12),

            // 2. Kamera Aç / Kapat
            _CallActionButton(
              icon: isCameraOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
              tooltip: isCameraOff ? lang.text('turn_on_cam') : lang.text('turn_off_cam'),
              backgroundColor: isCameraOff ? theme.fail.withValues(alpha: 0.2) : theme.card,
              iconColor: isCameraOff ? theme.fail : theme.textPrimary,
              onTap: onToggleCamera,
            ),
            const SizedBox(width: 12),

            // 3. Ön / Arka Kamera Değiştir
            _CallActionButton(
              icon: Icons.flip_camera_ios_rounded,
              tooltip: lang.text('switch_cam'),
              backgroundColor: theme.card,
              iconColor: theme.textPrimary,
              onTap: onSwitchCamera,
            ),
            const SizedBox(width: 12),

            // 4. Sohbet Panelini Aç / Kapat
            _CallActionButton(
              icon: Icons.chat_bubble_outline_rounded,
              tooltip: lang.text('toggle_chat'),
              backgroundColor: isChatOpen ? theme.primary : theme.card,
              iconColor: isChatOpen ? Colors.white : theme.textPrimary,
              onTap: onToggleChat,
            ),
            const SizedBox(width: 16),

            // 5. Aramadan Ayrıl
            _CallActionButton(
              icon: Icons.call_end_rounded,
              tooltip: lang.text('leave_call'),
              backgroundColor: theme.fail,
              iconColor: Colors.white,
              onTap: onLeaveCall,
              size: 52,
            ),
          ],
        ),
      ),
    );
  }
}

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final double size;

  const _CallActionButton({
    required this.icon,
    required this.tooltip,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    this.size = 46,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: iconColor, size: size * 0.48),
          ),
        ),
      ),
    );
  }
}
