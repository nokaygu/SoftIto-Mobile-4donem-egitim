import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../controllers/kiraci_controller.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_badge.dart';
import '../../widgets/liquid_button.dart';
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
      backgroundColor: AppColors.backgroundDark,
      appBar: const LiquidAppBar(title: 'Kiracılarım ve Puanlama'),
      body: ValueListenableBuilder<List<KiralamaKaydi>>(
        valueListenable: AppState.kiraci.kayitlarNotifier,
        builder: (context, _, child) {
          final kiracilar = AppState.kiraci.getKiracilar(currentUser?.id ?? '');

          if (kiracilar.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kiracilar.length,
            itemBuilder: (context, index) {
              return _buildKiraciCard(kiracilar[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Henüz kayıtlı bir kiracınız bulunmuyor.',
        style: TextStyle(color: AppColors.textMuted, fontSize: 14),
      ),
    );
  }

  Widget _buildKiraciCard(KiralamaKaydi kayit) {
    return LiquidGlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKiraciHeader(kayit),
          const SizedBox(height: 10),
          _buildRentalDetails(kayit),
          const Divider(color: AppColors.glassBorder, height: 20),
          _buildActionRow(kayit),
        ],
      ),
    );
  }

  Widget _buildKiraciHeader(KiralamaKaydi kayit) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.burgundyPrimary.withValues(alpha: 0.3),
          child: const Icon(Icons.person, color: AppColors.textWhite),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kayit.kiralayanAd,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                kayit.aracBilgisi,
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

  Widget _buildRentalDetails(KiralamaKaydi kayit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tarih Aralığı', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            Text(
              '${kayit.baslangicTarihi.day}/${kayit.baslangicTarihi.month} - ${kayit.bitisTarihi.day}/${kayit.bitisTarihi.month}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Toplam Tutar', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            Text(
              '₺${kayit.toplamTutar.toInt()}',
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionRow(KiralamaKaydi kayit) {
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
                  onPressed: () => _showReviewDialog(kayit),
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

  void _showReviewDialog(KiralamaKaydi kayit) {
    double seciliPuan = 5.0;
    final yorumCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.backgroundSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.glassBorder),
              ),
              title: Text(
                '${kayit.kiralayanAd} Puanla',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 17),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return IconButton(
                        icon: Icon(
                          starIndex <= seciliPuan ? Icons.star_rounded : Icons.star_border_rounded,
                          color: AppColors.starActive,
                          size: 32,
                        ),
                        onPressed: () {
                          setDialogState(() => seciliPuan = starIndex.toDouble());
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  LiquidTextField(
                    controller: yorumCtrl,
                    label: 'Kiracı Hakkında Yorumunuz',
                    hintText: 'Aracı temiz kullandı mı, zamanında teslim etti mi?',
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('İptal', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.burgundyPrimary),
                  onPressed: () {
                    final currentUser = AppState.userProfile.currentUser.value;
                    AppState.userProfile.addRatingAndReview(
                      hedefKullaniciId: kayit.kiralayanId,
                      puan: seciliPuan,
                      yorumMetni: yorumCtrl.text.trim().isEmpty
                          ? 'Mükemmel bir kiracı.'
                          : yorumCtrl.text.trim(),
                      yorumYapanAd: currentUser?.adSoyad ?? 'Araç Sahibi',
                      yorumYapanId: currentUser?.id ?? '',
                    );
                    AppState.kiraci.markKirayaVerenPuanladi(kayit.id);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.burgundyPrimary,
                        content: Text('Puanınız ve yorumunuz kaydedildi!'),
                      ),
                    );
                  },
                  child: const Text('Gönder', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
