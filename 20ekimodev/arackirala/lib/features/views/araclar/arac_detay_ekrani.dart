import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../controllers/kiraci_controller.dart';
import '../../models/arac_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_badge.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/liquid_glass_card.dart';
import '../../widgets/liquid_text_field.dart';
import '../mesajlar/mesaj_detay_ekrani.dart';

/// Araç Detay, Sosyal Yorumlar ve Kiralama Ekranı
class AracDetayEkrani extends StatefulWidget {
  final String aracId;

  const AracDetayEkrani({super.key, required this.aracId});

  @override
  State<AracDetayEkrani> createState() => _AracDetayEkraniState();
}

class _AracDetayEkraniState extends State<AracDetayEkrani> {
  final _yorumCtrl = TextEditingController();

  @override
  void dispose() {
    _yorumCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AracModel>>(
      valueListenable: AppState.arac.araclarListesi,
      builder: (context, araclar, _) {
        final arac = araclar.firstWhere(
          (a) => a.id == widget.aracId,
          orElse: () => AppState.arac.getAracById(widget.aracId)!,
        );

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: LiquidAppBar(
            title: '${arac.marka} ${arac.model}',
            actions: [_buildLikeActionButton(arac)],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeaderImageCard(arac),
              const SizedBox(height: 14),
              _buildOwnerAndStatusCard(arac),
              const SizedBox(height: 14),
              _buildSpecsGrid(arac),
              const SizedBox(height: 14),
              _buildDescriptionCard(arac),
              const SizedBox(height: 14),
              _buildActionButtons(arac),
              const SizedBox(height: 18),
              _buildCommentsSection(arac),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLikeActionButton(AracModel arac) {
    return IconButton(
      icon: Icon(
        arac.begenildiMi ? Icons.favorite : Icons.favorite_border,
        color: arac.begenildiMi ? AppColors.heartActive : AppColors.textSecondary,
      ),
      onPressed: () => AppState.arac.toggleLike(arac.id),
    );
  }

  Widget _buildHeaderImageCard(AracModel arac) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(24),
      isHighlighted: arac.begenildiMi,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant.withValues(alpha: 0.6),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              size: 64,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${arac.marka} ${arac.model}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColors.burgundyLight),
              const SizedBox(width: 4),
              Text(
                arac.sehir,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(width: 12),
              Text(
                '• ${arac.begeniSayisi} Beğeni',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '₺${arac.gunlukFiyat.toInt()} / gün',
            style: const TextStyle(
              color: AppColors.burgundyLight,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerAndStatusCard(AracModel arac) {
    final sahibi = AppState.userProfile.getUserById(arac.kirayaVerenId);
    final skor = sahibi?.skor ?? 4.9;

    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.burgundyPrimary.withValues(alpha: 0.3),
            radius: 22,
            child: const Icon(Icons.person, color: AppColors.textWhite),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arac.kirayaVerenAd,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.starActive),
                    const SizedBox(width: 4),
                    Text(
                      '$skor Güven Skoru',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          LiquidBadge(
            text: arac.kiralandiMi ? 'Şu an Kirada' : 'Müsait',
            type: arac.kiralandiMi ? LiquidBadgeType.warning : LiquidBadgeType.success,
            icon: arac.kiralandiMi ? Icons.lock_clock : Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsGrid(AracModel arac) {
    final specs = [
      ('Model Yılı', '${arac.yil}', Icons.calendar_today_rounded),
      ('Vites', arac.vitesTipi, Icons.settings_rounded),
      ('Yakıt', arac.yakitTipi, Icons.local_gas_station_rounded),
      ('Durum', arac.kiralandiMi ? 'Kirada' : 'Hazır', Icons.verified_user_rounded),
    ];

    return LiquidGlassCard(
      padding: const EdgeInsets.all(14),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: specs.map((spec) => _buildSpecItem(spec.$1, spec.$2, spec.$3)).toList(),
      ),
    );
  }

  Widget _buildSpecItem(String title, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.burgundyLight),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                Text(
                  val,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(AracModel arac) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Açıklama',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            arac.aciklama,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AracModel arac) {
    final user = AppState.userProfile.currentUser.value;
    final isMyCar = user?.id == arac.kirayaVerenId;

    return Column(
      children: [
        LiquidButton(
          text: arac.kiralandiMi ? 'Şu An Kirada (${arac.kiralayanAd ?? 'Kiracı'})' : 'Hemen Kirala',
          icon: arac.kiralandiMi ? Icons.lock : Icons.key_rounded,
          isPrimary: !arac.kiralandiMi,
          onPressed: arac.kiralandiMi || isMyCar ? null : () => _showRentDialog(arac),
        ),
        const SizedBox(height: 10),
        LiquidButton(
          text: 'Araç Sahibine Mesaj Gönder',
          icon: Icons.chat_bubble_outline_rounded,
          isPrimary: false,
          onPressed: isMyCar ? null : () => _openChatWithHost(arac),
        ),
      ],
    );
  }

  Widget _buildCommentsSection(AracModel arac) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Yorumlar (${arac.yorumlar.length})',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.comment_outlined, size: 18, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          if (arac.yorumlar.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Henüz yorum yapılmamış. İlk yorumu sen yap!',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            )
          else
            ...arac.yorumlar.map(_buildSingleCommentItem),
          const SizedBox(height: 12),
          _buildAddCommentInput(arac),
        ],
      ),
    );
  }

  Widget _buildSingleCommentItem(AracYorumu y) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                y.kullaniciAdi,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${y.tarih.day}.${y.tarih.month}.${y.tarih.year}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            y.yorum,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentInput(AracModel arac) {
    return Row(
      children: [
        Expanded(
          child: LiquidTextField(
            controller: _yorumCtrl,
            label: 'Yorum Yaz',
            hintText: 'Araç hakkında düşünceleriniz...',
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 22),
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.burgundyPrimary,
              foregroundColor: AppColors.textWhite,
            ),
            icon: const Icon(Icons.send_rounded, size: 20),
            onPressed: () => _submitComment(arac),
          ),
        ),
      ],
    );
  }

  void _submitComment(AracModel arac) {
    final text = _yorumCtrl.text.trim();
    if (text.isEmpty) return;

    final user = AppState.userProfile.currentUser.value;
    final yeniYorum = AracYorumu(
      id: 'ay_${DateTime.now().millisecondsSinceEpoch}',
      kullaniciId: user?.id ?? 'usr_alan_1',
      kullaniciAdi: user?.adSoyad ?? 'Caner Demir',
      yorum: text,
      tarih: DateTime.now(),
    );

    AppState.arac.yorumEkle(arac.id, yeniYorum);
    _yorumCtrl.clear();
  }

  void _openChatWithHost(AracModel arac) {
    final user = AppState.userProfile.currentUser.value;
    if (user == null) return;

    final sohbet = AppState.mesaj.getOrCreateSohbet(
      aktifUserId: user.id,
      digerUserId: arac.kirayaVerenId,
      digerUserAd: arac.kirayaVerenAd,
      digerUserAvatar: 'directions_car',
      aracBilgisi: '${arac.marka} ${arac.model} (${arac.yil})',
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MesajDetayEkrani(sohbet: sohbet)),
    );
  }

  void _showRentDialog(AracModel arac) {
    int gunSayisi = 3;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final toplamTutar = arac.gunlukFiyat * gunSayisi;
            return AlertDialog(
              backgroundColor: AppColors.backgroundSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.glassBorder),
              ),
              title: Text(
                '${arac.marka} ${arac.model} Kirala',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Günlük Ücret: ₺${arac.gunlukFiyat.toInt()}'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kiralama Süresi:', style: TextStyle(color: AppColors.textSecondary)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.textWhite),
                            onPressed: gunSayisi > 1
                                ? () => setDialogState(() => gunSayisi--)
                                : null,
                          ),
                          Text(
                            '$gunSayisi Gün',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.textWhite),
                            onPressed: () => setDialogState(() => gunSayisi++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.glassBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Toplam Tutar:', style: TextStyle(color: AppColors.textSecondary)),
                      Text(
                        '₺${toplamTutar.toInt()}',
                        style: const TextStyle(
                          color: AppColors.burgundyLight,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
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
                    Navigator.pop(ctx);
                    _confirmRent(arac, gunSayisi, toplamTutar);
                  },
                  child: const Text('Kiralamayı Onayla', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmRent(AracModel arac, int gunSayisi, double toplamTutar) {
    final user = AppState.userProfile.currentUser.value;
    if (user == null) return;

    final basari = AppState.arac.kirala(
      aracId: arac.id,
      kiralayanId: user.id,
      kiralayanAd: user.adSoyad,
    );

    if (basari) {
      final kayit = KiralamaKaydi(
        id: 'krl_${DateTime.now().millisecondsSinceEpoch}',
        aracId: arac.id,
        aracBilgisi: '${arac.marka} ${arac.model} (${arac.yil})',
        kirayaVerenId: arac.kirayaVerenId,
        kirayaVerenAd: arac.kirayaVerenAd,
        kiralayanId: user.id,
        kiralayanAd: user.adSoyad,
        baslangicTarihi: DateTime.now(),
        bitisTarihi: DateTime.now().add(Duration(days: gunSayisi)),
        toplamTutar: toplamTutar,
        durum: 'Aktif',
      );

      AppState.kiraci.yeniKiralamaEkle(kayit);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.burgundyPrimary,
          content: Text('${arac.marka} başarıyla kiralandı!'),
        ),
      );
    }
  }
}
