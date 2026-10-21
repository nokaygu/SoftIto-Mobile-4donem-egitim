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

/// Kiralayan için Araç Sahiplerini Listeleme ve Puanlama Ekranı
class KiralayanScreen extends StatefulWidget {
  const KiralayanScreen({super.key});

  @override
  State<KiralayanScreen> createState() => _KiralayanScreenState();
}

class _KiralayanScreenState extends State<KiralayanScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AppState.userProfile.currentUser.value;

    return Scaffold(
      backgroundColor: context.scaffoldColor,
      appBar: const LiquidAppBar(title: 'Kiralama Geçmişim & Araç Sahipleri'),
      body: ValueListenableBuilder<List<KiralamaKaydi>>(
        valueListenable: AppState.kiraci.kayitlarNotifier,
        builder: (context, _, child) {
          final gecmis = AppState.kiraci.getKiralamaGecmisi(currentUser?.id ?? '');

          if (gecmis.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: gecmis.length,
            itemBuilder: (context, index) {
              return _buildKiralamaCard(context, gecmis[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'Henüz bir araç kiralamadınız. Vitrinden hemen kiralayabilirsiniz!',
        textAlign: TextAlign.center,
        style: TextStyle(color: context.textMutedColor, fontSize: 14),
      ),
    );
  }

  Widget _buildKiralamaCard(BuildContext context, KiralamaKaydi kayit) {
    return LiquidGlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context, kayit),
          const SizedBox(height: 10),
          _buildRentalDetails(context, kayit),
          Divider(color: context.glassBorderColor, height: 20),
          _buildActionRow(context, kayit),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, KiralamaKaydi kayit) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.burgundyPrimary.withValues(alpha: 0.25),
          child: const Icon(Icons.car_rental_rounded, color: AppColors.burgundyLight),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kayit.aracBilgisi,
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
                'Araç Sahibi: ${kayit.kirayaVerenAd}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.textSecondaryColor, fontSize: 12),
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
            Text('Kiralama Süresi', style: TextStyle(color: context.textMutedColor, fontSize: 11)),
            Text(
              '${kayit.baslangicTarihi.day}.${kayit.baslangicTarihi.month} - ${kayit.bitisTarihi.day}.${kayit.bitisTarihi.month}.${kayit.bitisTarihi.year}',
              style: TextStyle(color: context.textSecondaryColor, fontSize: 13),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Ödenen Tutar', style: TextStyle(color: context.textMutedColor, fontSize: 11)),
            Text(
              '₺${kayit.toplamTutar.toInt()}',
              style: const TextStyle(
                color: AppColors.burgundyLight,
                fontSize: 15,
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
          child: kayit.kiralayanPuanladiMi
              ? const LiquidBadge(
                  text: 'Sahip Puanlandı ✓',
                  type: LiquidBadgeType.success,
                  icon: Icons.check,
                )
              : LiquidButton(
                  text: 'Araç Sahibini Puanla',
                  icon: Icons.star_outline_rounded,
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
                  sikayetEdilenId: kayit.kirayaVerenId,
                  sikayetEdilenAd: kayit.kirayaVerenAd,
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
    final yorumCtrl = TextEditingController(text: 'Çok güvenilir ve ilgili bir araç sahibi.');
    final etiketler = ['Mükemmel Araç', 'Zamanında Teslimat', 'Güvenilir', 'Çok İlgili'];

    showLiquidDialog(
      context: context,
      title: '${kayit.kirayaVerenAd} Değerlendir',
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
                  label: 'Araç Sahibi Hakkında Yorumunuz',
                  hintText: 'Araç vaat edildiği gibi miydi, iletişim nasıldı?',
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
              hedefKullaniciId: kayit.kirayaVerenId,
              puan: seciliPuan,
              yorumMetni: yorumCtrl.text.trim(),
              yorumYapanAd: currentUser?.adSoyad ?? 'Kiracı',
              yorumYapanId: currentUser?.id ?? '',
            );
            AppState.kiraci.markKiralayanPuanladi(kayit.id);
            Navigator.pop(context);
            await showLiquidSuccessDialog(
              context,
              title: 'Değerlendirme Kaydedildi',
              message: '${kayit.kirayaVerenAd} hakkındaki puanınız ve yorumunuz başarıyla kaydedildi.',
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
