import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import '../../core/constants/avatar_constants.dart';
import '../../core/state/app_state.dart';

/// Video konferanstaki tek bir katılımcının video/avatar kutusu
class VideoGridTile extends StatefulWidget {
  final int uid;
  final String username;
  final String displayName;
  final int avatarId;
  final bool isLocal;
  final bool isCameraOff;
  final bool isMuted;

  const VideoGridTile({
    super.key,
    required this.uid,
    required this.username,
    required this.displayName,
    required this.avatarId,
    required this.isLocal,
    required this.isCameraOff,
    required this.isMuted,
  });

  @override
  State<VideoGridTile> createState() => _VideoGridTileState();
}

class _VideoGridTileState extends State<VideoGridTile> {
  VideoViewController? _remoteController;

  @override
  void initState() {
    super.initState();
    _initRemoteController();
  }

  @override
  void didUpdateWidget(VideoGridTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid && !widget.isLocal) {
      _remoteController?.dispose();
      _initRemoteController();
    }
  }

  void _initRemoteController() {
    if (!widget.isLocal && AppState.conference.engine != null) {
      try {
        _remoteController = VideoViewController.remote(
          rtcEngine: AppState.conference.engine!,
          canvas: VideoCanvas(
            uid: widget.uid,
            renderMode: RenderModeType.renderModeHidden,
          ),
          connection: RtcConnection(channelId: AppState.conference.currentChannel.value),
        );
      } catch (e) {
        debugPrint('Remote VideoViewController error: $e');
      }
    }
  }

  @override
  void dispose() {
    _remoteController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppState.theme.theme;
    final avatar = AvatarConstants.getById(widget.avatarId);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.card,
          border: Border.all(
            color: widget.isLocal ? theme.primary.withValues(alpha: 0.6) : Colors.white12,
            width: widget.isLocal ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video veya Avatar Görünümü
            if (!widget.isCameraOff)
              _buildVideoView(avatar)
            else
              _buildAvatarPlaceholder(avatar),

            // Üst Sol Canlı/Kamera Rozeti
            if (!widget.isCameraOff)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.success.withValues(alpha: 0.8), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'CANLI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Üst Sağ Mikrofon Durum Rozeti
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: widget.isMuted ? theme.fail.withValues(alpha: 0.85) : Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),

            // Alt İsim ve Avatar Rozeti
            Positioned(
              left: 8,
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: avatar.gradientColors),
                      ),
                      child: Icon(avatar.icon, size: 11, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.isLocal
                            ? '${widget.displayName} (${AppState.language.text('you')})'
                            : widget.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoView(AvatarInfo avatar) {
    if (widget.isLocal) {
      final controller = AppState.conference.localVideoController;
      if (controller != null) {
        return AgoraVideoView(controller: controller);
      }
    } else if (_remoteController != null) {
      return AgoraVideoView(controller: _remoteController!);
    }

    // Kamera açık fakat simülatör / render akışı henüz gelmemişse şık önizleme
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              child: const Icon(Icons.videocam_rounded, size: 36, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamera Aktif',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(AvatarInfo avatar) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            avatar.gradientColors.first.withValues(alpha: 0.35),
            Colors.black.withValues(alpha: 0.85),
          ],
          radius: 0.9,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: avatar.gradientColors),
                boxShadow: [
                  BoxShadow(
                    color: avatar.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(avatar.icon, size: 34, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              AppState.language.text('camera_is_off'),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
