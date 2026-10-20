import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/team_member.dart';

class AddTeamMemberSheet extends StatefulWidget {
  const AddTeamMemberSheet({required this.onAdd, super.key});

  final void Function(TeamMember) onAdd;

  @override
  State<AddTeamMemberSheet> createState() => _AddTeamMemberSheetState();
}

class _AddTeamMemberSheetState extends State<AddTeamMemberSheet> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _respController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _respController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final role = _roleController.text.trim();
    final resp = _respController.text.trim();

    if (name.isEmpty || role.isEmpty) return;

    final member = TeamMember(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      role: role,
      responsibilities: resp.isEmpty ? 'Genel Katkı ve Operasyon' : resp,
    );

    widget.onAdd(member);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(28),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(isDark),
            const SizedBox(height: 18),
            _buildTextField(_nameController, 'Ad Soyad', Icons.person_outline),
            const SizedBox(height: 12),
            _buildTextField(_roleController, 'Rol / Unvan (Örn: CTO, Tasarımcı)', Icons.work_outline),
            const SizedBox(height: 12),
            _buildTextField(_respController, 'Sorumluluklar / Yaptığı İş', Icons.assignment_outlined),
            const SizedBox(height: 20),
            _buildSaveButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Yeni Ekip Üyesi Ekle',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      onPressed: _submit,
      child: const Text('Ekibe Dahil Et', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
    );
  }
}
