import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';

class DealEvaluationModal extends StatelessWidget {
  const DealEvaluationModal({
    super.key,
    required this.startup,
  });

  final DealStartup startup;

  void _updateStatus(BuildContext context, PitchEvaluationStatus status, String message) {
    AuthRoleController.instance.updateDealStatus(startup.id, status);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF131B2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.investorAccentLight),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.investorAccentLight),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(28),
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModalHeader(context, isDark),
              const SizedBox(height: 16),
              _buildDetailSection(isDark),
              const SizedBox(height: 20),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                startup.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${startup.founder} • ${startup.sector}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildDetailSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoTile('Aşama & Değerleme', '${startup.stage} | Post-Money ${startup.valuation}', isDark),
        const SizedBox(height: 10),
        _buildInfoTile('Talep Edilen Yatırım', '${startup.fundingGoal} karşılığı ${startup.equityOffered} pay', isDark),
        const SizedBox(height: 10),
        _buildInfoTile('İş & Ürün Özeti', startup.summary, isDark),
      ],
    );
  }

  Widget _buildInfoTile(String title, String content, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.investorAccentLight),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.35,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _updateStatus(
              context,
              PitchEvaluationStatus.termSheetSent,
              '${startup.name} girişimine Term Sheet (Niyet Mektubu) iletildi!',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.investorAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.handshake_outlined, size: 16),
                SizedBox(width: 8),
                Text('Term Sheet (Niyet Mektubu) İlet', style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _updateStatus(
              context,
              PitchEvaluationStatus.meetingScheduled,
              '${startup.founder} ile ön tanışma toplantısı takvime işlendi.',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              side: const BorderSide(color: AppColors.investorAccentLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Toplantı Planla', style: TextStyle(color: AppColors.investorAccentLight, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}
