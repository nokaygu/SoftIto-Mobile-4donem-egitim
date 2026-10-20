/// Kullanıcının sistemdeki rolü
enum KullaniciRolu {
  veren, // Kiraya Veren (Araç Sahibi)
  alan, // Kiralayan (Kiracı)
}

/// Kullanıcıya yapılan değerlendirme ve yorum
class KullaniciYorumu {
  final String id;
  final String yorumYapanId;
  final String yorumYapanAd;
  final String yorum;
  final double puan;
  final DateTime tarih;

  const KullaniciYorumu({
    required this.id,
    required this.yorumYapanId,
    required this.yorumYapanAd,
    required this.yorum,
    required this.puan,
    required this.tarih,
  });

  KullaniciYorumu copyWith({
    String? id,
    String? yorumYapanId,
    String? yorumYapanAd,
    String? yorum,
    double? puan,
    DateTime? tarih,
  }) {
    return KullaniciYorumu(
      id: id ?? this.id,
      yorumYapanId: yorumYapanId ?? this.yorumYapanId,
      yorumYapanAd: yorumYapanAd ?? this.yorumYapanAd,
      yorum: yorum ?? this.yorum,
      puan: puan ?? this.puan,
      tarih: tarih ?? this.tarih,
    );
  }
}

/// Sistem kullanıcısı (Kiraya Veren veya Kiralayan)
class UserModel {
  final String id;
  final String kullaniciAdi;
  final String sifre;
  final String adSoyad;
  final String telefon;
  final String email;
  final KullaniciRolu rol;
  final String avatarUrl; // Avatar simgesi veya görsel kimliği
  final double skor;
  final int puanSayisi;
  final List<KullaniciYorumu> yorumlar;
  final List<String> aktifKiralamaIdleri;

  const UserModel({
    required this.id,
    required this.kullaniciAdi,
    required this.sifre,
    required this.adSoyad,
    required this.telefon,
    required this.email,
    required this.rol,
    required this.avatarUrl,
    this.skor = 5.0,
    this.puanSayisi = 0,
    this.yorumlar = const [],
    this.aktifKiralamaIdleri = const [],
  });

  bool get isKirayaVeren => rol == KullaniciRolu.veren;
  bool get isKiralayan => rol == KullaniciRolu.alan;

  UserModel copyWith({
    String? id,
    String? kullaniciAdi,
    String? sifre,
    String? adSoyad,
    String? telefon,
    String? email,
    KullaniciRolu? rol,
    String? avatarUrl,
    double? skor,
    int? puanSayisi,
    List<KullaniciYorumu>? yorumlar,
    List<String>? aktifKiralamaIdleri,
  }) {
    return UserModel(
      id: id ?? this.id,
      kullaniciAdi: kullaniciAdi ?? this.kullaniciAdi,
      sifre: sifre ?? this.sifre,
      adSoyad: adSoyad ?? this.adSoyad,
      telefon: telefon ?? this.telefon,
      email: email ?? this.email,
      rol: rol ?? this.rol,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      skor: skor ?? this.skor,
      puanSayisi: puanSayisi ?? this.puanSayisi,
      yorumlar: yorumlar ?? this.yorumlar,
      aktifKiralamaIdleri: aktifKiralamaIdleri ?? this.aktifKiralamaIdleri,
    );
  }
}
