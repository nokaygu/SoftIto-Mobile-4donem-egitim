import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/grant.dart';

class GrantCard extends StatelessWidget {
  const GrantCard({
    required this.grant,
    required this.onApply,
    super.key,
  });

  final Grant grant;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isApplied = grant.status != GrantApplicationStatus.notApplied;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 10),
          _buildTitle(isDark),
          const SizedBox(height: 12),
          _buildDetailsRow(isDark),
          const SizedBox(height: 14),
          _buildApplyButton(isApplied, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkSuccess : AppColors.lightSuccess).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            grant.provider,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
            ),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(grant.deadline, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          grant.programName,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          grant.description,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsRow(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.07) : Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hibe Tutarı',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                grant.maxAmount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Destek Oranı',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                grant.supportRatio,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(bool isApplied, bool isDark) {
    final successColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isApplied ? successColor.withValues(alpha: 0.2) : accent,
        foregroundColor: isApplied ? successColor : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isApplied ? BorderSide(color: successColor.withValues(alpha: 0.6)) : BorderSide.none,
        ),
        elevation: 0,
      ),
      onPressed: onApply,
      icon: Icon(isApplied ? Icons.check_circle_rounded : Icons.touch_app_rounded, size: 16),
      label: Text(
        isApplied ? 'Başvuru Alındı (İncelemede)' : 'Tek Tıkla Başvuru Yap',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }
}
