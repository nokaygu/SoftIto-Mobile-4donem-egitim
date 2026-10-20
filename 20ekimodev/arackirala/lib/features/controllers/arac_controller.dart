import 'package:flutter/foundation.dart';
import '../models/arac_model.dart';

/// Araç vitrini, filtreleme, beğeni ve kiralama durumları kontrolcüsü.
class AracController {
  final List<AracModel> _tumAraclar = [
    AracModel(
      id: 'arc_1',
      marka: 'BMW',
      model: '320i M Sport',
      yil: 2023,
      gunlukFiyat: 3200,
      vitesTipi: 'Otomatik',
      yakitTipi: 'Benzin',
      sehir: 'İstanbul, Kadıköy',
      aciklama: 'Kusursuz kondisyonda, bakımları yeni yapılmış, sunroof ve Harman Kardon ses sistemli.',
      kirayaVerenId: 'usr_veren_1',
      kirayaVerenAd: 'Ahmet Yılmaz',
      kiralandiMi: true,
      kiralayanId: 'usr_alan_1',
      kiralayanAd: 'Caner Demir',
      begeniSayisi: 42,
      begenildiMi: true,
      sembolikIkon: 'sports_car',
      yorumlar: [
        AracYorumu(
          id: 'ay_1',
          kullaniciId: 'usr_alan_1',
          kullaniciAdi: 'Caner Demir',
          yorum: 'Sürüş keyfi harika, yakıt tüketimi şehir içinde oldukça makul.',
          tarih: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    ),
    AracModel(
      id: 'arc_2',
      marka: 'Mercedes-Benz',
      model: 'C200 4MATIC AMG',
      yil: 2024,
      gunlukFiyat: 3800,
      vitesTipi: 'Otomatik',
      yakitTipi: 'Hibrit',
      sehir: 'İstanbul, Beşiktaş',
      aciklama: 'Sıfır ayarında lüks sedan. Otonom sürüş asistanı ve gece paketi mevcut.',
      kirayaVerenId: 'usr_veren_1',
      kirayaVerenAd: 'Ahmet Yılmaz',
      kiralandiMi: false,
      begeniSayisi: 87,
      begenildiMi: false,
      sembolikIkon: 'car',
      yorumlar: [
        AracYorumu(
          id: 'ay_2',
          kullaniciId: 'usr_alan_2',
          kullaniciAdi: 'Selin Kaya',
          yorum: 'Düğünümüz için kiralamıştık, harika bir araçtı!',
          tarih: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
    ),
    AracModel(
      id: 'arc_3',
      marka: 'Audi',
      model: 'RS6 Avant',
      yil: 2022,
      gunlukFiyat: 6500,
      vitesTipi: 'Otomatik',
      yakitTipi: 'Benzin',
      sehir: 'Ankara, Çankaya',
      aciklama: '600 HP güç, Quattro 4 çeker, karbon seramik frenler. Süper spor performans.',
      kirayaVerenId: 'usr_veren_1',
      kirayaVerenAd: 'Ahmet Yılmaz',
      kiralandiMi: false,
      begeniSayisi: 154,
      begenildiMi: true,
      sembolikIkon: 'speed',
      yorumlar: [],
    ),
    AracModel(
      id: 'arc_4',
      marka: 'Porsche',
      model: 'Taycan 4S',
      yil: 2023,
      gunlukFiyat: 7200,
      vitesTipi: 'Otomatik',
      yakitTipi: 'Elektrik',
      sehir: 'İzmir, Çeşme',
      aciklama: '%100 elektrikli, 530 HP güç, hızlı şarj istasyonlarına tam uyumlu.',
      kirayaVerenId: 'usr_veren_2',
      kirayaVerenAd: 'Kemal Akın',
      kiralandiMi: false,
      begeniSayisi: 210,
      begenildiMi: false,
      sembolikIkon: 'electric_car',
      yorumlar: [],
    ),
    AracModel(
      id: 'arc_5',
      marka: 'Volvo',
      model: 'XC90 B5 AWD',
      yil: 2021,
      gunlukFiyat: 4500,
      vitesTipi: 'Otomatik',
      yakitTipi: 'Dizel',
      sehir: 'Bursa, Nilüfer',
      aciklama: '7 kişilik geniş aile SUV, en üst düzey güvenlik donanımı.',
      kirayaVerenId: 'usr_veren_3',
      kirayaVerenAd: 'Murat Öz',
      kiralandiMi: false,
      begeniSayisi: 39,
      begenildiMi: false,
      sembolikIkon: 'suv',
      yorumlar: [],
    ),
  ];

  /// Aktif filtre kriterleri
  final ValueNotifier<AracFiltreModel> aktifFiltre =
      ValueNotifier<AracFiltreModel>(AracFiltreModel.empty);

  /// Filtrelenmiş veya tüm araçların listesi (Reaktif)
  late final ValueNotifier<List<AracModel>> araclarListesi;

  AracController() {
    araclarListesi = ValueNotifier<List<AracModel>>(List.unmodifiable(_tumAraclar));
  }

  /// Filtre kriterlerini uygula ve listeyi güncelle
  void filtreUygula(AracFiltreModel filtre) {
    aktifFiltre.value = filtre;
    _listeyiYenile();
  }

  /// Filtreyi sıfırla
  void filtreSifirla() {
    aktifFiltre.value = AracFiltreModel.empty;
    _listeyiYenile();
  }

  /// Beğeni durumunu değiştir (Sosyal beğeni)
  void toggleLike(String aracId) {
    final index = _tumAraclar.indexWhere((a) => a.id == aracId);
    if (index == -1) return;

    final mevcut = _tumAraclar[index];
    final yeniBegenildi = !mevcut.begenildiMi;
    final yeniSayi = yeniBegenildi
        ? mevcut.begeniSayisi + 1
        : (mevcut.begeniSayisi > 0 ? mevcut.begeniSayisi - 1 : 0);

    _tumAraclar[index] = mevcut.copyWith(
      begenildiMi: yeniBegenildi,
      begeniSayisi: yeniSayi,
    );

    _listeyiYenile();
  }

  /// Aracı kirala
  bool kirala({
    required String aracId,
    required String kiralayanId,
    required String kiralayanAd,
  }) {
    final index = _tumAraclar.indexWhere((a) => a.id == aracId);
    if (index == -1) return false;

    final arac = _tumAraclar[index];
    if (arac.kiralandiMi) return false;

    _tumAraclar[index] = arac.copyWith(
      kiralandiMi: true,
      kiralayanId: kiralayanId,
      kiralayanAd: kiralayanAd,
    );

    _listeyiYenile();
    return true;
  }

  /// Aracı teslim et / kiralamayı bitir
  void kiralamaBitir(String aracId) {
    final index = _tumAraclar.indexWhere((a) => a.id == aracId);
    if (index == -1) return;

    final arac = _tumAraclar[index];
    _tumAraclar[index] = arac.copyWith(
      kiralandiMi: false,
      kiralayanId: null,
      kiralayanAd: null,
    );

    _listeyiYenile();
  }

  /// Yeni araç ilanı ekle
  void aracEkle(AracModel yeniArac) {
    _tumAraclar.insert(0, yeniArac);
    _listeyiYenile();
  }

  /// Araca sosyal yorum ekle
  void yorumEkle(String aracId, AracYorumu yorum) {
    final index = _tumAraclar.indexWhere((a) => a.id == aracId);
    if (index == -1) return;

    final arac = _tumAraclar[index];
    _tumAraclar[index] = arac.copyWith(
      yorumlar: [yorum, ...arac.yorumlar],
    );

    _listeyiYenile();
  }

  /// ID'ye göre araç bul
  AracModel? getAracById(String id) {
    try {
      return _tumAraclar.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filtre mantığını işle ve reaktif listeyi güncelle
  void _listeyiYenile() {
    final f = aktifFiltre.value;
    final filtrelenmis = _tumAraclar.where((arac) {
      if (f.sadeceMusaitOlanlar && arac.kiralandiMi) return false;

      if (f.aramaKelimesi != null && f.aramaKelimesi!.isNotEmpty) {
        final query = f.aramaKelimesi!.toLowerCase();
        final match = arac.marka.toLowerCase().contains(query) ||
            arac.model.toLowerCase().contains(query) ||
            arac.sehir.toLowerCase().contains(query);
        if (!match) return false;
      }

      if (f.seciliMarka != null &&
          f.seciliMarka!.isNotEmpty &&
          arac.marka.toLowerCase() != f.seciliMarka!.toLowerCase()) {
        return false;
      }

      if (f.minYil != null && arac.yil < f.minYil!) return false;
      if (f.maxYil != null && arac.yil > f.maxYil!) return false;
      if (f.minFiyat != null && arac.gunlukFiyat < f.minFiyat!) return false;
      if (f.maxFiyat != null && arac.gunlukFiyat > f.maxFiyat!) return false;

      if (f.vitesTipi != null &&
          f.vitesTipi!.isNotEmpty &&
          arac.vitesTipi.toLowerCase() != f.vitesTipi!.toLowerCase()) {
        return false;
      }

      if (f.yakitTipi != null &&
          f.yakitTipi!.isNotEmpty &&
          arac.yakitTipi.toLowerCase() != f.yakitTipi!.toLowerCase()) {
        return false;
      }

      return true;
    }).toList();

    araclarListesi.value = List.unmodifiable(filtrelenmis);
  }
}
