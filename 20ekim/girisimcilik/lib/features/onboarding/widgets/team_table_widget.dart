import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/team_member.dart';
import 'add_team_member_sheet.dart';

class TeamTableWidget extends StatelessWidget {
  const TeamTableWidget({
    required this.teamMembers,
    required this.onAddMember,
    required this.onRemoveMember,
    super.key,
  });

  final List<TeamMember> teamMembers;
  final void Function(TeamMember) onAddMember;
  final void Function(String id) onRemoveMember;

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTeamMemberSheet(onAdd: onAddMember),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTableHeader(context, isDark),
          const SizedBox(height: 14),
          if (teamMembers.isEmpty)
            _buildEmptyState(isDark)
          else
            _buildCustomTable(isDark),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, bool isDark) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.groups_rounded, size: 20, color: accent),
            const SizedBox(width: 8),
            Text(
              'Girişim Ekip Tablosu (${teamMembers.length})',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () => _openAddSheet(context),
          icon: Icon(Icons.add_circle_outline_rounded, size: 18, color: accent),
          label: Text('Üye Ekle', style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'Henüz ekip üyesi eklenmedi. "Üye Ekle" ile başlayın.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable(bool isDark) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1.3),
        2: FlexColumnWidth(1.8),
        3: FixedColumnWidth(42),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
                width: 1.2,
              ),
            ),
          ),
          children: [
            _buildColumnHeader('KİŞİ', isDark),
            _buildColumnHeader('ROL', isDark),
            _buildColumnHeader('SORUMLULUK', isDark),
            const SizedBox(),
          ],
        ),
        for (final member in teamMembers)
          TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                  width: 0.8,
                ),
              ),
            ),
            children: [
              _buildCell(member.name, isDark, isBold: true),
              _buildCell(member.role, isDark),
              _buildCell(member.responsibilities, isDark),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                onPressed: () => onRemoveMember(member.id),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildColumnHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildCell(String text, bool isDark, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}
