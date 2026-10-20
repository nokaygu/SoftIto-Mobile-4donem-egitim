import 'package:flutter/foundation.dart';

/// Kiralama işlem kaydı ve karşılıklı değerlendirme durumu
class KiralamaKaydi {
  final String id;
  final String aracId;
  final String aracBilgisi;
  final String kirayaVerenId;
  final String kirayaVerenAd;
  final String kiralayanId;
  final String kiralayanAd;
  final DateTime baslangicTarihi;
  final DateTime bitisTarihi;
  final double toplamTutar;
  final String durum; // 'Aktif', 'Tamamlandı'
  final bool kirayaVerenPuanladiMi;
  final bool kiralayanPuanladiMi;

  const KiralamaKaydi({
    required this.id,
    required this.aracId,
    required this.aracBilgisi,
    required this.kirayaVerenId,
    required this.kirayaVerenAd,
    required this.kiralayanId,
    required this.kiralayanAd,
    required this.baslangicTarihi,
    required this.bitisTarihi,
    required this.toplamTutar,
    this.durum = 'Aktif',
    this.kirayaVerenPuanladiMi = false,
    this.kiralayanPuanladiMi = false,
  });

  KiralamaKaydi copyWith({
    String? id,
    String? aracId,
    String? aracBilgisi,
    String? kirayaVerenId,
    String? kirayaVerenAd,
    String? kiralayanId,
    String? kiralayanAd,
    DateTime? baslangicTarihi,
    DateTime? bitisTarihi,
    double? toplamTutar,
    String? durum,
    bool? kirayaVerenPuanladiMi,
    bool? kiralayanPuanladiMi,
  }) {
    return KiralamaKaydi(
      id: id ?? this.id,
      aracId: aracId ?? this.aracId,
      aracBilgisi: aracBilgisi ?? this.aracBilgisi,
      kirayaVerenId: kirayaVerenId ?? this.kirayaVerenId,
      kirayaVerenAd: kirayaVerenAd ?? this.kirayaVerenAd,
      kiralayanId: kiralayanId ?? this.kiralayanId,
      kiralayanAd: kiralayanAd ?? this.kiralayanAd,
      baslangicTarihi: baslangicTarihi ?? this.baslangicTarihi,
      bitisTarihi: bitisTarihi ?? this.bitisTarihi,
      toplamTutar: toplamTutar ?? this.toplamTutar,
      durum: durum ?? this.durum,
      kirayaVerenPuanladiMi: kirayaVerenPuanladiMi ?? this.kirayaVerenPuanladiMi,
      kiralayanPuanladiMi: kiralayanPuanladiMi ?? this.kiralayanPuanladiMi,
    );
  }
}

/// Kiracı ve Kiralayan kayıtları ve puanlama kontrolcüsü.
class KiraciController {
  final List<KiralamaKaydi> _kayitlar = [
    KiralamaKaydi(
      id: 'krl_1',
      aracId: 'arc_1',
      aracBilgisi: 'BMW 320i M Sport (2023)',
      kirayaVerenId: 'usr_veren_1',
      kirayaVerenAd: 'Ahmet Yılmaz',
      kiralayanId: 'usr_alan_1',
      kiralayanAd: 'Caner Demir',
      baslangicTarihi: DateTime.now().subtract(const Duration(days: 2)),
      bitisTarihi: DateTime.now().add(const Duration(days: 3)),
      toplamTutar: 16000,
      durum: 'Aktif',
      kirayaVerenPuanladiMi: false,
      kiralayanPuanladiMi: false,
    ),
    KiralamaKaydi(
      id: 'krl_2',
      aracId: 'arc_2',
      aracBilgisi: 'Mercedes-Benz C200 (2024)',
      kirayaVerenId: 'usr_veren_1',
      kirayaVerenAd: 'Ahmet Yılmaz',
      kiralayanId: 'usr_alan_2',
      kiralayanAd: 'Selin Kaya',
      baslangicTarihi: DateTime.now().subtract(const Duration(days: 15)),
      bitisTarihi: DateTime.now().subtract(const Duration(days: 10)),
      toplamTutar: 19000,
      durum: 'Tamamlandı',
      kirayaVerenPuanladiMi: true,
      kiralayanPuanladiMi: true,
    ),
  ];

  late final ValueNotifier<List<KiralamaKaydi>> kayitlarNotifier;

  KiraciController() {
    kayitlarNotifier = ValueNotifier<List<KiralamaKaydi>>(List.unmodifiable(_kayitlar));
  }

  /// Kiraya Veren kullanıcının kiracı kayıtlarını getirir
  List<KiralamaKaydi> getKiracilar(String kirayaVerenId) {
    return _kayitlar.where((k) => k.kirayaVerenId == kirayaVerenId).toList();
  }

  /// Kiralayan kullanıcının kiralama geçmişini getirir
  List<KiralamaKaydi> getKiralamaGecmisi(String kiralayanId) {
    return _kayitlar.where((k) => k.kiralayanId == kiralayanId).toList();
  }

  /// Yeni kiralama işlemi başlat
  void yeniKiralamaEkle(KiralamaKaydi kayit) {
    _kayitlar.insert(0, kayit);
    kayitlarNotifier.value = List.unmodifiable(_kayitlar);
  }

  /// Kiraya veren kiracıyı puanladığında işaretle
  void markKirayaVerenPuanladi(String kayitId) {
    final index = _kayitlar.indexWhere((k) => k.id == kayitId);
    if (index != -1) {
      _kayitlar[index] = _kayitlar[index].copyWith(kirayaVerenPuanladiMi: true);
      kayitlarNotifier.value = List.unmodifiable(_kayitlar);
    }
  }

  /// Kiralayan kiraya vereni puanladığında işaretle
  void markKiralayanPuanladi(String kayitId) {
    final index = _kayitlar.indexWhere((k) => k.id == kayitId);
    if (index != -1) {
      _kayitlar[index] = _kayitlar[index].copyWith(kiralayanPuanladiMi: true);
      kayitlarNotifier.value = List.unmodifiable(_kayitlar);
    }
  }
}
