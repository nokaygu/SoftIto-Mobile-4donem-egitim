import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/entrepreneur_profile_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/community_post.dart';

class NewPostSheet extends StatefulWidget {
  const NewPostSheet({required this.onPostCreated, super.key});

  final void Function(CommunityPost) onPostCreated;

  @override
  State<NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends State<NewPostSheet> {
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _contentController.text.trim();
    if (text.isEmpty) return;

    final app = EntrepreneurProfileController.instance.currentApplication;

    final newPost = CommunityPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: app.founderName.isEmpty ? 'Girişimci' : app.founderName,
      authorHandle: '@${app.founderName.toLowerCase().replaceAll(' ', '')}',
      startupName: app.startupName.isEmpty ? 'Girişim' : app.startupName,
      isVerifiedFounder: app.isApproved,
      content: text,
      timestamp: 'Şimdi',
      likesCount: 0,
      isLiked: false,
      commentsCount: 0,
    );

    widget.onPostCreated(newPost);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isApproved = EntrepreneurProfileController.instance.isApproved;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(28),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(isDark, isApproved),
            const SizedBox(height: 14),
            _buildInputField(),
            const SizedBox(height: 18),
            _buildShareButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isApproved) {
    final successColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Girişimci Ağına Paylaş',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            if (isApproved) ...[
              const SizedBox(width: 6),
              Icon(Icons.verified_rounded, size: 16, color: successColor),
            ],
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _contentController,
      maxLines: 4,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Fikriniz, bir güncelleme veya ekosisteme sormak istediğiniz bir soru...',
      ),
    );
  }

  Widget _buildShareButton(bool isDark) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      onPressed: _submit,
      icon: const Icon(Icons.send_rounded, size: 18),
      label: const Text('Toplulukla Paylaş', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
    );
  }
}
