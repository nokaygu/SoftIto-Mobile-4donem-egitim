import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_state.dart';
import '../../models/mesaj_model.dart';
import '../../widgets/liquid_app_bar.dart';
import '../../widgets/liquid_badge.dart';
import '../../widgets/liquid_glass_card.dart';
import 'mesaj_detay_ekrani.dart';
import 'sikayet_ekrani.dart';

/// Sohbet Listesi Ekranı
class MesajlarScreen extends StatelessWidget {
  const MesajlarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppState.userProfile.currentUser.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: LiquidAppBar(
        title: 'Mesajlar & İletişim',
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: AppColors.textSecondary),
            tooltip: 'Genel Şikayet Bildir',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SikayetEkrani()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<SohbetModel>>(
        valueListenable: AppState.mesaj.sohbetlerNotifier,
        builder: (context, _, child) {
          final sohbetler = AppState.mesaj.getKullaniciSohbetleri(user?.id ?? '');

          if (sohbetler.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sohbetler.length,
            itemBuilder: (context, index) {
              return _buildChatCard(context, sohbetler[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Henüz bir mesajlaşmanız bulunmuyor.\nAraç detayından araç sahibine mesaj gönderebilirsiniz.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textMuted, fontSize: 14),
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, SohbetModel sohbet) {
    return LiquidGlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MesajDetayEkrani(sohbet: sohbet)),
        );
      },
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Expanded(child: _buildChatInfo(sohbet)),
          _buildTrailing(sohbet),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.burgundyPrimary.withValues(alpha: 0.25),
      child: const Icon(Icons.person, color: AppColors.textWhite, size: 24),
    );
  }

  Widget _buildChatInfo(SohbetModel sohbet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sohbet.digerKullaniciAd,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          sohbet.sonMesaj,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        if (sohbet.ilgiliAracBilgisi != null) ...[
          const SizedBox(height: 4),
          LiquidBadge(
            text: sohbet.ilgiliAracBilgisi!,
            type: LiquidBadgeType.neutral,
            icon: Icons.directions_car,
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing(SohbetModel sohbet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${sohbet.sonMesajZamani.hour.toString().padLeft(2, '0')}:${sohbet.sonMesajZamani.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        const SizedBox(height: 6),
        const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
      ],
    );
  }
}
