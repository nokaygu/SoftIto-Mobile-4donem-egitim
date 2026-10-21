import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../models/arac_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/liquid_dialog.dart';
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
      backgroundColor: context.scaffoldColor,
      appBar: const LiquidAppBar(title: 'Yeni Araç İlanı Ekle'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCarIdentityCard(context),
            const SizedBox(height: 14),
            _buildPriceAndCityCard(context),
            const SizedBox(height: 14),
            _buildTransmissionAndFuelCard(context),
            const SizedBox(height: 14),
            _buildDescriptionCard(context),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCarIdentityCard(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Araç Bilgileri',
            style: TextStyle(color: context.textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _markaCtrl,
            label: 'Marka',
            hintText: 'Örn: BMW, Mercedes, Audi',
            validator: (v) => v == null || v.trim().length < 2 ? 'Marka en az 2 karakter olmalıdır' : null,
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _modelCtrl,
            label: 'Model / Paket',
            hintText: 'Örn: 320i M Sport',
            validator: (v) => v == null || v.trim().length < 2 ? 'Model en az 2 karakter olmalıdır' : null,
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _yilCtrl,
            label: 'Model Yılı',
            hintText: '2023',
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || int.tryParse(v) == null) {
                return 'Geçerli bir yıl giriniz';
              }
              final yil = int.parse(v);
              if (yil < 1980 || yil > 2027) {
                return 'Yıl 1980 ile 2027 arasında olmalıdır';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndCityCard(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fiyat ve Konum',
            style: TextStyle(color: context.textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _fiyatCtrl,
            label: 'Günlük Kira Bedeli (TL)',
            hintText: 'Örn: 3500',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.currency_lira_rounded,
            validator: (v) {
              if (v == null || double.tryParse(v) == null) {
                return 'Geçerli bir fiyat giriniz';
              }
              if (double.parse(v) < 100) {
                return 'Minimum günlük fiyat ₺100 olmalıdır';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          LiquidTextField(
            controller: _sehirCtrl,
            label: 'Şehir / İlçe',
            hintText: 'İstanbul, Kadıköy',
            prefixIcon: Icons.location_on_outlined,
            validator: (v) => v == null || v.trim().length < 3 ? 'Konum en az 3 karakter olmalıdır' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTransmissionAndFuelCard(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teknik Detaylar',
            style: TextStyle(color: context.textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text('Vites Tipi', style: TextStyle(color: context.textSecondaryColor, fontSize: 13)),
          const SizedBox(height: 8),
          _buildChoiceRow(['Otomatik', 'Manuel'], _vitesTipi, (v) => setState(() => _vitesTipi = v)),
          const SizedBox(height: 12),
          Text('Yakıt Tipi', style: TextStyle(color: context.textSecondaryColor, fontSize: 13)),
          const SizedBox(height: 8),
          _buildChoiceWrap(['Benzin', 'Dizel', 'Hibrit', 'Elektrik'], _yakitTipi, (v) => setState(() => _yakitTipi = v)),
        ],
      ),
    );
  }

  Widget _buildChoiceRow(List<String> items, String selected, ValueChanged<String> onSelected) {
    return Row(
      children: items.map((val) {
        final isSel = selected == val;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ChoiceChip(
            label: Text(val),
            selected: isSel,
            selectedColor: AppColors.burgundyPrimary,
            backgroundColor: context.surfaceVariantColor,
            labelStyle: TextStyle(
              color: isSel ? AppColors.textWhite : context.textSecondaryColor,
              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
            ),
            onSelected: (_) => onSelected(val),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChoiceWrap(List<String> items, String selected, ValueChanged<String> onSelected) {
    return Wrap(
      spacing: 8,
      children: items.map((val) {
        final isSel = selected == val;
        return ChoiceChip(
          label: Text(val),
          selected: isSel,
          selectedColor: AppColors.burgundyPrimary,
          backgroundColor: context.surfaceVariantColor,
          labelStyle: TextStyle(
            color: isSel ? AppColors.textWhite : context.textSecondaryColor,
            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
          ),
          onSelected: (_) => onSelected(val),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: LiquidTextField(
        controller: _aciklamaCtrl,
        label: 'Açıklama & Donanım Özellikleri',
        hintText: 'Aracın bakımları, teslim şartları, ses sistemi, cam tavan vb.',
        maxLines: 3,
        validator: (v) => v == null || v.trim().length < 10 ? 'Açıklama en az 10 karakter olmalıdır' : null,
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

  Future<void> _aracKaydet() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showLiquidConfirmationDialog(
      context,
      title: 'İlanı Yayınla',
      message:
          '${_markaCtrl.text.trim()} ${_modelCtrl.text.trim()} aracınız günlük ₺${_fiyatCtrl.text.trim()} bedel ile vitrinde yayınlanacaktır. Onaylıyor musunuz?',
      confirmText: 'Yayınla',
      icon: Icons.add_circle_outline_rounded,
    );

    if (confirmed != true) return;

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

    if (!mounted) return;

    await showLiquidSuccessDialog(
      context,
      title: 'İlanınız Yayında!',
      message:
          '${_markaCtrl.text.trim()} ${_modelCtrl.text.trim()} başarıyla vitrine eklendi. Diğer kullanıcılar aracınızı kiralayabilir.',
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
