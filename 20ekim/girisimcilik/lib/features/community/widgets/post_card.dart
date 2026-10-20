import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/community_post.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.onToggleLike,
    super.key,
  });

  final CommunityPost post;
  final VoidCallback onToggleLike;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAuthorRow(isDark),
          const SizedBox(height: 10),
          _buildContent(isDark),
          const SizedBox(height: 12),
          _buildActionRow(isDark),
        ],
      ),
    );
  }

  Widget _buildAuthorRow(bool isDark) {
    final successColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: accent.withValues(alpha: 0.16),
          child: Text(
            post.authorName.substring(0, 2).toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w800, color: accent, fontSize: 13),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      post.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  if (post.isVerifiedFounder) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.verified_rounded, size: 16, color: successColor),
                  ],
                ],
              ),
              Text(
                '${post.authorHandle} • ${post.startupName}',
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          post.timestamp,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(bool isDark) {
    return Text(
      post.content,
      style: TextStyle(
        fontSize: 13.5,
        height: 1.45,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }

  Widget _buildActionRow(bool isDark) {
    return Row(
      children: [
        InkWell(
          onTap: onToggleLike,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 18,
                  color: post.isLiked ? Colors.redAccent : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.likesCount}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: post.isLiked ? Colors.redAccent : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        Row(
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, size: 17, color: Colors.grey),
            const SizedBox(width: 4),
            Text('${post.commentsCount}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.share_outlined, size: 17, color: Colors.grey),
      ],
    );
  }
}
