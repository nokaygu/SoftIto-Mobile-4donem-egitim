import 'package:flutter/material.dart';
import '../../core/constants/avatar_constants.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme_model.dart';
import '../models/chat_message_model.dart';
import 'responsive_wrapper.dart';

/// Konferans Odası Canlı Sohbet Paneli
class RoomChatPanel extends StatefulWidget {
  final VoidCallback onClose;

  const RoomChatPanel({super.key, required this.onClose});

  @override
  State<RoomChatPanel> createState() => _RoomChatPanelState();
}

class _RoomChatPanelState extends State<RoomChatPanel> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final user = AppState.auth.currentUser.value;
    if (user == null) return;

    AppState.conference.sendMessage(
      senderUsername: user.username,
      senderDisplayName: user.displayName,
      senderAvatarId: user.avatarId,
      text: text,
    );

    _textController.clear();
    // En alta kaydır
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onUserTapped(ChatMessageModel message) {
    final currentUser = AppState.auth.currentUser.value;
    if (currentUser == null) return;

    // Kendisi ise işlem yapma
    if (message.senderUsername == currentUser.username || message.isSystem) {
      return;
    }

    final theme = AppState.theme.theme;
    final lang = AppState.language;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final avatar = AvatarConstants.getById(message.senderAvatarId);
        final isAlreadyFriend = AppState.friends.isFriend(message.senderUsername);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: avatar.gradientColors),
                      ),
                      child: Icon(avatar.icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoFitText(
                            message.senderDisplayName,
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '@${message.senderUsername}',
                            style: TextStyle(color: theme.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Arkadaş Ekle Butonu
                ListTile(
                  leading: Icon(
                    isAlreadyFriend ? Icons.check_circle_rounded : Icons.person_add_rounded,
                    color: isAlreadyFriend ? theme.success : theme.primary,
                  ),
                  title: Text(
                    isAlreadyFriend ? lang.text('already_friends') : lang.text('add_friend'),
                    style: TextStyle(
                      color: isAlreadyFriend ? theme.textSecondary : theme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  enabled: !isAlreadyFriend,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: theme.card,
                  onTap: () {
                    Navigator.pop(context);
                    final success = AppState.friends.addFriend(
                      username: message.senderUsername,
                      displayName: message.senderDisplayName,
                      avatarId: message.senderAvatarId,
                    );
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        backgroundColor: theme.card,
                        content: Text(
                          success
                              ? '${message.senderDisplayName} ${lang.text('friend_added_success')}'
                              : lang.text('already_friends'),
                          style: TextStyle(color: theme.textPrimary),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Özel Mesaj Gönder Butonu
                ListTile(
                  leading: Icon(Icons.send_rounded, color: theme.secondary),
                  title: Text(
                    lang.text('send_private_message'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: theme.card,
                  onTap: () {
                    Navigator.pop(context);
                    _showPrivateMessageDialog(message);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPrivateMessageDialog(ChatMessageModel target) {
    final theme = AppState.theme.theme;
    final lang = AppState.language;
    final controller = TextEditingController(
      text: 'Merhaba, VizyonMeet odasından (${AppState.conference.currentChannel.value}) davetimdir!',
    );

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surface,
          title: Text(
            '${target.senderDisplayName} - ${lang.text('private_message_title')}',
            style: TextStyle(color: theme.textPrimary, fontSize: 16),
          ),
          content: TextField(
            controller: controller,
            maxLines: 3,
            style: TextStyle(color: theme.textPrimary),
            decoration: InputDecoration(
              hintText: lang.text('type_message'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.text('cancel'), style: TextStyle(color: theme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final myUser = AppState.auth.currentUser.value;
                if (myUser != null) {
                  AppState.friends.sendPrivateMessage(
                    toUsername: target.senderUsername,
                    senderUsername: myUser.username,
                    senderDisplayName: myUser.displayName,
                    senderAvatarId: myUser.avatarId,
                    message: controller.text,
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
    final theme = AppState.theme.theme;
    final lang = AppState.language;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Başlık Çubuğu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_rounded, color: theme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoFitText(
                    lang.text('chat_title'),
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: theme.textSecondary),
                  onPressed: widget.onClose,
                  tooltip: lang.text('cancel'),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),

          // İpucu Bilgilendirmesi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: theme.primary.withValues(alpha: 0.08),
            child: Text(
              lang.text('chat_hint'),
              style: TextStyle(color: theme.textSecondary, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),

          // Mesaj Listesi
          Expanded(
            child: ValueListenableBuilder<List<ChatMessageModel>>(
              valueListenable: AppState.conference.roomMessages,
              builder: (context, messages, _) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageItem(msg, theme);
                  },
                );
              },
            ),
          ),

          // Mesaj Yazma Alanı
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(color: theme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: lang.text('type_message'),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessageModel msg, AppThemeModel theme) {
    if (msg.isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg.message,
            style: TextStyle(color: theme.textSecondary, fontSize: 11),
          ),
        ),
      );
    }

    final avatar = AvatarConstants.getById(msg.senderAvatarId);
    final myUsername = AppState.auth.currentUser.value?.username;
    final isMe = msg.senderUsername == myUsername;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () => _onUserTapped(msg),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: avatar.gradientColors),
                ),
                child: Icon(avatar.icon, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            msg.senderDisplayName,
                            style: TextStyle(
                              color: isMe ? theme.primary : theme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: theme.textSecondary.withValues(alpha: 0.6), fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      msg.message,
                      style: TextStyle(color: theme.textPrimary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
