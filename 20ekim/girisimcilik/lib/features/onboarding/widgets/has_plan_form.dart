import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/entrepreneur_profile_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/business_application.dart';
import 'team_table_widget.dart';

class HasPlanForm extends StatefulWidget {
  const HasPlanForm({
    required this.initialApp,
    required this.onSaved,
    super.key,
  });

  final BusinessApplication initialApp;
  final VoidCallback onSaved;

  @override
  State<HasPlanForm> createState() => _HasPlanFormState();
}

class _HasPlanFormState extends State<HasPlanForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _summaryController;
  late final TextEditingController _fundingController;
  String _selectedSector = 'Yapay Zeka & Derin Teknoloji';

  final List<String> _sectors = const [
    'Yapay Zeka & Derin Teknoloji',
    'Fintech & Açık Bankacılık',
    'SaaS & B2B Yazılım',
    'Sağlık Teknolojileri (HealthTech)',
    'E-Ticaret & Lojistik',
    'Sürdürülebilirlik & Temiz Enerji',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialApp.startupName);
    _summaryController = TextEditingController(text: widget.initialApp.summary);
    _fundingController = TextEditingController(text: widget.initialApp.financialNeed);
    if (_sectors.contains(widget.initialApp.sector)) {
      _selectedSector = widget.initialApp.sector;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    _fundingController.dispose();
    super.dispose();
  }

  void _save() {
    EntrepreneurProfileController.instance.updateApplication(
      startupName: _nameController.text.trim().isEmpty ? 'Girişimim' : _nameController.text.trim(),
      sector: _selectedSector,
      summary: _summaryController.text.trim(),
      financialNeed: _fundingController.text.trim(),
      planStatus: BusinessPlanStatus.hasPlan,
    );
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teamMembers = widget.initialApp.teamMembers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBasicInfoSection(isDark),
        const SizedBox(height: 18),
        TeamTableWidget(
          teamMembers: teamMembers,
          onAddMember: (member) => EntrepreneurProfileController.instance.addTeamMember(member),
          onRemoveMember: (id) => EntrepreneurProfileController.instance.removeTeamMember(id),
        ),
        const SizedBox(height: 22),
        _buildSubmitButton(isDark),
      ],
    );
  }

  Widget _buildBasicInfoSection(bool isDark) {
    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Girişim / Şirket Adı', isDark),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Örn: NovaTech AI'),
          ),
          const SizedBox(height: 16),
          _buildFieldLabel('Faaliyet Sektörü', isDark),
          const SizedBox(height: 8),
          _buildSectorDropdown(isDark),
          const SizedBox(height: 16),
          _buildFieldLabel('Girişim Özeti & Problem / Çözüm', isDark),
          const SizedBox(height: 8),
          TextField(
            controller: _summaryController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Ne yapıyorsunuz? Müşteriye sağladığınız değer nedir?'),
          ),
          const SizedBox(height: 16),
          _buildFieldLabel('Finansal İhtiyaç & Hedef Yatırım', isDark),
          const SizedBox(height: 8),
          TextField(
            controller: _fundingController,
            decoration: const InputDecoration(hintText: 'Örn: 2.000.000 ₺ Tohum Öncesi (Pre-Seed)'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectorDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface.withValues(alpha: 0.7) : AppColors.lightSurface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSector,
          isExpanded: true,
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          items: _sectors.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedSector = val);
          },
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: 0,
      ),
      onPressed: _save,
      icon: const Icon(Icons.send_rounded, size: 20),
      label: const Text('Başvuruyu Güncelle & İncelemeye Al', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
    );
  }
}
