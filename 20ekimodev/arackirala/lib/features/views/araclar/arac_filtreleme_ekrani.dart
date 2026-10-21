import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../models/arac_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/liquid_dialog.dart';
import '../../widgets/liquid_glass_card.dart';
import '../../widgets/liquid_text_field.dart';

/// Sahibinden Tarzı Detaylı Araç Filtreleme Ekranı
class AracFiltrelemeEkrani extends StatefulWidget {
  const AracFiltrelemeEkrani({super.key});

  @override
  State<AracFiltrelemeEkrani> createState() => _AracFiltrelemeEkraniState();
}

class _AracFiltrelemeEkraniState extends State<AracFiltrelemeEkrani> {
  final _markalar = const ['BMW', 'Mercedes-Benz', 'Audi', 'Porsche', 'Volvo'];
  final _vitesTipleri = const ['Otomatik', 'Manuel'];
  final _yakitTipleri = const ['Benzin', 'Dizel', 'Hibrit', 'Elektrik'];

  late TextEditingController _aramaCtrl;
  late TextEditingController _minYilCtrl;
  late TextEditingController _maxYilCtrl;
  late TextEditingController _minFiyatCtrl;
  late TextEditingController _maxFiyatCtrl;

  String? _seciliMarka;
  String? _seciliVites;
  String? _seciliYakit;
  bool _sadeceMusaitOlanlar = false;

  @override
  void initState() {
    super.initState();
    final f = AppState.arac.aktifFiltre.value;
    _aramaCtrl = TextEditingController(text: f.aramaKelimesi ?? '');
    _minYilCtrl = TextEditingController(text: f.minYil?.toString() ?? '');
    _maxYilCtrl = TextEditingController(text: f.maxYil?.toString() ?? '');
    _minFiyatCtrl =
        TextEditingController(text: f.minFiyat != null ? f.minFiyat!.toInt().toString() : '');
    _maxFiyatCtrl =
        TextEditingController(text: f.maxFiyat != null ? f.maxFiyat!.toInt().toString() : '');
    _seciliMarka = f.seciliMarka;
    _seciliVites = f.vitesTipi;
    _seciliYakit = f.yakitTipi;
    _sadeceMusaitOlanlar = f.sadeceMusaitOlanlar;
  }

  @override
  void dispose() {
    _aramaCtrl.dispose();
    _minYilCtrl.dispose();
    _maxYilCtrl.dispose();
    _minFiyatCtrl.dispose();
    _maxFiyatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldColor,
      appBar: LiquidAppBar(
        title: 'Detaylı Filtreleme',
        actions: [
          TextButton(
            onPressed: _sifirlaFiltre,
            child: const Text(
              'Sıfırla',
              style: TextStyle(color: AppColors.burgundyLight, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchCard(),
          const SizedBox(height: 14),
          _buildBrandSelector(context),
          const SizedBox(height: 14),
          _buildYearRangeCard(context),
          const SizedBox(height: 14),
          _buildPriceRangeCard(context),
          const SizedBox(height: 14),
          _buildGearSelector(context),
          const SizedBox(height: 14),
          _buildFuelSelector(context),
          const SizedBox(height: 14),
          _buildAvailabilityToggle(context),
          const SizedBox(height: 24),
          _buildApplyButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: LiquidTextField(
        controller: _aramaCtrl,
        label: 'Arama Kelimesi',
        hintText: 'Örn: Kadıköy, RS6, Spor...',
        prefixIcon: Icons.search,
      ),
    );
  }

  Widget _buildBrandSelector(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Marka',
            style: TextStyle(color: context.textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                context: context,
                label: 'Tümü',
                isSelected: _seciliMarka == null,
                onTap: () => setState(() => _seciliMarka = null),
              ),
              ..._markalar.map((marka) {
                return _buildFilterChip(
                  context: context,
                  label: marka,
                  isSelected: _seciliMarka == marka,
                  onTap: () => setState(() {
                    _seciliMarka = _seciliMarka == marka ? null : marka;
                  }),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYearRangeCard(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Model Yılı Aralığı',
            style: TextStyle(color: context.textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LiquidTextField(
                  controller: _minYilCtrl,
                  label: 'Min Yıl',
                  hintText: '2015',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LiquidTextField(
                  controller: _maxYilCtrl,
                  label: 'Max Yıl',
                  hintText: '2025',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeCard(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Günlük Fiyat Aralığı (TL)',
            style: TextStyle(color: context.textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LiquidTextField(
                  controller: _minFiyatCtrl,
                  label: 'Min Fiyat',
                  hintText: '1000',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LiquidTextField(
                  controller: _maxFiyatCtrl,
                  label: 'Max Fiyat',
                  hintText: '10000',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGearSelector(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vites Tipi',
            style: TextStyle(color: context.textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip(
                context: context,
                label: 'Tümü',
                isSelected: _seciliVites == null,
                onTap: () => setState(() => _seciliVites = null),
              ),
              ..._vitesTipleri.map((vites) {
                return _buildFilterChip(
                  context: context,
                  label: vites,
                  isSelected: _seciliVites == vites,
                  onTap: () => setState(() {
                    _seciliVites = _seciliVites == vites ? null : vites;
                  }),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFuelSelector(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yakıt Tipi',
            style: TextStyle(color: context.textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                context: context,
                label: 'Tümü',
                isSelected: _seciliYakit == null,
                onTap: () => setState(() => _seciliYakit = null),
              ),
              ..._yakitTipleri.map((yakit) {
                return _buildFilterChip(
                  context: context,
                  label: yakit,
                  isSelected: _seciliYakit == yakit,
                  onTap: () => setState(() {
                    _seciliYakit = _seciliYakit == yakit ? null : yakit;
                  }),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityToggle(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sadece Müsait Araçlar',
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Şu an kirada olan araçları gizle',
                style: TextStyle(color: context.textMutedColor, fontSize: 12),
              ),
            ],
          ),
          Switch(
            value: _sadeceMusaitOlanlar,
            activeThumbColor: AppColors.burgundyAccent,
            activeTrackColor: AppColors.burgundyPrimary.withValues(alpha: 0.5),
            inactiveThumbColor: context.textSecondaryColor,
            inactiveTrackColor: context.surfaceVariantColor,
            onChanged: (val) => setState(() => _sadeceMusaitOlanlar = val),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.burgundyPrimary
              : context.surfaceVariantColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.burgundyAccent : context.glassBorderColor,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.textWhite : context.textSecondaryColor,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return LiquidButton(
      text: 'Filtreleri Uygula',
      icon: Icons.check_circle_outline,
      onPressed: _uygulaFiltre,
    );
  }

  Future<void> _sifirlaFiltre() async {
    final f = AppState.arac.aktifFiltre.value;
    if (f.isActive) {
      final confirmed = await showLiquidConfirmationDialog(
        context,
        title: 'Filtreleri Sıfırla',
        message: 'Tüm filtre kriterleri temizlenecektir. Devam etmek istiyor musunuz?',
        confirmText: 'Sıfırla',
      );
      if (confirmed != true) return;
    }

    AppState.arac.filtreSifirla();
    if (mounted) Navigator.pop(context);
  }

  void _uygulaFiltre() {
    final minYil = int.tryParse(_minYilCtrl.text.trim());
    final maxYil = int.tryParse(_maxYilCtrl.text.trim());
    if (minYil != null && maxYil != null && minYil > maxYil) {
      _showWarningSnackBar('Minimum model yılı maksimum yıldan büyük olamaz.');
      return;
    }

    final minFiyat = double.tryParse(_minFiyatCtrl.text.trim());
    final maxFiyat = double.tryParse(_maxFiyatCtrl.text.trim());
    if (minFiyat != null && maxFiyat != null && minFiyat > maxFiyat) {
      _showWarningSnackBar('Minimum fiyat maksimum fiyattan büyük olamaz.');
      return;
    }

    final yeniFiltre = AracFiltreModel(
      aramaKelimesi: _aramaCtrl.text.trim().isEmpty ? null : _aramaCtrl.text.trim(),
      seciliMarka: _seciliMarka,
      minYil: minYil,
      maxYil: maxYil,
      minFiyat: minFiyat,
      maxFiyat: maxFiyat,
      vitesTipi: _seciliVites,
      yakitTipi: _seciliYakit,
      sadeceMusaitOlanlar: _sadeceMusaitOlanlar,
    );

    AppState.arac.filtreUygula(yeniFiltre);
    Navigator.pop(context);
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.error,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
