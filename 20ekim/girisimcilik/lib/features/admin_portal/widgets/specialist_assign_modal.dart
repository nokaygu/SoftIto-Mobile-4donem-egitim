import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';

class SpecialistAssignModal extends StatefulWidget {
  const SpecialistAssignModal({
    super.key,
    required this.startupName,
  });

  final String startupName;

  @override
  State<SpecialistAssignModal> createState() => _SpecialistAssignModalState();
}

class _SpecialistAssignModalState extends State<SpecialistAssignModal> {
  String _selectedLawyer = 'Av. Selin Kaya (Start-up & Teknoloji Hukukçusu)';
  String _selectedAccountant = 'SMMM Emre Demir (Girişimci & Teknokent Mali Müşaviri)';

  final _lawyers = [
    'Av. Selin Kaya (Start-up & Teknoloji Hukukçusu)',
    'Av. Burak Yurt (Fikri Mülkiyet & Patent Uzmanı)',
    'Av. Deniz Arslan (Yatırım Sözleşmeleri & M&A)',
  ];

  final _accountants = [
    'SMMM Emre Demir (Girişimci & Teknokent Mali Müşaviri)',
    'SMMM Gamze Çelik (Ar-Ge İndirimleri & Bordro)',
    'SMMM Tolga Yaman (Vergi Muafiyetleri & Finans)',
  ];

  void _saveAssignments() {
    AuthRoleController.instance.assignSpecialistsToStartup(
      startupName: widget.startupName,
      lawyerName: _selectedLawyer,
      accountantName: _selectedAccountant,
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF131B2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFF59E0B)),
        ),
        content: Row(
          children: [
            const Icon(Icons.verified_user_rounded, color: Color(0xFFF59E0B)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${widget.startupName} girişimine uzmanlar başarıyla atandı!',
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
              _buildLawyerPicker(isDark),
              const SizedBox(height: 16),
              _buildAccountantPicker(isDark),
              const SizedBox(height: 22),
              _buildSubmitButton(),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uzman Atama Masası',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
            Text(
              'Hedef: ${widget.startupName}',
              style: const TextStyle(fontSize: 12, color: Color(0xFFF59E0B), fontWeight: FontWeight.w700),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildLawyerPicker(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Atanacak Hukuk Müşaviri (Avukat)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedLawyer,
              dropdownColor: isDark ? const Color(0xFF131B2E) : Colors.white,
              items: _lawyers.map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontSize: 12.5)))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedLawyer = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountantPicker(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Atanacak Mali Müşavir (SMMM)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedAccountant,
              dropdownColor: isDark ? const Color(0xFF131B2E) : Colors.white,
              items: _accountants.map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontSize: 12.5)))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedAccountant = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveAssignments,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF59E0B),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text('Uzmanları Resmi Olarak Ata', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}
