import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../models/arac_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_badge.dart';
import '../../widgets/liquid_glass_card.dart';
import 'arac_detay_ekrani.dart';
import 'arac_ekleme_ekrani.dart';
import 'arac_filtreleme_ekrani.dart';

/// Araç Vitrini ve Sosyal Beğeni Akışı
class AraclarScreen extends StatelessWidget {
  const AraclarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldColor,
      appBar: LiquidAppBar(
        title: 'Vites Araç Vitrini',
        actions: [
          _buildFilterButton(context),
          _buildAddCarButton(context),
        ],
      ),
      body: Column(
        children: [
          _buildActiveFilterBanner(context),
          Expanded(child: _buildCarList()),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return ValueListenableBuilder<AracFiltreModel>(
      valueListenable: AppState.arac.aktifFiltre,
      builder: (context, filtre, _) {
        final hasActiveFilter = filtre.isActive;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.tune_rounded,
                color: hasActiveFilter ? AppColors.burgundyLight : context.textPrimaryColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AracFiltrelemeEkrani()),
                );
              },
            ),
            if (hasActiveFilter)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.burgundyAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAddCarButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_circle_outline_rounded, color: context.textPrimaryColor),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AracEklemeEkrani()),
        );
      },
    );
  }

  Widget _buildActiveFilterBanner(BuildContext context) {
    return ValueListenableBuilder<AracFiltreModel>(
      valueListenable: AppState.arac.aktifFiltre,
      builder: (context, filtre, _) {
        if (!filtre.isActive) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.burgundyPrimary.withValues(alpha: 0.2),
          child: Row(
            children: [
              const Icon(Icons.filter_alt, size: 16, color: AppColors.burgundyLight),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Filtreler aktif',
                  style: TextStyle(color: context.textPrimaryColor, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              GestureDetector(
                onTap: () => AppState.arac.filtreSifirla(),
                child: const Text(
                  'Temizle',
                  style: TextStyle(color: AppColors.burgundyLight, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCarList() {
    return ValueListenableBuilder<List<AracModel>>(
      valueListenable: AppState.arac.araclarListesi,
      builder: (context, araclar, _) {
        if (araclar.isEmpty) {
          return Center(
            child: Text(
              'Arama kriterlerine uygun araç bulunamadı.',
              style: TextStyle(color: context.textMutedColor, fontSize: 14),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: araclar.length,
          itemBuilder: (context, index) {
            return _buildCarCard(context, araclar[index]);
          },
        );
      },
    );
  }

  Widget _buildCarCard(BuildContext context, AracModel arac) {
    return LiquidGlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      isHighlighted: arac.begenildiMi,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AracDetayEkrani(aracId: arac.id)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(arac),
          const SizedBox(height: 12),
          _buildCarTitle(context, arac),
          const SizedBox(height: 8),
          _buildSpecsRow(context, arac),
          Divider(color: context.glassBorderColor, height: 24),
          _buildCardFooter(context, arac),
        ],
      ),
    );
  }

  Widget _buildCardHeader(AracModel arac) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.burgundyLight),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  arac.sehir,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        LiquidBadge(
          text: arac.kiralandiMi ? 'Kirada (${arac.kiralayanAd ?? 'Kiracı'})' : 'Müsait',
          type: arac.kiralandiMi ? LiquidBadgeType.warning : LiquidBadgeType.success,
          icon: arac.kiralandiMi ? Icons.lock_clock : Icons.check_circle_rounded,
        ),
      ],
    );
  }

  Widget _buildCarTitle(BuildContext context, AracModel arac) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: context.surfaceVariantColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.glassBorderColor),
          ),
          child: const Icon(
            Icons.directions_car_rounded,
            color: AppColors.burgundyLight,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${arac.marka} ${arac.model}',
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Model Yılı: ${arac.yil}',
                style: TextStyle(color: context.textMutedColor, fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          '₺${arac.gunlukFiyat.toInt()}',
          style: const TextStyle(
            color: AppColors.burgundyLight,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecsRow(BuildContext context, AracModel arac) {
    return Row(
      children: [
        _buildSpecChip(context, Icons.settings_suggest_rounded, arac.vitesTipi),
        const SizedBox(width: 8),
        _buildSpecChip(context, Icons.local_gas_station_rounded, arac.yakitTipi),
        const Spacer(),
        Text('/ gün', style: TextStyle(color: context.textMutedColor, fontSize: 12)),
      ],
    );
  }

  Widget _buildSpecChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.glassBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: context.textSecondaryColor),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: context.textSecondaryColor, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildCardFooter(BuildContext context, AracModel arac) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => AppState.arac.toggleLike(arac.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      arac.begenildiMi ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: arac.begenildiMi ? AppColors.heartActive : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${arac.begeniSayisi}',
                      style: TextStyle(
                        color: arac.begenildiMi ? AppColors.heartActive : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Row(
              children: [
                const Icon(Icons.mode_comment_outlined, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${arac.yorumlar.length}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'İncele',
              style: TextStyle(
                color: arac.begenildiMi ? AppColors.burgundyLight : context.textPrimaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: arac.begenildiMi ? AppColors.burgundyLight : context.textPrimaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
