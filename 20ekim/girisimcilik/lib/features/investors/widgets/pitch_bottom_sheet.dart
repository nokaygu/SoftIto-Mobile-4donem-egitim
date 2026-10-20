import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/entrepreneur_profile_controller.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/investor.dart';

class PitchBottomSheet extends StatefulWidget {
  const PitchBottomSheet({
    required this.investor,
    required this.onSent,
    super.key,
  });

  final Investor investor;
  final VoidCallback onSent;

  @override
  State<PitchBottomSheet> createState() => _PitchBottomSheetState();
}

class _PitchBottomSheetState extends State<PitchBottomSheet> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final app = EntrepreneurProfileController.instance.currentApplication;
    _noteController = TextEditingController(
      text: 'Merhaba ${widget.investor.name}, ${app.startupName} girişimimiz için hazırladığımız pitch deck sunumunu incelemenize sunmak istiyoruz.',
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app = EntrepreneurProfileController.instance.currentApplication;

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
            const SizedBox(height: 14),
            _buildStartupSummary(app, isDark),
            const SizedBox(height: 14),
            _buildNoteField(),
            const SizedBox(height: 18),
            _buildSendButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sunum (Pitch Deck) Gönder',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              'Alıcı: ${widget.investor.name} (${widget.investor.fundName})',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildStartupSummary(dynamic app, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ekli Dosyalar: PitchDeck_${app.startupName}_v2.pdf (Otomatik eklendi)', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text('Finansal Talep: ${app.financialNeed}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNoteField() {
    return TextField(
      controller: _noteController,
      maxLines: 3,
      decoration: const InputDecoration(hintText: 'Yatırımcıya özel kısa ön yazı ekleyin...'),
    );
  }

  Widget _buildSendButton(bool isDark) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      onPressed: () {
        widget.onSent();
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.send_rounded, size: 18),
      label: const Text('Sunumu & Bilgileri İlet', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
    );
  }
}
