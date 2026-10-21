import 'package:flutter/foundation.dart';
import '../../features/models/user_model.dart';

/// Kullanıcı oturumu, kimlik doğrulama ve profil durumu kontrolcüsü.
class UserProfileController {
  // Sistemdeki kayıtlı mock kullanıcılar
  final List<UserModel> _kullanicilar = [
    UserModel(
      id: 'usr_veren_1',
      kullaniciAdi: 'veren',
      sifre: '123',
      adSoyad: 'Ahmet Yılmaz',
      telefon: '+90 532 111 22 33',
      email: 'ahmet.veren@vites.app',
      rol: KullaniciRolu.veren,
      avatarUrl: 'speed', // Sembolik avatar anahtarı
      skor: 4.9,
      puanSayisi: 28,
      yorumlar: [
        KullaniciYorumu(
          id: 'yr_1',
          yorumYapanId: 'usr_alan_1',
          yorumYapanAd: 'Caner Demir',
          yorum: 'Araç tertemiz teslim edildi, çok ilgili ve dürüst bir araç sahibi.',
          puan: 5.0,
          tarih: DateTime.now().subtract(const Duration(days: 4)),
        ),
        KullaniciYorumu(
          id: 'yr_2',
          yorumYapanId: 'usr_alan_2',
          yorumYapanAd: 'Selin Kaya',
          yorum: 'İletişim çok hızlıydı, araç tam vaktinde teslim alındı.',
          puan: 4.8,
          tarih: DateTime.now().subtract(const Duration(days: 12)),
        ),
      ],
      aktifKiralamaIdleri: ['arc_1', 'arc_3'],
    ),
    UserModel(
      id: 'usr_alan_1',
      kullaniciAdi: 'alan',
      sifre: '123',
      adSoyad: 'Caner Demir',
      telefon: '+90 555 444 55 66',
      email: 'caner.alan@vites.app',
      rol: KullaniciRolu.alan,
      avatarUrl: 'directions_car', // Sembolik avatar anahtarı
      skor: 4.8,
      puanSayisi: 19,
      yorumlar: [
        KullaniciYorumu(
          id: 'yr_3',
          yorumYapanId: 'usr_veren_1',
          yorumYapanAd: 'Ahmet Yılmaz',
          yorum: 'Aracı çok temiz kullandı, yakıt deposunu tam dolu iade etti. Harika bir kiracı!',
          puan: 5.0,
          tarih: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
      aktifKiralamaIdleri: ['arc_1'],
    ),
  ];

  /// Aktif oturum açmış kullanıcı (null ise login ekranı gösterilir)
  final ValueNotifier<UserModel?> currentUser = ValueNotifier<UserModel?>(null);

  /// Kullanıcı listesine salt-okunur erişim
  List<UserModel> get kullanicilar => List.unmodifiable(_kullanicilar);

  /// Giriş işlemi (veren/123 veya alan/123)
  bool login(String kullaniciAdi, String sifre) {
    final trimmedUser = kullaniciAdi.trim().toLowerCase();
    final trimmedPass = sifre.trim();

    try {
      final user = _kullanicilar.firstWhere(
        (u) =>
            u.kullaniciAdi.toLowerCase() == trimmedUser &&
            u.sifre == trimmedPass,
      );
      currentUser.value = user;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Hızlı Tek Tık Girişi (Kiraya Veren veya Kiralayan)
  void quickLogin(KullaniciRolu rol) {
    final user = _kullanicilar.firstWhere((u) => u.rol == rol);
    currentUser.value = user;
  }

  /// Oturumu Kapat
  void logout() {
    currentUser.value = null;
  }

  /// Profil Avatarını Güncelle
  void updateAvatar(String yeniAvatarKey) {
    final current = currentUser.value;
    if (current == null) return;

    final updated = current.copyWith(avatarUrl: yeniAvatarKey);
    _guncelleKullaniciListesi(updated);
    currentUser.value = updated;
  }

  /// Profil Bilgilerini Güncelle (Form Yönetimi)
  void updateProfile({
    required String adSoyad,
    required String email,
    required String telefon,
  }) {
    final current = currentUser.value;
    if (current == null) return;

    final updated = current.copyWith(
      adSoyad: adSoyad.trim(),
      email: email.trim(),
      telefon: telefon.trim(),
    );
    _guncelleKullaniciListesi(updated);
    currentUser.value = updated;
  }

  /// Kullanıcıya puan ve yorum ekle (karşılıklı puanlama)
  void addRatingAndReview({
    required String hedefKullaniciId,
    required double puan,
    required String yorumMetni,
    required String yorumYapanAd,
    required String yorumYapanId,
  }) {
    final index = _kullanicilar.indexWhere((u) => u.id == hedefKullaniciId);
    if (index == -1) return;

    final hedef = _kullanicilar[index];
    final yeniYorum = KullaniciYorumu(
      id: 'yr_${DateTime.now().millisecondsSinceEpoch}',
      yorumYapanId: yorumYapanId,
      yorumYapanAd: yorumYapanAd,
      yorum: yorumMetni,
      puan: puan,
      tarih: DateTime.now(),
    );

    final yeniPuanSayisi = hedef.puanSayisi + 1;
    final yeniSkor =
        ((hedef.skor * hedef.puanSayisi) + puan) / yeniPuanSayisi;

    final guncelHedef = hedef.copyWith(
      skor: double.parse(yeniSkor.toStringAsFixed(1)),
      puanSayisi: yeniPuanSayisi,
      yorumlar: [yeniYorum, ...hedef.yorumlar],
    );

    _kullanicilar[index] = guncelHedef;

    // Eğer güncellenen kullanıcı şu an oturum açan kişi ise reaktif state'i yenile
    if (currentUser.value?.id == hedefKullaniciId) {
      currentUser.value = guncelHedef;
    }
  }

  /// ID'ye göre kullanıcı bul
  UserModel? getUserById(String id) {
    try {
      return _kullanicilar.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  void _guncelleKullaniciListesi(UserModel guncel) {
    final index = _kullanicilar.indexWhere((u) => u.id == guncel.id);
    if (index != -1) {
      _kullanicilar[index] = guncel;
    }
  }
}
