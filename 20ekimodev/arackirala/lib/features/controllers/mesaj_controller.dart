import 'package:flutter/foundation.dart';
import '../models/mesaj_model.dart';

/// Mesajlaşma ve şikayet yönetim kontrolcüsü.
class MesajController {
  final List<SohbetModel> _sohbetler = [
    SohbetModel(
      id: 'shb_1',
      kullanici1Id: 'usr_veren_1',
      kullanici2Id: 'usr_alan_1',
      digerKullaniciAd: 'Caner Demir',
      digerKullaniciAvatar: 'directions_car',
      ilgiliAracBilgisi: 'BMW 320i M Sport (2023)',
      sonMesaj: 'Anahtarı saat 14:00 gibi teslim edebilirim, uygun mudur?',
      sonMesajZamani: DateTime.now().subtract(const Duration(minutes: 25)),
      okunmamisSayisi: 1,
      mesajlar: [
        MesajModel(
          id: 'msg_1',
          gonderenId: 'usr_alan_1',
          gonderenAd: 'Caner Demir',
          aliciId: 'usr_veren_1',
          aliciAd: 'Ahmet Yılmaz',
          metin: 'Merhaba Ahmet Bey, BMW 320i ilanınız için yazıyorum.',
          tarih: DateTime.now().subtract(const Duration(hours: 2)),
          okunduMu: true,
        ),
        MesajModel(
          id: 'msg_2',
          gonderenId: 'usr_veren_1',
          gonderenAd: 'Ahmet Yılmaz',
          aliciId: 'usr_alan_1',
          aliciAd: 'Caner Demir',
          metin: 'Merhaba Caner Bey, araç şu an temizlendi ve hazır.',
          tarih: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
          okunduMu: true,
        ),
        MesajModel(
          id: 'msg_3',
          gonderenId: 'usr_alan_1',
          gonderenAd: 'Caner Demir',
          aliciId: 'usr_veren_1',
          aliciAd: 'Ahmet Yılmaz',
          metin: 'Anahtarı saat 14:00 gibi teslim edebilirim, uygun mudur?',
          tarih: DateTime.now().subtract(const Duration(minutes: 25)),
          okunduMu: false,
        ),
      ],
    ),
  ];

  final List<SikayetModel> _sikayetler = [];

  late final ValueNotifier<List<SohbetModel>> sohbetlerNotifier;
  late final ValueNotifier<List<SikayetModel>> sikayetlerNotifier;

  MesajController() {
    sohbetlerNotifier = ValueNotifier<List<SohbetModel>>(List.unmodifiable(_sohbetler));
    sikayetlerNotifier = ValueNotifier<List<SikayetModel>>(List.unmodifiable(_sikayetler));
  }

  /// Aktif kullanıcıya ait sohbetleri döner
  List<SohbetModel> getKullaniciSohbetleri(String userId) {
    return _sohbetler.where((s) => s.kullanici1Id == userId || s.kullanici2Id == userId).toList();
  }

  /// Var olan sohbeti bul veya yeni sohbet oluştur
  SohbetModel getOrCreateSohbet({
    required String aktifUserId,
    required String digerUserId,
    required String digerUserAd,
    required String digerUserAvatar,
    String? aracBilgisi,
  }) {
    final index = _sohbetler.indexWhere(
      (s) =>
          (s.kullanici1Id == aktifUserId && s.kullanici2Id == digerUserId) ||
          (s.kullanici1Id == digerUserId && s.kullanici2Id == aktifUserId),
    );

    if (index != -1) {
      return _sohbetler[index];
    }

    final yeniSohbet = SohbetModel(
      id: 'shb_${DateTime.now().millisecondsSinceEpoch}',
      kullanici1Id: aktifUserId,
      kullanici2Id: digerUserId,
      digerKullaniciAd: digerUserAd,
      digerKullaniciAvatar: digerUserAvatar,
      ilgiliAracBilgisi: aracBilgisi,
      sonMesaj: 'Sohbet başlatıldı',
      sonMesajZamani: DateTime.now(),
      mesajlar: [],
    );

    _sohbetler.insert(0, yeniSohbet);
    sohbetlerNotifier.value = List.unmodifiable(_sohbetler);
    return yeniSohbet;
  }

  /// Sohbete yeni mesaj gönder
  void mesajGonder({
    required String sohbetId,
    required String gonderenId,
    required String gonderenAd,
    required String aliciId,
    required String aliciAd,
    required String metin,
  }) {
    if (metin.trim().isEmpty) return;

    final index = _sohbetler.indexWhere((s) => s.id == sohbetId);
    if (index == -1) return;

    final sohbet = _sohbetler[index];
    final yeniMesaj = MesajModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      gonderenId: gonderenId,
      gonderenAd: gonderenAd,
      aliciId: aliciId,
      aliciAd: aliciAd,
      metin: metin.trim(),
      tarih: DateTime.now(),
      okunduMu: true,
    );

    final guncelMesajlar = [...sohbet.mesajlar, yeniMesaj];
    _sohbetler[index] = sohbet.copyWith(
      sonMesaj: yeniMesaj.metin,
      sonMesajZamani: yeniMesaj.tarih,
      mesajlar: guncelMesajlar,
    );

    sohbetlerNotifier.value = List.unmodifiable(_sohbetler);
  }

  /// Şikayet oluştur
  void sikayetGonder(SikayetModel sikayet) {
    _sikayetler.insert(0, sikayet);
    sikayetlerNotifier.value = List.unmodifiable(_sikayetler);
  }
}
