import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';

class AdminAuditView extends StatelessWidget {
  const AdminAuditView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<SystemAuditLog>>(
      valueListenable: AuthRoleController.instance.auditLogsNotifier,
      builder: (context, logs, _) {
        return ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 110),
          children: [
            _buildAuditBanner(isDark, logs.length),
            const SizedBox(height: 14),
            for (final log in logs)
              _buildLogItem(log, isDark),
          ],
        );
      },
    );
  }

  Widget _buildAuditBanner(bool isDark, int count) {
    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.history_edu_rounded, color: Color(0xFFF59E0B), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sistem Denetim Günlüğü ($count İşlem Kayıtlı)',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(SystemAuditLog log, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: log.isImportant ? const Color(0xFFF59E0B) : AppColors.darkSuccess,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.action,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hedef: ${log.target} • Yetkili: ${log.actor}',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            Text(
              log.time,
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
