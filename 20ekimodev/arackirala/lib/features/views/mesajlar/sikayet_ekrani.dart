import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../models/mesaj_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/liquid_dialog.dart';
import '../../widgets/liquid_glass_card.dart';
import '../../widgets/liquid_text_field.dart';

/// Kullanıcı veya Araç Hakkında Şikayet Bildirme Ekranı
class SikayetEkrani extends StatefulWidget {
  final String? sikayetEdilenId;
  final String? sikayetEdilenAd;
  final String? aracId;

  const SikayetEkrani({
    super.key,
    this.sikayetEdilenId,
    this.sikayetEdilenAd,
    this.aracId,
  });

  @override
  State<SikayetEkrani> createState() => _SikayetEkraniState();
}

class _SikayetEkraniState extends State<SikayetEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _baslikCtrl = TextEditingController();
  final _aciklamaCtrl = TextEditingController();

  final List<String> _kategoriler = [
    'Teslimat Gecikmesi',
    'Araç Temizliği / Hasar',
    'İletişim & Saygı',
    'Ödeme / Fiyat Uyuşmazlığı',
    'Diğer',
  ];

  late String _seciliKategori;

  @override
  void initState() {
    super.initState();
    _seciliKategori = _kategoriler.first;
  }

  @override
  void dispose() {
    _baslikCtrl.dispose();
    _aciklamaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldColor,
      appBar: const LiquidAppBar(title: 'Güvenlik & Şikayet Bildir'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTargetInfoCard(context),
            const SizedBox(height: 14),
            _buildCategorySelectorCard(context),
            const SizedBox(height: 14),
            _buildFormCard(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetInfoCard(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, color: AppColors.error, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bildirilen Taraf',
                  style: TextStyle(color: context.textMutedColor, fontSize: 12),
                ),
                Text(
                  widget.sikayetEdilenAd ?? 'Sistem Kullanıcısı',
                  style: TextStyle(
                    color: context.textPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelectorCard(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Şikayet Kategorisi',
            style: TextStyle(
              color: context.textPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _kategoriler.map((kat) {
              final isSel = _seciliKategori == kat;
              return ChoiceChip(
                label: Text(kat),
                selected: isSel,
                selectedColor: AppColors.burgundyPrimary,
                backgroundColor: context.surfaceVariantColor,
                labelStyle: TextStyle(
                  color: isSel ? AppColors.textWhite : context.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                ),
                onSelected: (val) => setState(() => _seciliKategori = kat),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LiquidTextField(
            controller: _baslikCtrl,
            label: 'Şikayet Başlığı',
            hintText: 'Örn: Araç randevu saatinden 2 saat geç teslim edildi',
            validator: (v) =>
                v == null || v.trim().length < 5 ? 'Şikayet başlığı en az 5 karakter olmalıdır' : null,
          ),
          const SizedBox(height: 14),
          LiquidTextField(
            controller: _aciklamaCtrl,
            label: 'Detaylı Açıklama',
            hintText: 'Yaşadığınız sorunu detaylarıyla açıklayınız...',
            maxLines: 4,
            validator: (v) =>
                v == null || v.trim().length < 15 ? 'Şikayet açıklaması en az 15 karakter olmalıdır' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return LiquidButton(
      text: 'Şikayeti Yetkiliye İlet',
      icon: Icons.send_rounded,
      customColor: AppColors.error.withValues(alpha: 0.9),
      onPressed: _sikayetiGonder,
    );
  }

  Future<void> _sikayetiGonder() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showLiquidConfirmationDialog(
      context,
      title: 'Şikayeti İlet',
      message:
          'Şikayet başvurunuz incelenmek üzere güvenlik ekibimize iletilecektir. Göndermek istediğinize emin misiniz?',
      confirmText: 'Gönder',
      isDestructive: true,
      icon: Icons.shield_outlined,
    );

    if (confirmed != true) return;

    final currentUser = AppState.userProfile.currentUser.value;
    final yeniSikayet = SikayetModel(
      id: 'sk_${DateTime.now().millisecondsSinceEpoch}',
      sikayetEdenId: currentUser?.id ?? 'usr_anon',
      sikayetEdenAd: currentUser?.adSoyad ?? 'Kullanıcı',
      sikayetEdilenId: widget.sikayetEdilenId ?? 'usr_hedef',
      sikayetEdilenAd: widget.sikayetEdilenAd ?? 'Bildirilen Kişi',
      aracId: widget.aracId,
      baslik: '[$_seciliKategori] ${_baslikCtrl.text.trim()}',
      aciklama: _aciklamaCtrl.text.trim(),
      tarih: DateTime.now(),
    );

    AppState.mesaj.sikayetGonder(yeniSikayet);

    if (!mounted) return;

    await showLiquidSuccessDialog(
      context,
      title: 'Şikayetiniz Alındı',
      message:
          'Başvurunuz (#${yeniSikayet.id}) yetkili birimlerimize iletilmiştir. Güvenliğiniz için inceleme başlatılacaktır.',
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
