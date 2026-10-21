import 'package:flutter/material.dart';
import '../../../core/constants/avatar_constants.dart';
import '../../../core/localization/language_controller.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme_model.dart';
import '../../models/friend_model.dart';
import '../../widgets/responsive_wrapper.dart';
import '../conference/conference_room_view.dart';

/// Sekme 2: Arkadaşlar Ekranı (Doğrudan konferans başlatma ve özel mesaj)
class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  void _startDirectCall(FriendModel friend) async {
    final theme = AppState.theme.theme;
    final lang = AppState.language;
    final user = AppState.auth.currentUser.value;
    if (user == null) return;

    final roomName = 'call_${user.username}_${friend.username}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.card,
        content: Text(
          '${friend.displayName} ${lang.text('starting_call_with')}',
          style: TextStyle(color: theme.textPrimary),
        ),
      ),
    );

    await AppState.conference.joinChannel(
      channelName: roomName,
      username: user.username,
      displayName: user.displayName,
      avatarId: user.avatarId,
    );

    if (mounted) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => ConferenceRoomView(channelName: roomName),
        ),
      );
    }
  }

  void _joinFriendMeeting(String roomName) async {
    final user = AppState.auth.currentUser.value;
    if (user == null) return;

    await AppState.conference.joinChannel(
      channelName: roomName,
      username: user.username,
      displayName: user.displayName,
      avatarId: user.avatarId,
    );

    if (mounted) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => ConferenceRoomView(channelName: roomName),
        ),
      );
    }
  }

  void _showPrivateMessageDialog(FriendModel friend) {
    final theme = AppState.theme.theme;
    final lang = AppState.language;
    final textController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surface,
          title: Row(
            children: [
              Icon(Icons.mark_chat_unread_rounded, color: theme.secondary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: AutoFitText(
                  '${friend.displayName} - ${lang.text('private_msg')}',
                  style: TextStyle(color: theme.textPrimary, fontSize: 16),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${friend.displayName} kullanıcısına özel mesaj veya oda daveti iletin:',
                style: TextStyle(color: theme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                maxLines: 3,
                style: TextStyle(color: theme.textPrimary),
                decoration: InputDecoration(
                  hintText: lang.text('type_message'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.text('cancel'), style: TextStyle(color: theme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final myUser = AppState.auth.currentUser.value;
                if (myUser != null && textController.text.trim().isNotEmpty) {
                  AppState.friends.sendPrivateMessage(
                    toUsername: friend.username,
                    senderUsername: myUser.username,
                    senderDisplayName: myUser.displayName,
                    senderAvatarId: myUser.avatarId,
                    message: textController.text.trim(),
                  );
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    backgroundColor: theme.card,
                    content: Text(
                      lang.text('private_message_sent'),
                      style: TextStyle(color: theme.textPrimary),
                    ),
                  ),
                );
              },
              child: Text(lang.text('send')),
            ),
          ],
        );
      },
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
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(theme, lang),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<List<FriendModel>>(
                        valueListenable: AppState.friends.friends,
                        builder: (context, friends, _) {
                          if (friends.isEmpty) {
                            return _buildEmptyState(theme, lang);
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: friends.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final friend = friends[index];
                              return _buildFriendCard(friend, theme, lang);
                            },
                          );
                        },
                      ),
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

  Widget _buildHeader(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.people_alt_rounded, color: theme.secondary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoFitText(
                    lang.text('friends_title'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lang.text('friends_subtitle'),
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

  Widget _buildEmptyState(AppThemeModel theme, LanguageController lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.person_search_rounded, size: 48, color: theme.textSecondary),
            const SizedBox(height: 12),
            Text(
              lang.text('no_friends_yet'),
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(FriendModel friend, AppThemeModel theme, LanguageController lang) {
    final avatar = AvatarConstants.getById(friend.avatarId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: avatar.gradientColors),
                      ),
                      child: Icon(avatar.icon, color: Colors.white, size: 24),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: friend.inCall
                              ? Colors.amber
                              : (friend.isOnline ? theme.success : Colors.grey),
                          border: Border.all(color: theme.card, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoFitText(
                        friend.displayName,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        friend.inCall
                            ? '${lang.text('in_call')}${friend.currentRoom != null ? " (#${friend.currentRoom})" : ""}'
                            : (friend.isOnline ? lang.text('online') : lang.text('offline')),
                        style: TextStyle(
                          color: friend.inCall
                              ? Colors.amber
                              : (friend.isOnline ? theme.success : theme.textSecondary),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (friend.statusMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                friend.statusMessage,
                style: TextStyle(color: theme.textSecondary.withValues(alpha: 0.85), fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showPrivateMessageDialog(friend),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: Text(lang.text('private_msg')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.secondary,
                    side: BorderSide(color: theme.secondary.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                if (friend.inCall && friend.currentRoom != null)
                  ElevatedButton.icon(
                    onPressed: () => _joinFriendMeeting(friend.currentRoom!),
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: Text(lang.text('join_friend_meeting')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () => _startDirectCall(friend),
                    icon: const Icon(Icons.video_call_rounded, size: 18),
                    label: Text(lang.text('direct_call')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
