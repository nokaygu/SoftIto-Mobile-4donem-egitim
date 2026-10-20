import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/entrepreneur_profile_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/community_post.dart';
import '../widgets/new_post_sheet.dart';
import '../widgets/post_card.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final List<CommunityPost> _posts = [
    const CommunityPost(
      id: 'p1',
      authorName: 'Caner Şahin',
      authorHandle: '@caner_ai',
      startupName: 'Synthetica DeepTech',
      isVerifiedFounder: true,
      content:
          'TÜBİTAK 1507 Ar-Ge desteğimiz bugün resmen onaylandı! 🚀 Kurucu platformu üzerinden atanan mali müşavirimizle hibe bütçe kalemlerini 2 haftada tamamlamıştık. Hukuki esas sözleşme hazırlığında olanlara önerim kesinlikle pay devri kısıtlarını baştan netleştirmeleri.',
      timestamp: '25 dk önce',
      likesCount: 24,
      isLiked: false,
      commentsCount: 6,
    ),
    const CommunityPost(
      id: 'p2',
      authorName: 'Zeynep Akman',
      authorHandle: '@zeynep_health',
      startupName: 'MedPulse IoT',
      isVerifiedFounder: true,
      content:
          'İlk melek yatırım turumuz için SAFE (Simple Agreement for Future Equity) sözleşmesi kullanmayı planlıyoruz. Türk Ticaret Kanunu açısından Türkiye merkezli A.Ş.’lerde uygulayan var mı? Deneyimlerinizi merak ediyorum.',
      timestamp: '2 sa önce',
      likesCount: 19,
      isLiked: true,
      commentsCount: 11,
    ),
    const CommunityPost(
      id: 'p3',
      authorName: 'Barış Koç',
      authorHandle: '@bariskoc',
      startupName: 'PayFlow B2B',
      isVerifiedFounder: false,
      content:
          'KOSGEB İleri Girişimci desteği için başvuru dosyamızı hazırlıyoruz. Şirket kuruluşunda sermaye blokesi için hangi bankalarla daha hızlı süreç yürüttünüz?',
      timestamp: '5 sa önce',
      likesCount: 8,
      isLiked: false,
      commentsCount: 4,
    ),
  ];

  void _toggleLike(int index) {
    setState(() {
      final current = _posts[index];
      final newIsLiked = !current.isLiked;
      final newLikes = newIsLiked ? current.likesCount + 1 : current.likesCount - 1;
      _posts[index] = current.copyWith(
        isLiked: newIsLiked,
        likesCount: newLikes,
      );
    });
  }

  void _openNewPostSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewPostSheet(
        onPostCreated: (post) {
          setState(() => _posts.insert(0, post));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 100),
      children: [
        _buildComposePromptCard(isDark),
        const SizedBox(height: 16),
        for (int i = 0; i < _posts.length; i++)
          PostCard(
            post: _posts[i],
            onToggleLike: () => _toggleLike(i),
          ),
      ],
    );
  }

  Widget _buildComposePromptCard(bool isDark) {
    final app = EntrepreneurProfileController.instance.currentApplication;
    final isApproved = app.isApproved;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;

    return GestureDetector(
      onTap: _openNewPostSheet,
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(22),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: (isDark ? AppColors.darkAccent : AppColors.lightAccent).withValues(alpha: 0.2),
              child: const Icon(Icons.edit_note_rounded, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ekosistemle yeni bir gelişme veya soru paylaş...',
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            if (isApproved)
              Icon(Icons.verified_rounded, size: 16, color: successColor),
          ],
        ),
      ),
    );
  }
}
