import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/entrepreneur_profile_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/business_application.dart';

class NoPlanForm extends StatefulWidget {
  const NoPlanForm({
    required this.initialApp,
    required this.onSaved,
    super.key,
  });

  final BusinessApplication initialApp;
  final VoidCallback onSaved;

  @override
  State<NoPlanForm> createState() => _NoPlanFormState();
}

class _NoPlanFormState extends State<NoPlanForm> {
  late final TextEditingController _ideaController;
  late final TextEditingController _needsController;
  String _targetTimeline = '1 - 3 Ay İçinde Şirketleşme';

  final List<String> _timelines = const [
    '1 - 3 Ay İçinde Şirketleşme',
    '3 - 6 Ay Fikir & MVP Doğrulama',
    'Araştırma & Ekip Kurma Aşaması',
  ];

  @override
  void initState() {
    super.initState();
    _ideaController = TextEditingController(text: widget.initialApp.summary);
    _needsController = TextEditingController(
      text: 'Hukuki Yapılanma, Mali Müşavir Desteği ve İlk Hibe Başvurusu',
    );
  }

  @override
  void dispose() {
    _ideaController.dispose();
    _needsController.dispose();
    super.dispose();
  }

  void _save() {
    EntrepreneurProfileController.instance.updateApplication(
      startupName: 'Erken Aşama Girişim Fikri',
      sector: 'Fikir Doğrulama & Girişimcilik',
      summary: _ideaController.text.trim().isEmpty
          ? 'Henüz netleşmemiş erken aşama iş fikri.'
          : _ideaController.text.trim(),
      financialNeed: 'Fikir Aşaması Danışmanlık ve Kuruluş Desteği',
      planStatus: BusinessPlanStatus.noPlan,
    );
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LiquidGlassContainer(
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Fikir / Odak Alanı', isDark),
              const SizedBox(height: 8),
              TextField(
                controller: _ideaController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Aklınızdaki fikir veya çözmek istediğiniz problem nedir?',
                ),
              ),
              const SizedBox(height: 16),
              _buildFieldLabel('İhtiyaç Duyulan İlk Uzmanlıklar', isDark),
              const SizedBox(height: 8),
              TextField(
                controller: _needsController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Şirket Kuruluşu, Avukat, Mali Müşavir, Mentor',
                ),
              ),
              const SizedBox(height: 16),
              _buildFieldLabel('Şirketleşme & Başlama Hedefi', isDark),
              const SizedBox(height: 8),
              _buildTimelineDropdown(isDark),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _buildSubmitButton(isDark),
      ],
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

  Widget _buildTimelineDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.7)
            : AppColors.lightSurface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _targetTimeline,
          isExpanded: true,
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          items: _timelines
              .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 14))))
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _targetTimeline = val);
          },
        ),
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
      icon: const Icon(Icons.lightbulb_outline_rounded, size: 20),
      label: const Text(
        'Rehberliğe Başla & Destek İste',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
