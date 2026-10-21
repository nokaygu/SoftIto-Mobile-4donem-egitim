import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../controllers/kiraci_controller.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_badge.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/liquid_dialog.dart';
import '../../widgets/liquid_glass_card.dart';
import '../../widgets/liquid_text_field.dart';
import '../mesajlar/sikayet_ekrani.dart';

/// Kiraya Veren için Kiracıları Listeleme ve Puanlama Ekranı
class KiraciScreen extends StatefulWidget {
  const KiraciScreen({super.key});

  @override
  State<KiraciScreen> createState() => _KiraciScreenState();
}

class _KiraciScreenState extends State<KiraciScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AppState.userProfile.currentUser.value;

    return Scaffold(
      backgroundColor: context.scaffoldColor,
      appBar: const LiquidAppBar(title: 'Kiracılarım ve Puanlama'),
      body: ValueListenableBuilder<List<KiralamaKaydi>>(
        valueListenable: AppState.kiraci.kayitlarNotifier,
        builder: (context, _, child) {
          final kiracilar = AppState.kiraci.getKiracilar(currentUser?.id ?? '');

          if (kiracilar.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kiracilar.length,
            itemBuilder: (context, index) {
              return _buildKiraciCard(context, kiracilar[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'Henüz kayıtlı bir kiracınız bulunmuyor.',
        style: TextStyle(color: context.textMutedColor, fontSize: 14),
      ),
    );
  }

  Widget _buildKiraciCard(BuildContext context, KiralamaKaydi kayit) {
    return LiquidGlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKiraciHeader(context, kayit),
          const SizedBox(height: 10),
          _buildRentalDetails(context, kayit),
          Divider(color: context.glassBorderColor, height: 20),
          _buildActionRow(context, kayit),
        ],
      ),
    );
  }

  Widget _buildKiraciHeader(BuildContext context, KiralamaKaydi kayit) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.burgundyPrimary.withValues(alpha: 0.25),
          child: const Icon(Icons.person, color: AppColors.burgundyLight),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kayit.kiralayanAd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                kayit.aracBilgisi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.burgundyLight, fontSize: 12),
              ),
            ],
          ),
        ),
        LiquidBadge(
          text: kayit.durum,
          type: kayit.durum == 'Aktif' ? LiquidBadgeType.warning : LiquidBadgeType.success,
        ),
      ],
    );
  }

  Widget _buildRentalDetails(BuildContext context, KiralamaKaydi kayit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tarih Aralığı', style: TextStyle(color: context.textMutedColor, fontSize: 11)),
            Text(
              '${kayit.baslangicTarihi.day}/${kayit.baslangicTarihi.month} - ${kayit.bitisTarihi.day}/${kayit.bitisTarihi.month}',
              style: TextStyle(color: context.textSecondaryColor, fontSize: 13),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Toplam Tutar', style: TextStyle(color: context.textMutedColor, fontSize: 11)),
            Text(
              '₺${kayit.toplamTutar.toInt()}',
              style: TextStyle(
                color: context.textPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context, KiralamaKaydi kayit) {
    return Row(
      children: [
        Expanded(
          child: kayit.kirayaVerenPuanladiMi
              ? const LiquidBadge(
                  text: 'Kiracı Puanlandı ✓',
                  type: LiquidBadgeType.success,
                  icon: Icons.check,
                )
              : LiquidButton(
                  text: 'Puanla ve Yorum Yap',
                  icon: Icons.star_rate_rounded,
                  height: 38,
                  onPressed: () => _showReviewDialog(context, kayit),
                ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Şikayet Bildir',
          icon: const Icon(Icons.report_problem_outlined, color: AppColors.error, size: 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SikayetEkrani(
                  sikayetEdilenId: kayit.kiralayanId,
                  sikayetEdilenAd: kayit.kiralayanAd,
                  aracId: kayit.aracId,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showReviewDialog(BuildContext context, KiralamaKaydi kayit) {
    double seciliPuan = 5.0;
    final reviewFormKey = GlobalKey<FormState>();
    final yorumCtrl = TextEditingController(text: 'Mükemmel bir kiracı.');
    final etiketler = ['Temiz Teslimat', 'Zamanında İade', 'Güvenilir', 'Kibar'];

    showLiquidDialog(
      context: context,
      title: '${kayit.kiralayanAd} Puanla',
      icon: Icons.star_rounded,
      iconColor: AppColors.starActive,
      content: StatefulBuilder(
        builder: (ctx, setDialogState) {
          return Form(
            key: reviewFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStarRow(seciliPuan, (p) => setDialogState(() => seciliPuan = p)),
                const SizedBox(height: 10),
                _buildTagRow(ctx, etiketler, (t) {
                  yorumCtrl.text = '${yorumCtrl.text} $t'.trim();
                }),
                const SizedBox(height: 12),
                LiquidTextField(
                  controller: yorumCtrl,
                  label: 'Yorum Metni',
                  hintText: 'Aracı temiz kullandı mı, teslimat nasıldı?',
                  maxLines: 3,
                  validator: (v) => v == null || v.trim().length < 5 ? 'Yorum en az 5 karakter olmalıdır' : null,
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('İptal', style: TextStyle(color: context.textMutedColor)),
        ),
        const SizedBox(width: 8),
        LiquidButton(
          text: 'Gönder',
          height: 40,
          isFullWidth: false,
          onPressed: () async {
            if (!reviewFormKey.currentState!.validate()) return;
            final currentUser = AppState.userProfile.currentUser.value;
            AppState.userProfile.addRatingAndReview(
              hedefKullaniciId: kayit.kiralayanId,
              puan: seciliPuan,
              yorumMetni: yorumCtrl.text.trim(),
              yorumYapanAd: currentUser?.adSoyad ?? 'Araç Sahibi',
              yorumYapanId: currentUser?.id ?? '',
            );
            AppState.kiraci.markKirayaVerenPuanladi(kayit.id);
            Navigator.pop(context);
            await showLiquidSuccessDialog(
              context,
              title: 'Değerlendirme Kaydedildi',
              message: '${kayit.kiralayanAd} hakkındaki puanınız ve yorumunuz başarıyla kaydedildi.',
            );
          },
        ),
      ],
    );
  }

  Widget _buildStarRow(double seciliPuan, ValueChanged<double> onSelect) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= seciliPuan ? Icons.star_rounded : Icons.star_border_rounded,
            color: AppColors.starActive,
            size: 32,
          ),
          onPressed: () => onSelect(starIndex.toDouble()),
        );
      }),
    );
  }

  Widget _buildTagRow(BuildContext context, List<String> etiketler, ValueChanged<String> onTag) {
    return Wrap(
      spacing: 6,
      children: etiketler.map((tag) {
        return ActionChip(
          label: Text(tag, style: const TextStyle(fontSize: 11)),
          backgroundColor: context.surfaceVariantColor,
          side: BorderSide(color: context.glassBorderColor),
          onPressed: () => onTag(tag),
        );
      }).toList(),
    );
  }
}
