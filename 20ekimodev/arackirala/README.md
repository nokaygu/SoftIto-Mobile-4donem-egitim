# Vites - Merkeziyetsiz Sosyal Araç Kiralama Platformu

**Vites**, bireylerin araçlarını birbirine doğrudan kiralayabildiği, araç sahipleri ve kiracıların karşılıklı güven skoru ve yorumlarla değerlendirildiği, sosyal medya dinamiklerine sahip modern bir P2P araç kiralama platformudur.

---

## 🌟 Öne Çıkan Özellikler

### 1. 🌓 Koyu ve Aydınlık Tema Desteği (Dark & Light Mode)
- **Koyu Tema (Dark Mode):** Karbon Siyahı (`#0B0C0E`), Derin Şarap Bordosu (`#8B1E2F`, `#5E111E`) ve yarı saydam akışkan buzlu cam yüzeyler.
- **Aydınlık Tema (Light Mode):** Slate-100 Gümüş Gri (`#F1F5F9`), Temiz Beyaz Yüzeyler (`#FFFFFF`) ve parlak bordo vurgular.
- **Kesin Kural:** Projede mor (deepPurple) tonları kesinlikle bulunmaz.
- **Canlı Geçiş:** Profil ekranındaki "Görünüm & Tema" anahtarı veya giriş ekranındaki hızlı buton ile anında değiştirilebilir.

### 2. 📝 Kapsamlı Form Yönetimi ve Validasyonlar
- **Giriş Formu (`login.dart`):** `GlobalKey<FormState>` ile kullanıcı adı ve şifre için boşluk ve min 3 karakter kontrolleri.
- **İlan Ekleme Formu (`arac_ekleme_ekrani.dart`):** Marka, model, model yılı (1980 - 2027), günlük kira bedeli (min ₺100), konum ve açıklama (min 10 karakter) doğrulamaları.
- **Kiralama Rezervasyon Formu (`arac_detay_ekrani.dart`):** Sürücü bilgileri (Ad Soyad, Telefon), kiralama gün stepper'ı (1-30 gün) ve Kiralama/Hasar Güvence Sözleşmesi onay kutusu (Checkbox) zorunluluğu.
- **Filtreleme Doğrulamaları (`arac_filtreleme_ekrani.dart`):** Minimum ve maksimum yıl/fiyat alanlarında mantıksal aralık kontrolleri.
- **Puanlama & Yorumlama Formu (`kiraci.dart`, `kiralayan.dart`):** 1-5 yıldız değerlendirmesi, hızlı etiket seçimi ve min 5 karakterlik yorum doğrulaması.
- **Şikayet & Güvenlik Formu (`sikayet_ekrani.dart`):** Şikayet başlığı (min 5 karakter) ve açıklaması (min 15 karakter) doğrulamaları.
- **Profil Güncelleme Formu (`profil.dart`):** Ad Soyad, E-posta (biçim/regex kontrolü) ve Telefon güncelleme form modalı.

### 3. 💬 Liquid Glass Modal & Diyalog Sistemi (`liquid_dialog.dart`)
- **`LiquidDialog`:** Buzlu cam efekti (`ImageFilter.blur(sigmaX: 18, sigmaY: 18)`), tema duyarlı dinamik kenarlıklar ve yumuşak gölgelendirme.
- **`showLiquidConfirmationDialog`:** İlan yayınlama, şikayet iletme, filtre sıfırlama ve oturumu kapatma gibi kritik işlemler öncesinde çift aşamalı kullanıcı onayı.
- **`showLiquidSuccessDialog`:** Başarılı işlemler sonrası kutlama ikonu, özet bilgisi ve devam butonu içeren geri bildirim pencereleri.

### 4. 👥 Rol Tabanlı Hızlı Giriş & Responsive Arayüz
- **Hızlı Giriş Kartları (`login.dart`):** Tek satırda hizalanan geniş, responsive flex mimarisi; kelime yığılmalarını önleyen esnek başlık, rol rozetleri ve yönlendirme göstergeleri.
- **Kiraya Veren (`veren / 123`):** Araç ilanı ekler, kiracılarını listeler, kiracıları 1-5 yıldızla puanlar ve değerlendirir.
- **Kiralayan (`alan / 123`):** Vitrindeki araçları inceler, beğenir, yorum yapar, filtreler, kiralar ve araç sahibini puanlar.
- **Taşmasız Düzen (Zero Overflow):** Tüm kart başlıklarında, butonlarda, listelerde ve diyaloglarda `Expanded`, `Flexible` ve `TextOverflow.ellipsis` ile küçük ekran uyumluluğu.

### 5. 🔑 Durum Duyarlı Araç Kiralama & Çift Yönlü İletişim
- **Kendi İlanım:** Kullanıcı kendi aracını görüntülerken araç kiradaysa kiracı detayını görüp tek tıkla kiracıya mesaj atabilir; araç müsaitse ilan durumunu inceleyebilir (butonlar yanıtsız kilitlenmez).
- **Kiraladığım Araç:** Aracı kiralayan kullanıcı detay ekranında "Bu Aracı Kiraladınız" butonu ile kiralama özetini görüp dilediğinde "Aracı İade Et / Teslim Et" ile süreci tamamlayabilir ve araç sahibine anında mesaj yazabilir.
- **Başkasına Ait Kiralık Araç:** Kirada olan araca tıklandığında bilgilendirici diyalog sunulur ve araç sahibine müsaitlik için mesaj gönderme imkanı açık kalır.

---

## 🏗️ Mimari ve Teknolojiler

- **Mimari:** Feature-driven MVC & Clean Layering (`core/`, `features/controllers/`, `features/models/`, `features/views/`, `features/widgets/`).
- **State Management:** **Sıfır harici paket**; tamamen saf Flutter SDK (`ValueNotifier`, `ChangeNotifier`, `ValueListenableBuilder`, `ListenableBuilder`).
- **OOP & SOLID:** Tek sorumluluk prensibi, `copyWith` immutability standardı ve **35-40 satırı geçmeyen** modüler metot yapısı.
- **Maksimum Const Kuralları:** `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_const_declarations` vb. linter kuralları ile tam uyumlu derleme optimizasyonu.


---

## 🚀 Projeyi Çalıştırma ve Doğrulama

### Analiz ve Doğrulama (0 Hata / 0 Uyarı)
```bash
flutter analyze
```

### Uygulamayı Başlatma
```bash
flutter run
```
