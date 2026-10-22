import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/avatar_constants.dart';
import '../../../core/localization/language_controller.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme_model.dart';
import '../../models/meeting_room_model.dart';
import '../../models/user_model.dart';
import '../../widgets/responsive_wrapper.dart';
import 'conference_room_view.dart';

/// Sekme 1: Konferans Lobi ve Canlı Açık Toplantılar Ekranı
class ConferenceLobbyView extends StatefulWidget {
  const ConferenceLobbyView({super.key});

  @override
  State<ConferenceLobbyView> createState() => _ConferenceLobbyViewState();
}

class _ConferenceLobbyViewState extends State<ConferenceLobbyView> {
  final TextEditingController _channelController = TextEditingController(text: 'deneme');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedTab = 0; // 0: Açık Odalar, 1: Özel Kanal / Kod
  bool _startWithMicMuted = false;
  bool _startWithCameraOff = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _channelController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _joinConference([String? targetChannel]) async {
    final channel = (targetChannel ?? _channelController.text).trim();
    if (channel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppState.language.text('room_name_empty'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = AppState.auth.currentUser.value;
    if (user != null) {
      final success = await AppState.conference.joinChannel(
        channelName: channel,
        username: user.username,
        displayName: user.displayName,
        avatarId: user.avatarId,
      );

      if (!success) {
        setState(() => _isLoading = false);
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

      if (_startWithMicMuted && !AppState.conference.isMicMuted.value) {
        await AppState.conference.toggleMic();
      }
      if (_startWithCameraOff && !AppState.conference.isCameraOff.value) {
        await AppState.conference.toggleCamera();
      }
    }

    setState(() => _isLoading = false);

    if (mounted) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => ConferenceRoomView(channelName: channel),
        ),
      );
    }
  }

  void _generateRandomCode() {
    final code = AppState.rooms.generateRandomRoomCode();
    _channelController.text = code;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppState.theme.theme.card,
        content: Text(
          'Yeni oda kodu üretildi: #$code',
          style: TextStyle(color: AppState.theme.theme.textPrimary),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeModel>(
      valueListenable: AppState.theme.currentTheme,
      builder: (context, theme, _) {
        return ValueListenableBuilder<String>(
          valueListenable: AppState.language.currentLanguage,
          builder: (context, langCode, _) {
            final lang = AppState.language;

            return ResponsiveScrollBody(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderCard(theme, lang),
                      const SizedBox(height: 14),
                      _buildAvatarPreviewCard(theme, lang),
                      const SizedBox(height: 14),
                      _buildRecentRoomsSection(theme, lang),
                      const SizedBox(height: 14),
                      _buildTabSwitcher(theme, lang),
                      const SizedBox(height: 14),
                      if (_selectedTab == 0)
                        _buildActiveRoomsList(theme, lang)
                      else
                        _buildCustomJoinSection(theme, lang),
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

  Widget _buildHeaderCard(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.hub_rounded, color: theme.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoFitText(
                    lang.text('create_or_join_title'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lang.text('active_rooms_desc'),
                    style: TextStyle(color: theme.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPreviewCard(AppThemeModel theme, LanguageController lang) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: AppState.auth.currentUser,
      builder: (context, user, _) {
        final avatar = AvatarConstants.getById(user?.avatarId ?? 0);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: avatar.gradientColors),
                    boxShadow: [
                      BoxShadow(
                        color: avatar.primaryColor.withValues(alpha: 0.35),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(avatar.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.text('active_avatar_preview'),
                        style: TextStyle(color: theme.textSecondary, fontSize: 11),
                      ),
                      const SizedBox(height: 2),
                      AutoFitText(
                        '${avatar.getTitle(AppState.language.isTurkish)} - ${user?.displayName ?? ""}',
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '@${user?.username ?? ""}',
                    style: TextStyle(
                      color: theme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentRoomsSection(AppThemeModel theme, LanguageController lang) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: AppState.rooms.recentRooms,
      builder: (context, recents, _) {
        if (recents.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Row(
                children: [
                  Icon(Icons.history_rounded, size: 16, color: theme.secondary),
                  const SizedBox(width: 6),
                  Text(
                    lang.text('recent_rooms_title'),
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recents.map((String channel) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      avatar: Icon(Icons.meeting_room_outlined, size: 16, color: theme.primary),
                      label: Text(
                        '#$channel',
                        style: TextStyle(color: theme.textPrimary, fontWeight: FontWeight.w500),
                      ),
                      backgroundColor: theme.card,
                      side: BorderSide(color: theme.primary.withValues(alpha: 0.3)),
                      onPressed: () {
                        _channelController.text = channel;
                        _joinConference(channel);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabSwitcher(AppThemeModel theme, LanguageController lang) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: lang.text('active_rooms_tab'),
              icon: Icons.wifi_tethering_rounded,
              isSelected: _selectedTab == 0,
              theme: theme,
              onTap: () => setState(() => _selectedTab = 0),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _TabButton(
              title: lang.text('custom_room_tab'),
              icon: Icons.add_circle_outline_rounded,
              isSelected: _selectedTab == 1,
              theme: theme,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveRoomsList(AppThemeModel theme, LanguageController lang) {
    return ValueListenableBuilder<List<MeetingRoomModel>>(
      valueListenable: AppState.rooms.activeRooms,
      builder: (context, rooms, _) {
        final query = _searchQuery.toLowerCase().trim();
        final filtered = rooms.where((MeetingRoomModel r) {
          if (query.isEmpty) return true;
          return r.title.toLowerCase().contains(query) ||
              r.channelName.toLowerCase().contains(query) ||
              r.hostDisplayName.toLowerCase().contains(query) ||
              r.category.toLowerCase().contains(query);
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Arama Kutusu
            TextField(
              controller: _searchController,
              style: TextStyle(color: theme.textPrimary, fontSize: 14),
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: lang.text('search_rooms'),
                prefixIcon: Icon(Icons.search_rounded, color: theme.secondary, size: 22),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),

            if (filtered.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 40, color: theme.textSecondary),
                      const SizedBox(height: 10),
                      Text(
                        lang.text('no_rooms_found'),
                        style: TextStyle(color: theme.textSecondary, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filtered.map((MeetingRoomModel room) => _buildRoomCard(room, theme, lang)),
          ],
        );
      },
    );
  }

  Widget _buildRoomCard(MeetingRoomModel room, AppThemeModel theme, LanguageController lang) {
    final hostAvatar = AvatarConstants.getById(room.hostAvatarId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: room.channelName == 'deneme'
              ? theme.primary.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Rozetler ve Kanal Etiketi
            Row(
              children: [
                // Kategori
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    room.category,
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Kanal Adı & Kopyalama
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: room.channelName));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: theme.card,
                        content: Text(
                          lang.text('room_id_copied'),
                          style: TextStyle(color: theme.textPrimary),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.card,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '#${room.channelName}',
                          style: TextStyle(
                            color: theme.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.copy_rounded, size: 12, color: theme.secondary),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Canlı Rozeti
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.fail.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: theme.fail,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        lang.text('live_status'),
                        style: TextStyle(
                          color: theme.fail,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Toplantı Başlığı
            Text(
              room.title,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              room.description,
              style: TextStyle(color: theme.textSecondary, fontSize: 13),
            ),

            const SizedBox(height: 14),

            // Alt Kısım: Host, Katılımcı Sayısı ve Katıl Butonu
            Row(
              children: [
                // Host Avatarı
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: hostAvatar.gradientColors),
                  ),
                  child: Icon(hostAvatar.icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.hostDisplayName,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(Icons.people_alt_rounded, size: 13, color: theme.success),
                          const SizedBox(width: 4),
                          Text(
                            '${room.participantCount} ${lang.text('participants_count')}',
                            style: TextStyle(
                              color: theme.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Katıl Butonu
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _joinConference(room.channelName),
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: Text(lang.text('join_now')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomJoinSection(AppThemeModel theme, LanguageController lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildChannelInputCard(theme, lang),
        const SizedBox(height: 14),
        _buildPreJoinControlsCard(theme, lang),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : () => _joinConference(),
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.videocam_rounded),
          label: Text(lang.text('start_conference')),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelInputCard(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.text('enter_channel_name'),
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                TextButton.icon(
                  onPressed: _generateRandomCode,
                  icon: Icon(Icons.casino_outlined, size: 16, color: theme.secondary),
                  label: Text(
                    lang.text('random_code'),
                    style: TextStyle(color: theme.secondary, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _channelController,
              style: TextStyle(color: theme.textPrimary),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.tag_rounded, color: theme.primary),
                hintText: 'örn: pazarlama_toplanti',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreJoinControlsCard(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(
                _startWithMicMuted ? lang.text('mic_muted') : lang.text('mic_ready'),
                style: TextStyle(color: theme.textPrimary, fontSize: 14),
              ),
              secondary: Icon(
                _startWithMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                color: _startWithMicMuted ? theme.fail : theme.success,
              ),
              value: !_startWithMicMuted,
              activeThumbColor: theme.success,
              onChanged: (val) {
                setState(() => _startWithMicMuted = !val);
              },
            ),
            const Divider(height: 1, color: Colors.white12),
            SwitchListTile(
              title: Text(
                _startWithCameraOff ? lang.text('cam_off') : lang.text('cam_ready'),
                style: TextStyle(color: theme.textPrimary, fontSize: 14),
              ),
              secondary: Icon(
                _startWithCameraOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                color: _startWithCameraOff ? theme.fail : theme.primary,
              ),
              value: !_startWithCameraOff,
              activeThumbColor: theme.primary,
              onChanged: (val) {
                setState(() => _startWithCameraOff = !val);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final AppThemeModel theme;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? theme.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : theme.textSecondary,
              ),
              const SizedBox(width: 8),
              AutoFitText(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : theme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
