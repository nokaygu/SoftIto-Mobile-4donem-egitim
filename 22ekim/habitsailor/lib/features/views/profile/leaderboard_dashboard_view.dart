import 'package:flutter/material.dart';
import '../../../core/state/app_state.dart';
import '../../models/user_model.dart';
import '../../widgets/user_avatar_badge.dart';

class LeaderboardDashboardView extends StatelessWidget {
  const LeaderboardDashboardView({super.key});

  String _calculateRank(int streak) {
    if (streak >= 30) {
      return 'Açık Deniz Kaptanı ⚓';
    } else if (streak >= 10) {
      return 'Usta Dümenci 🧭';
    } else {
      return 'Hevesli Tayfa ⛵';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authController = AppState.instance.authController;
    final taskController = AppState.instance.taskController;

    final myUsername = authController.currentUser?.username ?? 'Kaptan';
    final myAvatarIndex = authController.currentUser?.avatarIndex ?? 0;
    final myStreak = taskController.getTotalStreakPoints();
    final recurringTasks =
        taskController.tasks.where((t) => t.isRecurring).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liderlik Tablosu & Dashboard',
          style: TextStyle(fontWeight: FontWeight.w800, color: cs.onSurface),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // User streak summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: cs.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: cs.outlineVariant,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  UserAvatarBadge(
                    avatarIndex: myAvatarIndex,
                    radius: 36,
                    isSelected: true,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    myUsername,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authController.sailorRank,
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildHeaderMetric(
                        context,
                        'Toplam Zincir',
                        '⚡ $myStreak Puan',
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: cs.outlineVariant,
                      ),
                      _buildHeaderMetric(
                        context,
                        'Aktif Alışkanlık',
                        '${recurringTasks.length} Rota',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Leaderboard Section Title
            Row(
              children: [
                Icon(Icons.emoji_events_rounded, color: cs.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Yedi Denizlerin Liderleri',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dynamic Leaderboard List
            FutureBuilder<List<UserModel>>(
              future: authController.getLeaderboardUsers(),
              builder: (context, snapshot) {
                final registeredUsers = snapshot.data ?? <UserModel>[];

                // Maritime mentors / NPC captains
                final Map<String, Map<String, dynamic>> captainsMap = {
                  'kaptan barbaros': {
                    'name': 'Kaptan Barbaros',
                    'avatar': 0,
                    'streak': 42,
                    'rank': 'Açık Deniz Kaptanı ⚓',
                    'isMe': false,
                  },
                  'dümenci piri': {
                    'name': 'Dümenci Piri',
                    'avatar': 1,
                    'streak': 28,
                    'rank': 'Usta Dümenci 🧭',
                    'isMe': false,
                  },
                  'gözcü oruç': {
                    'name': 'Gözcü Oruç',
                    'avatar': 2,
                    'streak': 18,
                    'rank': 'Usta Dümenci 🧭',
                    'isMe': false,
                  },
                  'tayfa turgut': {
                    'name': 'Tayfa Turgut',
                    'avatar': 3,
                    'streak': 9,
                    'rank': 'Hevesli Tayfa ⛵',
                    'isMe': false,
                  },
                };

                // Add or update real registered users from storage
                for (final u in registeredUsers) {
                  final key = u.username.toLowerCase();
                  final isMe = key == myUsername.toLowerCase();
                  final currentStreak = isMe ? myStreak : u.totalStreak;

                  captainsMap[key] = {
                    'name': u.username,
                    'avatar': u.avatarIndex,
                    'streak': currentStreak,
                    'rank': _calculateRank(currentStreak),
                    'isMe': isMe,
                  };
                }

                // Ensure current user is present
                if (!captainsMap.containsKey(myUsername.toLowerCase())) {
                  captainsMap[myUsername.toLowerCase()] = {
                    'name': myUsername,
                    'avatar': myAvatarIndex,
                    'streak': myStreak,
                    'rank': authController.sailorRank,
                    'isMe': true,
                  };
                }

                final captains = captainsMap.values.toList();
                captains.sort((a, b) => (b['streak'] as int).compareTo(a['streak'] as int));

                return Column(
                  children: List.generate(captains.length, (index) {
                    final captain = captains[index];
                    final isMe = captain['isMe'] as bool;
                    final rankNumber = index + 1;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isMe ? cs.primaryContainer : cs.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isMe ? cs.primary : cs.outlineVariant,
                          width: isMe ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: rankNumber <= 3 ? cs.primary : cs.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$rankNumber',
                              style: TextStyle(
                                color: rankNumber <= 3 ? cs.onPrimary : cs.onSurface,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          UserAvatarBadge(
                            avatarIndex: captain['avatar'] as int,
                            radius: 20,
                            showBorder: false,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        captain['name'] as String,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: cs.onSurface,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    if (isMe) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: cs.primary,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Sen',
                                          style: TextStyle(
                                            color: cs.onPrimary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  captain['rank'] as String,
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bolt_rounded, size: 16, color: cs.primary),
                                const SizedBox(width: 2),
                                Text(
                                  '${captain['streak']}',
                                  style: TextStyle(
                                    color: cs.onSurface,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderMetric(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: cs.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: cs.onPrimaryContainer,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
