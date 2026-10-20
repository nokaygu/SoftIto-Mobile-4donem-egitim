import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../models/arac_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/liquid_glass_card.dart';
import '../../widgets/liquid_text_field.dart';

/// Yeni Araç İlanı Ekleme Ekranı
class AracEklemeEkrani extends StatefulWidget {
  const AracEklemeEkrani({super.key});

  @override
  State<AracEklemeEkrani> createState() => _AracEklemeEkraniState();
}

class _AracEklemeEkraniState extends State<AracEklemeEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _markaCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yilCtrl = TextEditingController(text: '2023');
  final _fiyatCtrl = TextEditingController();
  final _sehirCtrl = TextEditingController(text: 'İstanbul, Beşiktaş');
  final _aciklamaCtrl = TextEditingController();

  String _vitesTipi = 'Otomatik';
  String _yakitTipi = 'Benzin';

  @override
  void dispose() {
    _markaCtrl.dispose();
    _modelCtrl.dispose();
    _yilCtrl.dispose();
    _fiyatCtrl.dispose();
    _sehirCtrl.dispose();
    _aciklamaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const LiquidAppBar(title: 'Yeni Araç İlanı Ekle'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCarIdentityCard(),
            const SizedBox(height: 14),
            _buildPriceAndCityCard(),
            const SizedBox(height: 14),
            _buildTransmissionAndFuelCard(),
            const SizedBox(height: 14),
            _buildDescriptionCard(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCarIdentityCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Araç Bilgileri',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _markaCtrl,
            label: 'Marka',
            hintText: 'Örn: BMW, Mercedes, Audi',
            validator: (v) => v == null || v.trim().isEmpty ? 'Marka boş bırakılamaz' : null,
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _modelCtrl,
            label: 'Model / Paket',
            hintText: 'Örn: 320i M Sport',
            validator: (v) => v == null || v.trim().isEmpty ? 'Model boş bırakılamaz' : null,
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _yilCtrl,
            label: 'Model Yılı',
            hintText: '2023',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || int.tryParse(v) == null ? 'Geçerli bir yıl giriniz' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndCityCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fiyat ve Konum',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _fiyatCtrl,
            label: 'Günlük Kira Bedeli (TL)',
            hintText: 'Örn: 3500',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.currency_lira_rounded,
            validator: (v) =>
                v == null || double.tryParse(v) == null ? 'Geçerli bir fiyat giriniz' : null,
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _sehirCtrl,
            label: 'Şehir / İlçe',
            hintText: 'İstanbul, Kadıköy',
            prefixIcon: Icons.location_on_outlined,
            validator: (v) => v == null || v.trim().isEmpty ? 'Konum boş bırakılamaz' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTransmissionAndFuelCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Teknik Detaylar',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text('Vites Tipi', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: ['Otomatik', 'Manuel'].map((vites) {
              final isSel = _vitesTipi == vites;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(vites),
                  selected: isSel,
                  selectedColor: AppColors.burgundyPrimary,
                  backgroundColor: AppColors.surfaceVariant,
                  labelStyle: TextStyle(
                    color: isSel ? AppColors.textWhite : AppColors.textSecondary,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (val) => setState(() => _vitesTipi = vites),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text('Yakıt Tipi', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Benzin', 'Dizel', 'Hibrit', 'Elektrik'].map((yakit) {
              final isSel = _yakitTipi == yakit;
              return ChoiceChip(
                label: Text(yakit),
                selected: isSel,
                selectedColor: AppColors.burgundyPrimary,
                backgroundColor: AppColors.surfaceVariant,
                labelStyle: TextStyle(
                  color: isSel ? AppColors.textWhite : AppColors.textSecondary,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                ),
                onSelected: (val) => setState(() => _yakitTipi = yakit),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: LiquidTextField(
        controller: _aciklamaCtrl,
        label: 'Açıklama & Donanım Özellikleri',
        hintText: 'Aracın bakımları, teslim şartları, ses sistemi, cam tavan vb.',
        maxLines: 3,
        validator: (v) => v == null || v.trim().isEmpty ? 'Açıklama boş bırakılamaz' : null,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return LiquidButton(
      text: 'İlanı Yayınla',
      icon: Icons.add_circle_outline,
      onPressed: _aracKaydet,
    );
  }

  void _aracKaydet() {
    if (!_formKey.currentState!.validate()) return;

    final user = AppState.userProfile.currentUser.value;
    final yeniArac = AracModel(
      id: 'arc_${DateTime.now().millisecondsSinceEpoch}',
      marka: _markaCtrl.text.trim(),
      model: _modelCtrl.text.trim(),
      yil: int.parse(_yilCtrl.text.trim()),
      gunlukFiyat: double.parse(_fiyatCtrl.text.trim()),
      vitesTipi: _vitesTipi,
      yakitTipi: _yakitTipi,
      sehir: _sehirCtrl.text.trim(),
      aciklama: _aciklamaCtrl.text.trim(),
      kirayaVerenId: user?.id ?? 'usr_veren_1',
      kirayaVerenAd: user?.adSoyad ?? 'Ahmet Yılmaz',
      kiralandiMi: false,
      begeniSayisi: 0,
      begenildiMi: false,
    );

    AppState.arac.aracEkle(yeniArac);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.burgundyPrimary,
        content: Text('Araç ilanı başarıyla yayınlandı!', style: TextStyle(color: Colors.white)),
      ),
    );

    Navigator.pop(context);
  }
}
