import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/entrepreneur_profile_controller.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../../onboarding/models/business_application.dart';

/// iPhone Dynamic Island esintili yüzen uzman onay simülasyon kapsülü.
class DynamicIslandApprovalBar extends StatelessWidget {
  const DynamicIslandApprovalBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<BusinessApplication>(
      valueListenable: EntrepreneurProfileController.instance.applicationNotifier,
      builder: (context, app, _) {
        final isApproved = app.isApproved;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LiquidGlassContainer(
            borderRadius: BorderRadius.circular(30),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _buildStatusBadge(isApproved, isDark),
                const SizedBox(width: 10),
                Expanded(child: _buildInfoText(isApproved, isDark)),
                _buildSimulateButton(context, isApproved, isDark),
                const SizedBox(width: 4),
                _buildThemeToggle(isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(bool isApproved, bool isDark) {
    final color = isApproved
        ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
        : AppColors.lightWarning;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.2),
      ),
      child: Icon(
        isApproved ? Icons.verified_rounded : Icons.hourglass_top_rounded,
        size: 18,
        color: color,
      ),
    );
  }

  Widget _buildInfoText(bool isApproved, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                isApproved ? 'ONAYLI GİRİŞİMCİ' : 'İNCELEMEDE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: isApproved
                      ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                      : AppColors.lightWarning,
                ),
              ),
            ),
            if (isApproved) ...[
              const SizedBox(width: 4),
              const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
            ],
          ],
        ),
        Text(
          isApproved ? 'Avukat & Mali Müşavir Aktif' : 'Simülasyonla onayla',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSimulateButton(BuildContext context, bool isApproved, bool isDark) {
    final accent = isApproved ? AppColors.lightWarning : (isDark ? AppColors.darkAccent : AppColors.lightAccent);

    return InkWell(
      onTap: () {
        EntrepreneurProfileController.instance.toggleApprovalSimulation();
        final nowApproved = !isApproved;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            content: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.95) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: nowApproved
                      ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                      : AppColors.lightWarning,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (nowApproved
                            ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                            : AppColors.lightWarning)
                        .withValues(alpha: 0.25),
                    blurRadius: 18,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    nowApproved ? Icons.verified_rounded : Icons.pending_rounded,
                    color: nowApproved
                        ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                        : AppColors.lightWarning,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      nowApproved
                          ? 'Onaylı Girişimci! Avukat ve Mali Müşavir atandı.'
                          : 'Başvuru inceleme durumuna alındı.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isApproved ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 14, color: accent),
            const SizedBox(width: 3),
            Text(
              isApproved ? 'Geri Al' : 'Onayla',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: accent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(bool isDark) {
    return IconButton(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        size: 18,
      ),
      onPressed: () => ThemeController.instance.toggleTheme(),
    );
  }
}
