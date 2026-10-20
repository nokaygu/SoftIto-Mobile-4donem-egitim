/// Tekil bir sohbet mesajı
class MesajModel {
  final String id;
  final String gonderenId;
  final String gonderenAd;
  final String aliciId;
  final String aliciAd;
  final String metin;
  final DateTime tarih;
  final bool okunduMu;

  const MesajModel({
    required this.id,
    required this.gonderenId,
    required this.gonderenAd,
    required this.aliciId,
    required this.aliciAd,
    required this.metin,
    required this.tarih,
    this.okunduMu = false,
  });

  MesajModel copyWith({
    String? id,
    String? gonderenId,
    String? gonderenAd,
    String? aliciId,
    String? aliciAd,
    String? metin,
    DateTime? tarih,
    bool? okunduMu,
  }) {
    return MesajModel(
      id: id ?? this.id,
      gonderenId: gonderenId ?? this.gonderenId,
      gonderenAd: gonderenAd ?? this.gonderenAd,
      aliciId: aliciId ?? this.aliciId,
      aliciAd: aliciAd ?? this.aliciAd,
      metin: metin ?? this.metin,
      tarih: tarih ?? this.tarih,
      okunduMu: okunduMu ?? this.okunduMu,
    );
  }
}

/// Sohbet odası / oturumu modeli
class SohbetModel {
  final String id;
  final String kullanici1Id;
  final String kullanici2Id;
  final String digerKullaniciAd;
  final String digerKullaniciAvatar;
  final String? ilgiliAracBilgisi;
  final String sonMesaj;
  final DateTime sonMesajZamani;
  final int okunmamisSayisi;
  final List<MesajModel> mesajlar;

  const SohbetModel({
    required this.id,
    required this.kullanici1Id,
    required this.kullanici2Id,
    required this.digerKullaniciAd,
    required this.digerKullaniciAvatar,
    this.ilgiliAracBilgisi,
    required this.sonMesaj,
    required this.sonMesajZamani,
    this.okunmamisSayisi = 0,
    this.mesajlar = const [],
  });

  SohbetModel copyWith({
    String? id,
    String? kullanici1Id,
    String? kullanici2Id,
    String? digerKullaniciAd,
    String? digerKullaniciAvatar,
    String? ilgiliAracBilgisi,
    String? sonMesaj,
    DateTime? sonMesajZamani,
    int? okunmamisSayisi,
    List<MesajModel>? mesajlar,
  }) {
    return SohbetModel(
      id: id ?? this.id,
      kullanici1Id: kullanici1Id ?? this.kullanici1Id,
      kullanici2Id: kullanici2Id ?? this.kullanici2Id,
      digerKullaniciAd: digerKullaniciAd ?? this.digerKullaniciAd,
      digerKullaniciAvatar: digerKullaniciAvatar ?? this.digerKullaniciAvatar,
      ilgiliAracBilgisi: ilgiliAracBilgisi ?? this.ilgiliAracBilgisi,
      sonMesaj: sonMesaj ?? this.sonMesaj,
      sonMesajZamani: sonMesajZamani ?? this.sonMesajZamani,
      okunmamisSayisi: okunmamisSayisi ?? this.okunmamisSayisi,
      mesajlar: mesajlar ?? this.mesajlar,
    );
  }
}

/// Şikayet ve Güven Bildirimi modeli
class SikayetModel {
  final String id;
  final String sikayetEdenId;
  final String sikayetEdenAd;
  final String sikayetEdilenId;
  final String sikayetEdilenAd;
  final String? aracId;
  final String baslik;
  final String aciklama;
  final String durum; // 'İnceleniyor', 'Sonuçlandırıldı'
  final DateTime tarih;

  const SikayetModel({
    required this.id,
    required this.sikayetEdenId,
    required this.sikayetEdenAd,
    required this.sikayetEdilenId,
    required this.sikayetEdilenAd,
    this.aracId,
    required this.baslik,
    required this.aciklama,
    this.durum = 'İnceleniyor',
    required this.tarih,
  });

  SikayetModel copyWith({
    String? id,
    String? sikayetEdenId,
    String? sikayetEdenAd,
    String? sikayetEdilenId,
    String? sikayetEdilenAd,
    String? aracId,
    String? baslik,
    String? aciklama,
    String? durum,
    DateTime? tarih,
  }) {
    return SikayetModel(
      id: id ?? this.id,
      sikayetEdenId: sikayetEdenId ?? this.sikayetEdenId,
      sikayetEdenAd: sikayetEdenAd ?? this.sikayetEdenAd,
      sikayetEdilenId: sikayetEdilenId ?? this.sikayetEdilenId,
      sikayetEdilenAd: sikayetEdilenAd ?? this.sikayetEdilenAd,
      aracId: aracId ?? this.aracId,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      durum: durum ?? this.durum,
      tarih: tarih ?? this.tarih,
    );
  }
}
