import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme_model.dart';
import '../../widgets/call_control_bar.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/room_chat_panel.dart';
import '../../widgets/video_grid_tile.dart';

/// Konferans Odası Ekranı (Tam ekran, dinamik GridView, kontrol barı ve sohbet paneli)
class ConferenceRoomView extends StatefulWidget {
  final String channelName;

  const ConferenceRoomView({super.key, required this.channelName});

  @override
  State<ConferenceRoomView> createState() => _ConferenceRoomViewState();
}

class _ConferenceRoomViewState extends State<ConferenceRoomView> {
  bool _isChatOpen = false;
  bool _warnedLandscape = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOrientationAndWarn();
    });
  }

  void _checkOrientationAndWarn() {
    if (!mounted || _warnedLandscape) return;

    // Masaüstü platformlarda (macOS, Windows, Linux) ekran döndürme uyarısı gösterme
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return;
    }

    final orientation = MediaQuery.orientationOf(context);
    if (orientation == Orientation.portrait) {
      _warnedLandscape = true;
      final theme = AppState.theme.theme;
      final lang = AppState.language;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: theme.card,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          content: Row(
            children: [
              Icon(Icons.screen_rotation_rounded, color: theme.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lang.text('landscape_warning'),
                  style: TextStyle(color: theme.textPrimary, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _handleLeaveCall() async {
    final theme = AppState.theme.theme;
    final lang = AppState.language;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surface,
          title: Text(lang.text('leave_call'), style: TextStyle(color: theme.textPrimary)),
          content: Text(lang.text('confirm_leave'), style: TextStyle(color: theme.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop<bool>(context, false),
              child: Text(lang.text('cancel'), style: TextStyle(color: theme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop<bool>(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: theme.fail),
              child: Text(lang.text('yes_leave')),
            ),
          ],
        );
      },
    );

    if (shouldLeave == true) {
      await AppState.conference.leaveChannel();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppState.theme.theme;
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleLeaveCall();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Ana Video Alanı ve Grid
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildTopBar(theme),
                              Expanded(child: _buildVideoGrid(isLandscape)),
                              const SizedBox(height: 80), // Kontrol barı için boşluk
                            ],
                          ),
                        ),
                        // Yatay ekranda yan tarafta chat paneli
                        if (isLandscape && _isChatOpen)
                          SizedBox(
                            width: 320,
                            child: RoomChatPanel(
                              onClose: () => setState(() => _isChatOpen = false),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Dikey ekranda alt/sağ overlay chat paneli
                  if (!isLandscape && _isChatOpen)
                    Positioned(
                      top: 60,
                      bottom: 80,
                      left: 12,
                      right: 12,
                      child: RoomChatPanel(
                        onClose: () => setState(() => _isChatOpen = false),
                      ),
                    ),

                  // Alt Kontrol Barı
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Center(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: AppState.conference.isMicMuted,
                        builder: (context, isMicMuted, _) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: AppState.conference.isCameraOff,
                            builder: (context, isCameraOff, _) {
                              return CallControlBar(
                                isMicMuted: isMicMuted,
                                isCameraOff: isCameraOff,
                                isChatOpen: _isChatOpen,
                                onToggleMic: () => AppState.conference.toggleMic(),
                                onToggleCamera: () => AppState.conference.toggleCamera(),
                                onSwitchCamera: () => AppState.conference.switchCamera(),
                                onToggleChat: () => setState(() => _isChatOpen = !_isChatOpen),
                                onLeaveCall: _handleLeaveCall,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(AppThemeModel theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black54,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.videocam_rounded, color: theme.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoFitText(
                  widget.channelName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                ValueListenableBuilder<List<int>>(
                  valueListenable: AppState.conference.remoteUids,
                  builder: (context, uids, _) {
                    final total = uids.length + 1;
                    return Text(
                      '$total ${AppState.language.text('connected_users')}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: AppState.language.text('copy_room_id'),
            icon: const Icon(Icons.copy_rounded, color: Colors.white70, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.channelName));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: theme.card,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    AppState.language.text('room_id_copied'),
                    style: TextStyle(color: theme.textPrimary),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen_rounded, color: Colors.white70),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppState.language.text('landscape_warning')),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGrid(bool isLandscape) {
    return ValueListenableBuilder<List<int>>(
      valueListenable: AppState.conference.remoteUids,
      builder: (context, remoteUids, _) {
        final totalParticipants = remoteUids.length + 1;
        final currentUser = AppState.auth.currentUser.value;

        // Dinamik crossAxisCount hesaplama
        int crossAxisCount;
        if (isLandscape) {
          crossAxisCount = totalParticipants <= 2 ? 2 : 3;
        } else {
          crossAxisCount = totalParticipants <= 1 ? 1 : 2;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: totalParticipants,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: isLandscape ? 1.4 : 1.0,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Yerel Kullanıcı
                return ValueListenableBuilder<bool>(
                  valueListenable: AppState.conference.isCameraOff,
                  builder: (context, isCameraOff, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: AppState.conference.isMicMuted,
                      builder: (context, isMicMuted, _) {
                        return VideoGridTile(
                          uid: 0,
                          username: currentUser?.username ?? 'ben',
                          displayName: currentUser?.displayName ?? 'Ben',
                          avatarId: currentUser?.avatarId ?? 0,
                          isLocal: true,
                          isCameraOff: isCameraOff,
                          isMuted: isMicMuted,
                        );
                      },
                    );
                  },
                );
              } else {
                // Uzak Katılımcı
                final remoteUid = remoteUids[index - 1];
                final friend = AppState.friends.friends.value.firstWhere(
                  (f) => f.username == 'veli' || f.username == 'ayse',
                  orElse: () => AppState.friends.friends.value.first,
                );

                return VideoGridTile(
                  uid: remoteUid,
                  username: friend.username,
                  displayName: friend.displayName,
                  avatarId: friend.avatarId,
                  isLocal: false,
                  isCameraOff: false,
                  isMuted: false,
                );
              }
            },
          ),
        );
      },
    );
  }
}
