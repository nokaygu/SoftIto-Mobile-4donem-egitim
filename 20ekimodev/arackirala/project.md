# Vites - Merkeziyetsiz Sosyal Araç Kiralama Platformu

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zeka asistanları ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** **Vites** (Merkeziyetsiz P2P Araç Kiralama ve Sosyal Otomobil Ağı)
- **Backend Durumu:** **Backend YOKTUR.** Tüm araç ilanları, kiralama durumları, mesajlaşmalar, şikayetler, kullanıcı puanlamaları/yorumları ve sosyal beğeniler tamamen Flutter içinde lokal/bellek içi (`ValueNotifier` ve `ChangeNotifier` tabanlı reaktif mimari) olarak çalışacaktır.
- **Varsayılan Kullanıcılar (Mock Auth - `login.dart`):**
  Sistemde hazır tanımlı iki ana rol/kullanıcı bulunur (`login.dart` içinde hem form validasyonlu girişle hem de tek tıkla "Hızlı Seçim" butonlarıyla giriş yapılabilir):
  1. **Kiraya Veren (Araç Sahibi):** Kullanıcı Adı: `veren` | Şifre: `123`
  2. **Kiralayan (Kiracı):** Kullanıcı Adı: `alan` | Şifre: `123`
- **Temel İşleyiş ve Ekran Akışı:**
  1. **Araçlar ve Sosyal Akış (`views/araclar/`):**
     - `araclar.dart`: Kiralık araçların listelendiği ana akış. Kullanıcılar araçları sosyal medya gibi **beğenebilir (Like)**, yorum sayısını ve aracın şu an **Müsait** mi yoksa **Kirada** mı olduğunu (kimin kiraladığını) görebilir.
     - `arac_detay_ekrani.dart`: Aracın tüm teknik özellikleri, yılı, kira durumu, sahibinin güven skoru, araç hakkındaki sosyal yorumlar ve **"Hemen Kirala" (Validasyonlu Kiralama Formu ve Diyaloğu)** / **"Mesaj Gönder"** aksiyonları.
     - `arac_ekleme_ekrani.dart`: Yeni araç ilanı ekleme formu (Marka, model, yıl, fiyat, konum, teknik özellikler ve açıklama validasyonları + Onay diyaloğu).
     - `arac_filtreleme_ekrani.dart`: **Sahibinden tarzı** detaylı araç filtreleme ekranı (Marka, Model, Yıl aralığı, Fiyat aralığı, Vites/Yakıt tipi, Sadece Müsait Araçlar filtresi + Aralık validasyonları ve sıfırlama onayı).
  2. **Kiracılar ve Kiralayanlar (`views/kiracilar/`):**
     - Giriş yapan kullanıcının rolüne göre dinamik çalışır:
     - Kullanıcı **Kiraya Veren (`veren`)** ise `kiraci.dart` ekranı aktif olur: Aracını kiralayan kiracıları görür, kiracılara **güven skoru (1-5 yıldız)** verir, hazır etiketlerle hızlı değerlendirir ve validasyonlu yorum yazar.
     - Kullanıcı **Kiralayan (`alan`)** ise `kiralayan.dart` ekranı aktif olur: Araç kiraladığı sahipleri görür, kiralama geçmişini takip eder, araç sahiplerini puanlar ve yorumlar.
  3. **Mesajlar ve Güvenlik (`views/mesajlar/`):**
     - `mesajlar.dart`: Kiracı ve araç sahibi arasındaki sohbetlerin listesi.
     - `mesaj_detay_ekrani.dart`: Anlık lokal mesajlaşma ekranı.
     - `sikayet_ekrani.dart`: Merkeziyetsiz güven ortamını korumak için kullanıcı veya araç hakkında anlaşmazlık/şikayet bildirme ekranı (Kategori seçimi, başlık/açıklama validasyonları + Onay ve Takip Numaralı Başarı Diyaloğu).
  4. **Profil (`views/profil.dart`):**
     - Kullanıcının rol rozeti (Kiraya Veren / Kiralayan), profil resmi değiştirme/ekleme (hazır avatar/ikon seçici), aldığı toplam güven skoru, hakkındaki yorumlar, aktif kiraladığı/kiraya verdiği araçlar.
     - **Koyu / Aydınlık Tema Geçişi:** Tek tıkla reaktif mod değiştirici (Karanlık & Aydınlık tema switch'i).
     - **Profil Düzenleme Formu:** Ad Soyad, E-posta ve Telefon bilgilerini validasyonlu modal form üzerinden güncelleme.
     - **Güvenli Çıkış:** Yanlışlıkla oturum kapatmayı önleyen onay diyaloğu (`showLiquidConfirmationDialog`).

---

## 2. Tasarım Dili, Renk Kuralları ve Tema Sistemi (KIRMIZI ÇİZGİ)

- **KESİNLİKLE MOR RENKLİ BUTON YOKTUR:** Flutter'ın varsayılan `deepPurple` M3 rengi tamamen ezilmiştir. Hiçbir butonda, switch'te, rozette veya arka planda mor/eflatun tonları KULLANILMAYACAKTIR.
- **Koyu & Aydınlık Tema Mimarisi (`app_colors.dart` & `app_theme.dart`):**
  - **Bordo Vurgu (Crimson / Burgundy - Her İki Temada da Marka Kimliği):**
    - `#8B1E2F` (Canlı Koyu Bordo) ve `#5E111E` (Derin Şarap Bordosu), `#B8293D` (Vurgu Bordosu).
  - **Koyu Tema (Dark Mode):**
    - Arka plan: `#0B0C0E` (Karbon Siyahı), Yüzey: `#181A20` (Koyu Antrasit), Kart: `#262932` (Kurşun Gri).
    - Metin: `#F8FAFC` (Net Beyaz), İkincil Metin: `#CBD5E1` (Gümüş Gri).
    - Buzlu Cam: `Color(0xB31E2028)` yarı saydam antrasit + beyaz kenarlık `0x33FFFFFF`.
  - **Aydınlık Tema (Light Mode):**
    - Arka plan: `#F1F5F9` (Temiz Slate-100 Gümüş Gri), Yüzey: `#FFFFFF` (Parlak Beyaz), Kart: `#F8FAFC`.
    - Metin: `#0F172A` (Koyu Slate-900), İkincil Metin: `#334155` (Slate-700), İpucu: `#64748B`.
    - Buzlu Cam: `Color(0xEBFFFFFF)` yarı saydam beyaz + zarif bordo kenarlık `0x2E8B1E2F`.
  - **`ThemeHelper` Extension:** `BuildContext` üzerinden `context.isDark`, `context.scaffoldColor`, `context.surfaceColor`, `context.glassSurfaceColor`, `context.glassBorderColor`, `context.textPrimaryColor` ve `context.textSecondaryColor` ile anında tema duyarlılığı sağlanır.
- **Liquid Glass (Akışkan Buzlu Cam):** Material 3 bileşenleri üzerine `BackdropFilter` (`ImageFilter.blur(sigmaX: 16-18)`), dinamik yarı saydam yüzeyler ve ince metalik/bordo cam kenarlıkları monte edilmiştir.

---

## 3. Form Yönetimi, Validasyonlar ve Modal/Diyalog Sistemi

1. **Form Yönetimi ve Validasyon Standartları:**
   - Tüm veri giriş alanları `Form` ve `GlobalKey<FormState>` ile sarmalanır.
   - Hiçbir form geçersiz veya eksik veriyle sunucuya/state'e kayıt gönderemez.
   - **Giriş Ekranı (`login.dart`):** Kullanıcı adı ve şifre için boşluk ve min 3 karakter kontrolleri.
   - **Araç Ekleme Ekranı (`arac_ekleme_ekrani.dart`):** Marka/Model (min 2 karakter), Yıl (1980 - 2027 arası geçerli yıl), Fiyat (min ₺100 pozitif sayı), Konum (min 3 karakter), Açıklama (min 10 karakter).
   - **Araç Kiralama Modalı (`arac_detay_ekrani.dart`):** Sürücü Ad Soyad (min 3 karakter), Telefon (min 10 hane), Kiralama süresi (1-30 gün stepper) ve Sözleşme onay kutusu (Checkbox) kontrolü.
   - **Araç Yorumu:** Minimum 3 karakter zorunluluğu.
   - **Filtreleme Ekranı (`arac_filtreleme_ekrani.dart`):** Min Yıl <= Max Yıl ve Min Fiyat <= Max Fiyat mantıksal aralık doğrulaması.
   - **Kullanıcı Puanlama Formu (`kiraci.dart`, `kiralayan.dart`):** 1-5 yıldız seçimi, hazır etiket seçimi ve min 5 karakterlik yorum metni.
   - **Şikayet Formu (`sikayet_ekrani.dart`):** Kategori seçimi, Başlık (min 5 karakter), Açıklama (min 15 karakter).
   - **Profil Düzenleme Formu (`profil.dart`):** Ad Soyad (min 3 karakter), E-posta (`@` ve `.` içeren regex/biçim kontrolü), Telefon (min 10 hane).

2. **Liquid Dialog ve Modal Mimarisi (`widgets/liquid_dialog.dart`):**
   - **`LiquidDialog`:** Buzlu cam filtreli, tema duyarlı, yuvarlatılmış (22px) özel dialog penceresi.
   - **`showLiquidConfirmationDialog`:** Riskli veya önemli işlemler öncesinde kullanıcıdan açık onay alan diyalog ("Onayla" / "Vazgeç", opsiyonel yıkıcı kırmızı buton ve uyarı ikonları). Kullanıldığı yerler: Oturumu Kapat, İlanı Yayınla, Şikayeti Gönder, Filtreleri Sıfırla.
   - **`showLiquidSuccessDialog`:** İşlem tamamlandığında başarı ikonu, bilgilendirme metni ve aksiyon butonu içeren kutlama diyaloğu. Kullanıldığı yerler: İlan Yayında, Kiralama Başarılı, Değerlendirme Kaydedildi, Şikayet Alındı, Profil Güncellendi.

---

## 4. Mimari Yapı ve Klasör Düzeni

Kodlar tam olarak aşağıdaki klasör yapısına sadık kalınarak üretilmiştir:

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart                  # Koyu/Açık tema renkleri ve BuildContext ThemeHelper eklentisi (Mor yok!)
│   ├── theme/
│   │   ├── app_theme.dart                   # Material 3 + Liquid Glass Koyu & Aydınlık tema tanımları
│   │   └── theme_controller.dart            # Reaktif ChangeNotifier tema kontrolcüsü
│   └── state/
│       ├── app_state.dart                   # Global tekil erişim noktası
│       └── user_profile_controller.dart     # Aktif kullanıcı, giriş/çıkış, profil güncelleme ve puan durumu
├── features/
│   ├── controllers/
│   │   ├── arac_controller.dart             # Araç listesi, Sahibinden tarzı filtreleme, beğeni, kiralama işlemleri
│   │   ├── kiraci_controller.dart           # Kiracı/Kiralayan eşleşmeleri, puanlama ve yorum işlemleri
│   │   └── mesaj_controller.dart            # Mesajlaşma ve şikayet kayıt işlemleri
│   ├── models/
│   │   ├── arac_model.dart                  # Model, yıl, durum, kiralandı mı, kime/kimden, beğeni ve yorumlar
│   │   ├── user_model.dart                  # Veren/Alan rolü, profil resmi, aktif kiralamalar, skor ve yorumlar
│   │   └── mesaj_model.dart                 # Sohbet, mesaj ve şikayet veri modelleri
│   ├── views/
│   │   ├── login.dart                       # veren/123 ve alan/123 form validasyonlu giriş + hızlı seçim + tema butonu
│   │   ├── araclar/
│   │   │   ├── araclar.dart                 # Araç vitrini ve sosyal beğeni akışı
│   │   │   ├── arac_detay_ekrani.dart       # Araç detay, form validasyonlu kiralama modalı ve yorum alanı
│   │   │   ├── arac_ekleme_ekrani.dart      # Validasyonlu yeni kiralık araç ekleme formu ve onay diyaloğu
│   │   │   └── arac_filtreleme_ekrani.dart  # Sahibinden tarzı detaylı filtreleme ekranı ve aralık kontrolü
│   │   ├── kiracilar/
│   │   │   ├── kiraci.dart                  # Veren için: Kiracıları listeleme, etiketli ve validasyonlu puanlama
│   │   │   └── kiralayan.dart               # Alan için: Araç sahiplerini listeleme ve validasyonlu puanlama
│   │   ├── mesajlar/
│   │   │   ├── mesajlar.dart                # Sohbet listesi ekranı
│   │   │   ├── mesaj_detay_ekrani.dart      # Anlık mesajlaşma detay ekranı
│   │   │   └── sikayet_ekrani.dart          # Validasyonlu şikayet formu, onay ve takip no diyaloğu
│   │   └── profil.dart                      # Profil düzenleme formu, skor, tema switch'i ve güvenli çıkış diyaloğu
│   └── widgets/
│       ├── liquid_app_bar.dart              # Buzlu cam şeffaf AppBar bileşeni
│       ├── liquid_badge.dart                # Tema duyarlı durum ve rol rozetleri
│       ├── liquid_button.dart               # Bordo gradyanlı ve ikincil cam butonlar
│       ├── liquid_dialog.dart               # Liquid modal, onay ve başarı diyalogları
│       ├── liquid_glass_card.dart           # Akışkan buzlu cam (BackdropFilter) kartı
│       └── liquid_text_field.dart           # Form validasyonlarına tam uyumlu cam metin kutusu
└── main.dart                                # Tema bağlayıcı (lightTheme/darkTheme), AuthGate ve 4 sekmeli ana kabuk
```

---

## 5. SOLID, OOP ve Kod Kalite Standartları

1. **`yapilanlar.md` İlerleme Takibi:**
   - Her geliştirme adımında kök dizindeki `yapilanlar.md` güncellenerek kayıt altına alınmıştır.
2. **SOLID ve OOP Prensipleri:**
   - **Single Responsibility (Tek Sorumluluk):** Her sınıf, dosya ve fonksiyon yalnızca tek bir sorumluluğu üstlenir.
   - **Uzun Kodları Parçalama Zorunluluğu:** Hiçbir `build` metodu **35-40 satırı** geçemez. Uzun ekranlar anlamlı yardımcı metotlara (`_buildHeader()`, `_buildFilterBar()`, `_buildPriceSummary()`) bölünmüştür.
   - **Kapsülleme (Encapsulation) ve Immutability:** Modellerde tüm alanlar `final` tanımlanmış olup durum değişiklikleri daima `copyWith` üzerinden reaktif olarak gerçekleştirilir.
3. **Sıfır Harici Paket ve Reaktif State:**
   - Harici paket eklenmemiştir; tüm durum yönetimi saf Flutter SDK bileşenleri (`ValueNotifier`, `ChangeNotifier`, `ValueListenableBuilder`, `ListenableBuilder`) ile yönetilmektedir.
4. **Maksimum Flutter Const ve Statik Analiz Kuralları:**
   - `analysis_options.yaml` içerisinde `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_const_declarations` vb. kurallar zorunlu kılınmıştır.
   - Değişmeyen tüm widget'lar, renk şemaları ve modeller `const` ile oluşturulur.
5. **Duyarlı ve Taşmasız UI (Responsive Architecture):**
   - Tüm butonlarda, kartlarda ve flex satırlarında `Expanded`, `Flexible` ve `TextOverflow.ellipsis` kullanımı zorunludur.
   - `GridView` bileşenlerinde `childAspectRatio` ekran ölçeğine uygun ve dar ekranlarda taşmayacak biçimde yapılandırılmıştır.
6. **Durum Duyarlı Araç Aksiyonları (State-Aware Action Architecture):**
   - Araç detayındaki butonlar asla sessizce kilitlenmez (`onPressed: null` ile yanıtsız bırakılmaz).
   - Kullanıcı kendi ilanında ise kiracı iletişimi veya ilan durum bilgisi; kiralayan ise aracı teslim etme ve araç sahibiyle mesajlaşma aksiyonları dinamik olarak sunulur.

---

## 6. Geliştirme ve Doğrulama Komutları

Aşağıdaki komut her zaman **0 hata ve 0 uyarı** ile başarıyla tamamlanmalıdır:

```bash
flutter analyze
```

