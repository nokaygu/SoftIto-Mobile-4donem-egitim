# Reaktif State Akışı ve Controller Senkronizasyon Rehberi (`state_flow.md`)

Bu doküman, harici paket kullanmadan (`ValueNotifier` ve `ValueListenableBuilder` ile) ekranlar arası veri bütünlüğünün nasıl korunacağını ve OOP/SOLID kurallarına uygun state akışını tanımlar.

---

## 1. Altın Kural: Tekil (Singleton / Shared) Controller Kullanımı

Ekranlar arasında geçiş yaparken (örneğin `arac_filtreleme_ekrani.dart` içinde filtre uygulayıp `araclar.dart` ekranına dönerken veya `login.dart` ekranından ana sekmelere geçerken) verilerin kaybolmaması için **her ekranda yeni controller instance'ı ÜRETİLMEMELİDİR**.

Tüm controller'lar ya üst katmandan constructor ile aktarılmalı ya da temiz bir merkezi erişim noktası (`AppState` veya `static final instance`) üzerinden paylaşılmalıdır:

```dart
class AppState {
  AppState._();

  static final ThemeController theme = ThemeController();
  static final UserProfileController userProfile = UserProfileController();
  static final AracController arac = AracController();
  static final KiraciController kiraci = KiraciController();
  static final MesajController mesaj = MesajController();
}
```

---

## 2. Kimlik Doğrulama ve Rol Akışı (`UserProfileController`)

1. **Varsayılan Kullanıcılar:**
   - **Kiraya Veren (`veren` / `123`):** `rol: KullaniciRolu.veren`
   - **Kiralayan (`alan` / `123`):** `rol: KullaniciRolu.alan`
2. **Giriş (`login.dart`) -> Ana Ekran Akışı:**
   - `currentUser` (`ValueNotifier<UserModel?>`) başlangıçta `null` olur ve uygulama `login.dart` ekranını gösterir.
   - Kullanıcı `veren/123` veya `alan/123` ile giriş yaptığında (veya hızlı giriş butonuna bastığında) `currentUser.value` güncellenir ve ana sekmeli yapıya geçilir.
3. **Rol Tabanlı Dinamik Sekme (`views/kiracilar/`):**
   - Alt navigasyon barındaki "Kiracılar / Kiralayanlar" sekmesi `currentUser` değerini dinler:
     - Aktif kullanıcı **`veren`** ise -> `kiraci.dart` (Aracımı kiralayanlar, kiracı puanlama ve yorumlama) gösterilir.
     - Aktif kullanıcı **`alan`** ise -> `kiralayan.dart` (Araç kiraladığım kişiler, araç sahibi puanlama ve yorumlama) gösterilir.
4. **Profil ve Çıkış (`views/profil.dart`):**
   - Profil resmi güncellendiğinde `currentUser.value = currentUser.value?.copyWith(...)` ile anında tüm ekranlarda güncellenir.
   - **Çıkış Yap** butonuna basıldığında `currentUser.value = null` yapılır ve kullanıcı güvenli şekilde `login.dart` ekranına döner.

---

## 3. Araç Vitrini, Sosyal Beğeni ve "Sahibinden" Tarzı Filtreleme Akışı (`AracController`)

`AracController` içinde iki ayrı liste/durum yönetilir:

- `_tumAraclar` (Orijinal veri kaynağı)
- `aktifFiltre` (`ValueNotifier<AracFiltreModel>`)
- `araclarListesi` (`ValueNotifier<List<AracModel>>`)

1. **Sahibinden Tarzı Filtreleme (`arac_filtreleme_ekrani.dart`):**
   - Marka, Model, Yıl aralığı (`minYil`, `maxYil`), Fiyat aralığı (`minFiyat`, `maxFiyat`), Vites tipi, Yakıt tipi ve `sadeceMusaitOlanlar` kriterleri `AracFiltreModel` içinde tutulur.
   - Kullanıcı "Filtreyi Uygula" dediğinde `araclar.dart` ekranındaki liste anında filtrelenir; "Filtreyi Sıfırla" dediğinde tüm araçlar geri gelir.
2. **Sosyal Medya Tarzı Beğeni ve Yorum (`araclar.dart` & `arac_detay_ekrani.dart`):**
   - Kullanıcı bir aracı beğendiğinde (`toggleLike(aracId)`), ilgili `AracModel` nesnesinin `begenildiMi` ve `begeniSayisi` alanları `copyWith` ile güncellenir.
   - Hem vitrin kartında hem detay ekranında beğeni durumu anında senkronize olur (Bordo kalp ikonu aktifleşir).
3. **Araç Ekleme ve Kiralama (`arac_ekleme_ekrani.dart` & `arac_detay_ekrani.dart`):**
   - Yeni araç eklendiğinde listeye dahil edilir ve vitrinde anında görünür.
   - Bir araç kiralandığında `kiralandiMi: true` ve `kiralayanId: aktifKullanici.id` olarak güncellenir.

---

## 4. Güven Skoru, Yorum ve Mesajlaşma Akışı (`KiraciController` & `MesajController`)

1. **Karşılıklı Puanlama ve Yorumlama (`kiraci.dart` / `kiralayan.dart`):**
   - Kiraya veren kiracıyı veya kiralayan araç sahibini puanladığında (1-5 yıldız + yazılı yorum), hedef kullanıcının `skor` ortalaması ve `yorumlar` listesi reaktif olarak güncellenir.
   - Bu skor hem araç detay ekranında hem de profil ekranında güncel haliyle görünür.
2. **Mesajlaşma ve Şikayet (`mesajlar.dart`, `mesaj_detay_ekrani.dart`, `sikayet_ekrani.dart`):**
   - `mesaj_detay_ekrani.dart` içinde yeni mesaj gönderildiğinde ilgili sohbetin mesaj listesine eklenir ve `mesajlar.dart` ekranındaki "son mesaj" önizlemesi anında güncellenir.
   - `sikayet_ekrani.dart` üzerinden gönderilen şikayetler `sikayetlerListesi` (`ValueNotifier`) içine kaydedilir ve kullanıcıya onay bildirimi (`SnackBar`) gösterilir.
