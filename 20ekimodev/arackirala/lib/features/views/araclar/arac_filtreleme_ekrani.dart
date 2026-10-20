import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../models/arac_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_button.dart';
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
      backgroundColor: AppColors.backgroundDark,
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
          _buildBrandSelector(),
          const SizedBox(height: 14),
          _buildYearRangeCard(),
          const SizedBox(height: 14),
          _buildPriceRangeCard(),
          const SizedBox(height: 14),
          _buildGearSelector(),
          const SizedBox(height: 14),
          _buildFuelSelector(),
          const SizedBox(height: 14),
          _buildAvailabilityToggle(),
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

  Widget _buildBrandSelector() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Marka',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                label: 'Tümü',
                isSelected: _seciliMarka == null,
                onTap: () => setState(() => _seciliMarka = null),
              ),
              ..._markalar.map((marka) {
                return _buildFilterChip(
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

  Widget _buildYearRangeCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Model Yılı Aralığı',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
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

  Widget _buildPriceRangeCard() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Günlük Fiyat Aralığı (TL)',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
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

  Widget _buildGearSelector() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vites Tipi',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip(
                label: 'Tümü',
                isSelected: _seciliVites == null,
                onTap: () => setState(() => _seciliVites = null),
              ),
              ..._vitesTipleri.map((vites) {
                return _buildFilterChip(
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

  Widget _buildFuelSelector() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yakıt Tipi',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                label: 'Tümü',
                isSelected: _seciliYakit == null,
                onTap: () => setState(() => _seciliYakit = null),
              ),
              ..._yakitTipleri.map((yakit) {
                return _buildFilterChip(
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

  Widget _buildAvailabilityToggle() {
    return LiquidGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sadece Müsait Araçlar',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Şu an kirada olan araçları gizle',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          Switch(
            value: _sadeceMusaitOlanlar,
            activeThumbColor: AppColors.burgundyAccent,
            activeTrackColor: AppColors.burgundyPrimary.withValues(alpha: 0.5),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.surfaceVariant,
            onChanged: (val) => setState(() => _sadeceMusaitOlanlar = val),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
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
              : AppColors.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.burgundyAccent : AppColors.glassBorder,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
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

  void _sifirlaFiltre() {
    AppState.arac.filtreSifirla();
    Navigator.pop(context);
  }

  void _uygulaFiltre() {
    final yeniFiltre = AracFiltreModel(
      aramaKelimesi: _aramaCtrl.text.trim().isEmpty ? null : _aramaCtrl.text.trim(),
      seciliMarka: _seciliMarka,
      minYil: int.tryParse(_minYilCtrl.text.trim()),
      maxYil: int.tryParse(_maxYilCtrl.text.trim()),
      minFiyat: double.tryParse(_minFiyatCtrl.text.trim()),
      maxFiyat: double.tryParse(_maxFiyatCtrl.text.trim()),
      vitesTipi: _seciliVites,
      yakitTipi: _seciliYakit,
      sadeceMusaitOlanlar: _sadeceMusaitOlanlar,
    );

    AppState.arac.filtreUygula(yeniFiltre);
    Navigator.pop(context);
  }
}
