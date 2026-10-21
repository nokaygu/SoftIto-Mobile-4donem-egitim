import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../controllers/kiraci_controller.dart';
import '../../models/arac_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_badge.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/liquid_dialog.dart';
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
          backgroundColor: context.scaffoldColor,
          appBar: LiquidAppBar(
            title: '${arac.marka} ${arac.model}',
            actions: [_buildLikeActionButton(arac)],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeaderImageCard(context, arac),
              const SizedBox(height: 14),
              _buildOwnerAndStatusCard(context, arac),
              const SizedBox(height: 14),
              _buildSpecsGrid(context, arac),
              const SizedBox(height: 14),
              _buildDescriptionCard(context, arac),
              const SizedBox(height: 14),
              _buildActionButtons(context, arac),
              const SizedBox(height: 18),
              _buildCommentsSection(context, arac),
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

  Widget _buildHeaderImageCard(BuildContext context, AracModel arac) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(24),
      isHighlighted: arac.begenildiMi,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.surfaceVariantColor.withValues(alpha: 0.6),
              border: Border.all(color: context.glassBorderColor),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              size: 64,
              color: AppColors.burgundyLight,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${arac.marka} ${arac.model}',
            style: TextStyle(
              color: context.textPrimaryColor,
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
              Flexible(
                child: Text(
                  arac.sehir,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.textSecondaryColor, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '• ${arac.begeniSayisi} Beğeni',
                style: TextStyle(color: context.textMutedColor, fontSize: 13),
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

  Widget _buildOwnerAndStatusCard(BuildContext context, AracModel arac) {
    final sahibi = AppState.userProfile.getUserById(arac.kirayaVerenId);
    final skor = sahibi?.skor ?? 4.9;

    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.burgundyPrimary.withValues(alpha: 0.25),
            radius: 22,
            child: const Icon(Icons.person, color: AppColors.burgundyLight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arac.kirayaVerenAd,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.textPrimaryColor,
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
                      style: TextStyle(
                        color: context.textSecondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          LiquidBadge(
            text: arac.kiralandiMi ? 'Şu an Kirada' : 'Müsait',
            type: arac.kiralandiMi ? LiquidBadgeType.warning : LiquidBadgeType.success,
            icon: arac.kiralandiMi ? Icons.lock_clock : Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsGrid(BuildContext context, AracModel arac) {
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
        childAspectRatio: 2.3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: specs.map((spec) => _buildSpecItem(context, spec.$1, spec.$2, spec.$3)).toList(),
      ),
    );
  }

  Widget _buildSpecItem(BuildContext context, String title, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.glassBorderColor),
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
                Text(title, style: TextStyle(color: context.textMutedColor, fontSize: 11)),
                Text(
                  val,
                  style: TextStyle(
                    color: context.textPrimaryColor,
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

  Widget _buildDescriptionCard(BuildContext context, AracModel arac) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Açıklama',
            style: TextStyle(
              color: context.textPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            arac.aciklama,
            style: TextStyle(
              color: context.textSecondaryColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AracModel arac) {
    final user = AppState.userProfile.currentUser.value;
    final isMyCar = user != null && user.id == arac.kirayaVerenId;
    final isRentedByMe = user != null && arac.kiralandiMi && arac.kiralayanId == user.id;

    if (isMyCar) {
      return _buildMyCarActions(context, arac);
    }
    if (isRentedByMe) {
      return _buildRentedByMeActions(context, arac);
    }
    return _buildStandardActions(context, arac);
  }

  Widget _buildMyCarActions(BuildContext context, AracModel arac) {
    if (arac.kiralandiMi) {
      return Column(
        children: [
          LiquidButton(
            text: 'Kiracı Bilgileri & Kiralama Durumu',
            icon: Icons.assignment_turned_in_rounded,
            isPrimary: true,
            onPressed: () => _showOwnerRentalInfoDialog(arac),
          ),
          const SizedBox(height: 10),
          LiquidButton(
            text: 'Kiracıya Mesaj Gönder',
            icon: Icons.chat_bubble_rounded,
            isPrimary: false,
            onPressed: () => _openChatWithTenant(arac),
          ),
        ],
      );
    }

    return Column(
      children: [
        LiquidButton(
          text: 'Bu Sizin İlanınız (Vitrinde Müsait)',
          icon: Icons.verified_user_rounded,
          isPrimary: true,
          onPressed: () => _showOwnCarInfoDialog(context, arac),
        ),
        const SizedBox(height: 10),
        LiquidButton(
          text: 'İlan Durumunu İncele',
          icon: Icons.info_outline_rounded,
          isPrimary: false,
          onPressed: () => _showOwnCarInfoDialog(context, arac),
        ),
      ],
    );
  }

  Widget _buildRentedByMeActions(BuildContext context, AracModel arac) {
    return Column(
      children: [
        LiquidButton(
          text: 'Bu Aracı Kiraladınız (Teslim Et)',
          icon: Icons.key_rounded,
          isPrimary: true,
          onPressed: () => _showReturnCarDialog(arac),
        ),
        const SizedBox(height: 10),
        LiquidButton(
          text: 'Araç Sahibine Mesaj Gönder',
          icon: Icons.chat_bubble_outline_rounded,
          isPrimary: false,
          onPressed: () => _openChatWithHost(arac),
        ),
      ],
    );
  }

  Widget _buildStandardActions(BuildContext context, AracModel arac) {
    return Column(
      children: [
        LiquidButton(
          text: arac.kiralandiMi
              ? 'Şu An Kirada (${arac.kiralayanAd ?? 'Kiracı'})'
              : 'Hemen Kirala',
          icon: arac.kiralandiMi ? Icons.lock_clock_rounded : Icons.key_rounded,
          isPrimary: !arac.kiralandiMi,
          onPressed: arac.kiralandiMi
              ? () => _showAlreadyRentedDialog(context, arac)
              : () => _showRentFormDialog(arac),
        ),
        const SizedBox(height: 10),
        LiquidButton(
          text: 'Araç Sahibine Mesaj Gönder',
          icon: Icons.chat_bubble_outline_rounded,
          isPrimary: false,
          onPressed: () => _openChatWithHost(arac),
        ),
      ],
    );
  }

  void _openChatWithTenant(AracModel arac) {
    final user = AppState.userProfile.currentUser.value;
    if (user == null || arac.kiralayanId == null) return;

    final sohbet = AppState.mesaj.getOrCreateSohbet(
      aktifUserId: user.id,
      digerUserId: arac.kiralayanId!,
      digerUserAd: arac.kiralayanAd ?? 'Kiracı',
      digerUserAvatar: 'person',
      aracBilgisi: '${arac.marka} ${arac.model} (${arac.yil})',
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MesajDetayEkrani(sohbet: sohbet)),
    );
  }

  Future<void> _showReturnCarDialog(AracModel arac) async {
    final onay = await showLiquidConfirmationDialog(
      context,
      title: 'Aracı İade Et',
      message:
          '${arac.marka} ${arac.model} aracını teslim etmek ve kiralama sürecini tamamlamak istiyor musunuz?',
      confirmText: 'Aracı Teslim Et',
      cancelText: 'Vazgeç',
    );

    if (onay == true && mounted) {
      AppState.arac.kiralamaBitir(arac.id);
      AppState.kiraci.kiralamaTamamla(arac.id);

      await showLiquidSuccessDialog(
        context,
        title: 'Araç Teslim Edildi',
        message: 'Kiralama başarıyla tamamlandı. Aracınız araç sahibine teslim edildi!',
      );
    }
  }

  Future<void> _showOwnerRentalInfoDialog(AracModel arac) async {
    final onay = await showLiquidConfirmationDialog(
      context,
      title: 'Kiralama Durumu',
      message:
          'Araç şu anda ${arac.kiralayanAd ?? 'Kiracı'} tarafından kullanılmaktadır.\nAracı teslim alarak kiralamayı sonlandırmak ister misiniz?',
      confirmText: 'Teslim Al & Bitir',
      cancelText: 'Kapat',
    );

    if (onay == true && mounted) {
      AppState.arac.kiralamaBitir(arac.id);
      AppState.kiraci.kiralamaTamamla(arac.id);

      await showLiquidSuccessDialog(
        context,
        title: 'Araç Teslim Alındı',
        message: 'Kiralama başarıyla kapatıldı. Araç vitrinde tekrar müsait duruma getirildi.',
      );
    }
  }

  void _showOwnCarInfoDialog(BuildContext context, AracModel arac) {
    showLiquidDialog(
      context: context,
      title: 'Kendi İlanınız',
      icon: Icons.verified_user_rounded,
      iconColor: AppColors.burgundyLight,
      content: Text(
        'Bu araç (${arac.marka} ${arac.model}) sizin ilanınızdır. Kendi aracınızı kiralayamaz veya kendinize mesaj gönderemezsiniz. İlanınız vitrinde diğer kullanıcıların kiralaması için aktiftir.',
        style: TextStyle(color: context.textSecondaryColor, fontSize: 14, height: 1.45),
      ),
      actions: [
        LiquidButton(
          text: 'Tamam',
          height: 42,
          isFullWidth: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _showAlreadyRentedDialog(BuildContext context, AracModel arac) {
    showLiquidDialog(
      context: context,
      title: 'Araç Şu Anda Kirada',
      icon: Icons.lock_clock_rounded,
      iconColor: AppColors.warning,
      content: Text(
        '${arac.marka} ${arac.model} şu anda ${arac.kiralayanAd ?? 'başka bir kullanıcı'} tarafından kiralanmıştır. Araç teslim edildiğinde tekrar kiralayabilirsiniz. Dilerseniz araç sahibine mesaj atarak müsaitlik tarihi hakkında bilgi alabilirsiniz.',
        style: TextStyle(color: context.textSecondaryColor, fontSize: 14, height: 1.45),
      ),
      actions: [
        LiquidButton(
          text: 'Anladım',
          height: 42,
          isFullWidth: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildCommentsSection(BuildContext context, AracModel arac) {
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
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.comment_outlined, size: 18, color: context.textSecondaryColor),
            ],
          ),
          const SizedBox(height: 12),
          if (arac.yorumlar.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Henüz yorum yapılmamış. İlk yorumu sen yap!',
                style: TextStyle(color: context.textMutedColor, fontSize: 13),
              ),
            )
          else
            ...arac.yorumlar.map((y) => _buildSingleCommentItem(context, y)),
          const SizedBox(height: 12),
          _buildAddCommentInput(arac),
        ],
      ),
    );
  }

  Widget _buildSingleCommentItem(BuildContext context, AracYorumu y) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.glassBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                y.kullaniciAdi,
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${y.tarih.day}.${y.tarih.month}.${y.tarih.year}',
                style: TextStyle(color: context.textMutedColor, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            y.yorum,
            style: TextStyle(color: context.textSecondaryColor, fontSize: 12),
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
    if (text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.burgundyPrimary,
          content: Text('Lütfen en az 3 karakterden oluşan bir yorum yazınız.'),
        ),
      );
      return;
    }

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
    FocusScope.of(context).unfocus();
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

  void _showRentFormDialog(AracModel arac) {
    final user = AppState.userProfile.currentUser.value;
    final rentFormKey = GlobalKey<FormState>();
    final surucuCtrl = TextEditingController(text: user?.adSoyad ?? '');
    final telefonCtrl = TextEditingController(text: user?.telefon ?? '');
    int gunSayisi = 3;
    bool sozlesmeOnaylandi = true;

    showLiquidDialog(
      context: context,
      title: '${arac.marka} ${arac.model} Kirala',
      icon: Icons.key_rounded,
      iconColor: AppColors.burgundyLight,
      content: StatefulBuilder(
        builder: (ctx, setDialogState) {
          final toplamTutar = arac.gunlukFiyat * gunSayisi;

          return Form(
            key: rentFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LiquidTextField(
                  controller: surucuCtrl,
                  label: 'Sürücü Adı Soyadı',
                  prefixIcon: Icons.person_outline,
                  validator: (v) => v == null || v.trim().length < 3 ? 'Ad Soyad en az 3 karakter olmalıdır' : null,
                ),
                const SizedBox(height: 10),
                LiquidTextField(
                  controller: telefonCtrl,
                  label: 'İletişim Numarası',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().length < 10 ? 'Geçerli bir telefon giriniz' : null,
                ),
                const SizedBox(height: 12),
                _buildDurationStepper(arac, gunSayisi, (val) => setDialogState(() => gunSayisi = val)),
                const Divider(height: 20),
                _buildPriceSummary(ctx, toplamTutar),
                const SizedBox(height: 8),
                _buildContractCheckbox(ctx, sozlesmeOnaylandi, (val) => setDialogState(() => sozlesmeOnaylandi = val)),
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
          text: 'Kiralamayı Onayla',
          height: 42,
          isFullWidth: false,
          onPressed: () => _handleRentSubmit(arac, rentFormKey, sozlesmeOnaylandi, gunSayisi),
        ),
      ],
    );
  }

  Widget _buildDurationStepper(AracModel arac, int gunSayisi, ValueChanged<int> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Kiralama Süresi:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 22),
              onPressed: gunSayisi > 1 ? () => onChanged(gunSayisi - 1) : null,
            ),
            Text(
              '$gunSayisi Gün',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 22),
              onPressed: gunSayisi < 30 ? () => onChanged(gunSayisi + 1) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSummary(BuildContext context, double toplamTutar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Toplam Tutar:', style: TextStyle(color: context.textSecondaryColor, fontSize: 14)),
        Text(
          '₺${toplamTutar.toInt()}',
          style: const TextStyle(
            color: AppColors.burgundyLight,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildContractCheckbox(BuildContext context, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.burgundyPrimary,
          onChanged: (v) => onChanged(v ?? false),
        ),
        Expanded(
          child: Text(
            'Kiralama ve hasar şartlarını onaylıyorum.',
            style: TextStyle(color: context.textSecondaryColor, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRentSubmit(
    AracModel arac,
    GlobalKey<FormState> formKey,
    bool sozlesmeOnaylandi,
    int gunSayisi,
  ) async {
    if (!formKey.currentState!.validate()) return;
    if (!sozlesmeOnaylandi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Lütfen kiralama şartlarını onaylayınız.'),
        ),
      );
      return;
    }

    final toplamTutar = arac.gunlukFiyat * gunSayisi;
    Navigator.pop(context);
    _confirmRent(arac, gunSayisi, toplamTutar);
  }

  Future<void> _confirmRent(AracModel arac, int gunSayisi, double toplamTutar) async {
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

      await showLiquidSuccessDialog(
        context,
        title: 'Kiralama Başarılı!',
        message:
            '${arac.marka} ${arac.model} aracı $gunSayisi günlüğüne başarıyla kiralandı.\nToplam Ödenen: ₺${toplamTutar.toInt()}',
      );
    }
  }
}
