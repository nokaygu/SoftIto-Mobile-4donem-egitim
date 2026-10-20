import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../models/mesaj_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_badge.dart';
import 'sikayet_ekrani.dart';

/// Anlık Mesajlaşma Detay Ekranı
class MesajDetayEkrani extends StatefulWidget {
  final SohbetModel sohbet;

  const MesajDetayEkrani({super.key, required this.sohbet});

  @override
  State<MesajDetayEkrani> createState() => _MesajDetayEkraniState();
}

class _MesajDetayEkraniState extends State<MesajDetayEkrani> {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SohbetModel>>(
      valueListenable: AppState.mesaj.sohbetlerNotifier,
      builder: (context, sohbetler, _) {
        final guncelSohbet = sohbetler.firstWhere(
          (s) => s.id == widget.sohbet.id,
          orElse: () => widget.sohbet,
        );

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: _buildAppBar(guncelSohbet),
          body: Column(
            children: [
              if (guncelSohbet.ilgiliAracBilgisi != null)
                _buildVehicleHeaderBanner(guncelSohbet.ilgiliAracBilgisi!),
              Expanded(child: _buildMessagesList(guncelSohbet)),
              _buildInputArea(guncelSohbet),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(SohbetModel sohbet) {
    final digerUserId = sohbet.kullanici1Id == AppState.userProfile.currentUser.value?.id
        ? sohbet.kullanici2Id
        : sohbet.kullanici1Id;

    return LiquidAppBar(
      title: sohbet.digerKullaniciAd,
      actions: [
        IconButton(
          icon: const Icon(Icons.report_gmailerrorred_outlined, color: AppColors.textSecondary),
          tooltip: 'Şikayet Bildir',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SikayetEkrani(
                  sikayetEdilenId: digerUserId,
                  sikayetEdilenAd: sohbet.digerKullaniciAd,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVehicleHeaderBanner(String aracBilgisi) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_car_rounded, size: 16, color: AppColors.burgundyLight),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'İlgili Araç: $aracBilgisi',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const LiquidBadge(text: 'İlan', type: LiquidBadgeType.burgundy),
        ],
      ),
    );
  }

  Widget _buildMessagesList(SohbetModel sohbet) {
    final currentUserId = AppState.userProfile.currentUser.value?.id ?? '';

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: sohbet.mesajlar.length,
      itemBuilder: (context, index) {
        final msg = sohbet.mesajlar[index];
        final isMe = msg.gonderenId == currentUserId;
        return _buildMessageBubble(msg, isMe);
      },
    );
  }

  Widget _buildMessageBubble(MesajModel msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.burgundyPrimary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: Border.all(
            color: isMe ? AppColors.burgundyAccent : AppColors.glassBorder,
            width: 1,
          ),
          boxShadow: isMe
              ? [
                  BoxShadow(
                    color: AppColors.burgundyPrimary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.metin,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${msg.tarih.hour.toString().padLeft(2, '0')}:${msg.tarih.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: isMe ? AppColors.textSecondary : AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 12, color: AppColors.textSecondary),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(SohbetModel sohbet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: TextField(
                  controller: _textCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  cursorColor: AppColors.burgundyAccent,
                  decoration: const InputDecoration(
                    hintText: 'Mesajınızı yazın...',
                    hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(sohbet),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: AppColors.burgundyPrimary,
              radius: 22,
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: AppColors.textWhite, size: 18),
                onPressed: () => _sendMessage(sohbet),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(SohbetModel sohbet) {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;

    final user = AppState.userProfile.currentUser.value;
    if (user == null) return;

    final aliciId = sohbet.kullanici1Id == user.id ? sohbet.kullanici2Id : sohbet.kullanici1Id;

    AppState.mesaj.mesajGonder(
      sohbetId: sohbet.id,
      gonderenId: user.id,
      gonderenAd: user.adSoyad,
      aliciId: aliciId,
      aliciAd: sohbet.digerKullaniciAd,
      metin: text,
    );

    _textCtrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
