/// Araç üzerindeki sosyal kullanıcı yorumu
class AracYorumu {
  final String id;
  final String kullaniciId;
  final String kullaniciAdi;
  final String yorum;
  final DateTime tarih;

  const AracYorumu({
    required this.id,
    required this.kullaniciId,
    required this.kullaniciAdi,
    required this.yorum,
    required this.tarih,
  });

  AracYorumu copyWith({
    String? id,
    String? kullaniciId,
    String? kullaniciAdi,
    String? yorum,
    DateTime? tarih,
  }) {
    return AracYorumu(
      id: id ?? this.id,
      kullaniciId: kullaniciId ?? this.kullaniciId,
      kullaniciAdi: kullaniciAdi ?? this.kullaniciAdi,
      yorum: yorum ?? this.yorum,
      tarih: tarih ?? this.tarih,
    );
  }
}

/// Araç veri modeli (Immutable)
class AracModel {
  final String id;
  final String marka;
  final String model;
  final int yil;
  final double gunlukFiyat;
  final String vitesTipi; // Otomatik, Manuel
  final String yakitTipi; // Benzin, Dizel, Hibrit, Elektrik
  final String sehir;
  final String aciklama;
  final String kirayaVerenId;
  final String kirayaVerenAd;
  final bool kiralandiMi;
  final String? kiralayanId;
  final String? kiralayanAd;
  final int begeniSayisi;
  final bool begenildiMi;
  final List<AracYorumu> yorumlar;
  final String sembolikIkon; // Arabanın tipini temsil eden ikon anahtarı

  const AracModel({
    required this.id,
    required this.marka,
    required this.model,
    required this.yil,
    required this.gunlukFiyat,
    required this.vitesTipi,
    required this.yakitTipi,
    required this.sehir,
    required this.aciklama,
    required this.kirayaVerenId,
    required this.kirayaVerenAd,
    this.kiralandiMi = false,
    this.kiralayanId,
    this.kiralayanAd,
    this.begeniSayisi = 0,
    this.begenildiMi = false,
    this.yorumlar = const [],
    this.sembolikIkon = 'car',
  });

  String get tamAd => '$marka $model ($yil)';

  AracModel copyWith({
    String? id,
    String? marka,
    String? model,
    int? yil,
    double? gunlukFiyat,
    String? vitesTipi,
    String? yakitTipi,
    String? sehir,
    String? aciklama,
    String? kirayaVerenId,
    String? kirayaVerenAd,
    bool? kiralandiMi,
    String? kiralayanId,
    String? kiralayanAd,
    int? begeniSayisi,
    bool? begenildiMi,
    List<AracYorumu>? yorumlar,
    String? sembolikIkon,
  }) {
    return AracModel(
      id: id ?? this.id,
      marka: marka ?? this.marka,
      model: model ?? this.model,
      yil: yil ?? this.yil,
      gunlukFiyat: gunlukFiyat ?? this.gunlukFiyat,
      vitesTipi: vitesTipi ?? this.vitesTipi,
      yakitTipi: yakitTipi ?? this.yakitTipi,
      sehir: sehir ?? this.sehir,
      aciklama: aciklama ?? this.aciklama,
      kirayaVerenId: kirayaVerenId ?? this.kirayaVerenId,
      kirayaVerenAd: kirayaVerenAd ?? this.kirayaVerenAd,
      kiralandiMi: kiralandiMi ?? this.kiralandiMi,
      kiralayanId: kiralayanId ?? this.kiralayanId,
      kiralayanAd: kiralayanAd ?? this.kiralayanAd,
      begeniSayisi: begeniSayisi ?? this.begeniSayisi,
      begenildiMi: begenildiMi ?? this.begenildiMi,
      yorumlar: yorumlar ?? this.yorumlar,
      sembolikIkon: sembolikIkon ?? this.sembolikIkon,
    );
  }
}

/// Sahibinden tarzı detaylı araç arama ve filtreleme kriterleri modeli
class AracFiltreModel {
  final String? aramaKelimesi;
  final String? seciliMarka;
  final int? minYil;
  final int? maxYil;
  final double? minFiyat;
  final double? maxFiyat;
  final String? vitesTipi;
  final String? yakitTipi;
  final bool sadeceMusaitOlanlar;

  const AracFiltreModel({
    this.aramaKelimesi,
    this.seciliMarka,
    this.minYil,
    this.maxYil,
    this.minFiyat,
    this.maxFiyat,
    this.vitesTipi,
    this.yakitTipi,
    this.sadeceMusaitOlanlar = false,
  });

  bool get isActive {
    return (aramaKelimesi != null && aramaKelimesi!.isNotEmpty) ||
        (seciliMarka != null && seciliMarka!.isNotEmpty) ||
        minYil != null ||
        maxYil != null ||
        minFiyat != null ||
        maxFiyat != null ||
        (vitesTipi != null && vitesTipi!.isNotEmpty) ||
        (yakitTipi != null && yakitTipi!.isNotEmpty) ||
        sadeceMusaitOlanlar;
  }

  AracFiltreModel copyWith({
    String? aramaKelimesi,
    String? seciliMarka,
    int? minYil,
    int? maxYil,
    double? minFiyat,
    double? maxFiyat,
    String? vitesTipi,
    String? yakitTipi,
    bool? sadeceMusaitOlanlar,
    bool resetMarka = false,
    bool resetVites = false,
    bool resetYakit = false,
  }) {
    return AracFiltreModel(
      aramaKelimesi: aramaKelimesi ?? this.aramaKelimesi,
      seciliMarka: resetMarka ? null : (seciliMarka ?? this.seciliMarka),
      minYil: minYil ?? this.minYil,
      maxYil: maxYil ?? this.maxYil,
      minFiyat: minFiyat ?? this.minFiyat,
      maxFiyat: maxFiyat ?? this.maxFiyat,
      vitesTipi: resetVites ? null : (vitesTipi ?? this.vitesTipi),
      yakitTipi: resetYakit ? null : (yakitTipi ?? this.yakitTipi),
      sadeceMusaitOlanlar: sadeceMusaitOlanlar ?? this.sadeceMusaitOlanlar,
    );
  }

  static const AracFiltreModel empty = AracFiltreModel();
}
