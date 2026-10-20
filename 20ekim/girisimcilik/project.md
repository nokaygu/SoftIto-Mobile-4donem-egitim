# Kurucu - Girişimci Hukuk, Finans, Yatırım ve Hibe Ekosistemi

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zeka asistanları ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** **Kurucu** (Girişimciler İçin Şirket Kurulumu, Hukuk, Mali Müşavir, Yatırım ve Hibe Destek Platformu)
- **Backend Durumu:** **Backend YOKTUR.** Tüm veriler, form kayıtları, ekip tabloları, uzman onay mekanizması, yatırımcı eşleşmeleri, hibe başvuruları ve X benzeri topluluk paylaşımları tamamen Flutter içinde lokal/bellek içi (`ValueNotifier` tabanlı reaktif mimari) olarak çalışacaktır.
- **Temel İşleyiş ve Kullanıcı Akışı:**
  1. **Giriş ve İş Planı Durumu Seçimi (Onboarding / Başvuru Modülü):**
     - Girişimciye iki ayrı yol sunulur: **"İş Planım Var"** ve **"İş Planım Yok"**.
     - **İş Planım Var Seçilirse:** Detaylı bir girişim formu açılır. Girişimci; Sektör seçimi, Girişim Özeti, Finansal İhtiyaç ve dinamik bir **Ekip Tablosu** (Ekipte kimler var, unvanları/rolleri ne, hangi işleri yapıyorlar satır satır eklenip tabloda gösterilir) doldurur.
     - **İş Planım Yok Seçilirse:** Fikir aşamasındaki girişimciler için rehberli temel ihtiyaç formu (Fikir alanı, ihtiyaç duyulan uzmanlıklar, şirketleşme hedefi) açılır.
  2. **Arka Plan Uzman Onayı ve "Onaylı Kullanıcı" Statüsü:**
     - Form doldurulduğunda başvuru _"Uzman Ekip İncelemesinde"_ durumuna geçer.
     - Backend olmadığı için arayüzde (üst barda veya başvuru kartında) test amaçlı **"Uzman Onayını Simüle Et (Onayla / Beklet)"** anahtarı bulunur.
     - Uzman onayı aktif edildiğinde kullanıcı **"Onaylı Girişimci"** olur. Onaylı kullanıcıya anında:
       - **Maddi Destek Garantisi Sertifikası/Rozeti** tanımlanır.
       - **Ücretsiz Hukuksal Danışmanlık** kapsamında sistem tarafından **Ücretsiz Avukat** atanır.
       - **Finansal Süreçler** için özel bir **Mali Müşavir** atanır ve şirket kuruluş/hukuk adımları takip listesi aktifleşir.
  3. **Alt Navigasyon Barı (4 Ana Sayfa):**
     - **1. Sayfa - Mentorlar, Hukuk & Mali Müşavir:** Şirket kuruluş aşamaları (Hukuki süreç takip çubuğu), atanan Ücretsiz Avukat ve Mali Müşavir iletişim/danışmanlık kartları (Onaylı kullanıcılarda aktif ve garantili görünür) ile sektörel mentorların listesi ve randevu/eşleşme butonları.
     - **2. Sayfa - Yatırımcılar:** "Melek Yatırımcılar" ve "Kurumsal / VC Yatırımcılar" olarak filtrelenebilen yatırımcı listeleri, odaklandıkları sektörler, yatırım aralıkları ve girişimcinin tek tıkla **"Eşleş / Sunum (Pitch) Gönder"** veya **"İletişime Geç"** diyebileceği etkileşimli yapı.
     - **3. Sayfa - Hibeler ve Destekler:** KOSGEB, TÜBİTAK, Yurt İçi ve Yurt Dışı hibe programlarının listesi. Kategori filtreleme, hibe tutarları, şartlar ve uygulama içinden tek tıkla **"Başvuru Yap"** diyerek başvuru durumunu takip etme özelliği.
     - **4. Sayfa - Topluluk & Network (X Benzeri Akış):** Girişimcilerin kısa metinlerle fikir, soru veya gelişme paylaşabildiği, gönderilere **Beğeni (Like)** atabildiği, onaylı girişimcilerin isminin yanında **"Onaylı Girişimci" rozetinin** göründüğü X (Twitter) tarzı dinamik sosyal ağ sayfası.
- **Hedef Platformlar:** iOS ve Android öncelikli; ardından Web ve Masaüstü platformları (Responsive yapı).
- **Flutter SDK:** 3.29.0
- **Tasarım Dili:** Material 3, Çift Tema Desteği:
  - **Aydınlık Tema (Kurumsal Güven & İnovasyon Paleti):** Ferah buz beyazı arka plan (`#F8FAFC`), derin lacivert/antrasit metinler (`#0F172A`), güven veren kraliyet mavisi (`#2563EB`) ana vurgu ve onay/hibe/garanti durumları için zümrüt yeşili (`#10B981`).
  - **Koyu Tema (Silikon Vadisi Gece Paleti):** Derin karbon/obsidyen arka plan (`#0B0F19`), kırık beyaz metinler, elektrik indigosu (`#6366F1`) ve neon zümrüt (`#34D399`) vurgu tonları.
  - Tema yönetimi `lib/core/theme/theme_controller.dart` altında reaktif `ValueNotifier<ThemeMode>` ile sağlanmalıdır.

---

## 2. Mimari Yapı: Özellik Bazlı (Feature-First)

Kodlar kesinlikle tek bir dosyada toplanmayacaktır. Her modül kendi `feature` klasöründe izole olarak kodlanacaktır.

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── theme_controller.dart
│   └── state/
│       └── entrepreneur_profile_controller.dart # Onaylı kullanıcı, iş planı, ekip tablosu ve atanan avukat/mali müşavir global durumu
├── features/
│   ├── shell/                                   # 4 sekmeli BottomNavigationBar + Üst Uzman Onay Simülasyon Barı
│   │   ├── views/
│   │   └── widgets/
│   ├── onboarding/                              # İş Planı Var/Yok seçimi, Sektör & Dinamik Ekip Tablosu formu
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── views/
│   │   └── widgets/
│   ├── mentors_legal/                           # 1. Sekme: Hukuki süreçler, Ücretsiz Avukat, Mali Müşavir ve Mentorlar
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── views/
│   │   └── widgets/
│   ├── investors/                               # 2. Sekme: Melek Yatırımcılar, Diğer Yatırımcılar, Eşleşme & İletişim
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── views/
│   │   └── widgets/
│   ├── grants/                                  # 3. Sekme: KOSGEB, Yurt İçi ve Yurt Dışı Hibe Başvuruları
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── views/
│   │   └── widgets/
│   └── community/                               # 4. Sekme: X (Twitter) benzeri Network, Paylaşım ve Like sayfası
│       ├── controllers/
│       ├── models/
│       ├── views/
│       └── widgets/
└── main.dart                                    # Sadece uygulama başlatma ve tema bağlantısı
```

---

## 3. Kırmızı Çizgiler ve Kod Kalite Standartları

### 1. `yapilanlar.md` İlerleme Takip Zorunluluğu (Çok Önemli)

- Ajan, kodlamaya başlamadan önce proje kök dizininde `yapilanlar.md` adında bir dosya oluşturmak **ZORUNDADIR**.
- Tüm geliştirme adımları `[ ]` şeklinde listelenmeli ve tamamlanan her modülün/adımın ardından `yapilanlar.md` dosyası güncellenerek ilgili adım `[x]` olarak işaretlenmeli ve yapılan değişiklikler dosya yollarıyla birlikte kısaca not edilmelidir.

### 2. Sıfır Harici Paket (Zero External Package) ve Backend'siz Mimari Kuralı

- Projeye `http`, `shared_preferences`, `provider`, `bloc`, `riverpod`, `getx`, `go_router` dahil **HİÇBİR HARİCİ PAKET EKLENMEYECEKTİR**.
- Tüm tablolar (Ekip tablosu vb.), sekmeler, formlar, filtreler ve X tarzı sosyal akış tamamen Flutter'ın yerleşik (`Table`, `GridView`, `ListView`, `AnimatedContainer`, `ModalBottomSheet`, `ValueNotifier`, `ValueListenableBuilder`) yetenekleriyle sıfırdan kodlanacaktır.

### 3. State Yönetim Standartları

- Sayfa düzeyinde tüm ekranı yeniden çizen ağır `setState` **KULLANILMAYACAKTIR**.
- Yalnızca mikro düzeyde yerel arayüz durumunu yöneten (`TextEditingController` yaşam döngüsü vb.) küçük `StatefulWidget` yapılarına izin verilir. Tüm iş mantığı `ValueNotifier` içinde tutulacaktır.

### 4. UI, Estetik ve Performans Kuralları

- Statik olan tüm widget'larda `const` kullanımı zorunludur.
- Renk, gölge, kenar yuvarlaklığı (`BorderRadius`) ve metin stilleri kesinlikle widget içine sabit (hardcoded) yazılmayacak, `app_theme.dart` ve `app_colors.dart` üzerinden çekilecektir.
- Büyük `build` metodları yasaktır! **40 satırı geçen** `build` metodları derhal anlamlı özel alt widget'lara (`widgets/` klasörü altına) bölünecektir.

---

## 4. Geliştirme, Analiz ve Test Komutları

Ajan, yaptığı herhangi bir kod değişikliğinden sonra mutlaka aşağıdaki komutların hatasız çalıştığını doğrulamalıdır:

- **Statik kod analizi (0 uyarı ve 0 hata şarttır):**

```bash
flutter analyze
```

- **Birim ve widget testleri:**

```bash
flutter test
```

- **Projeyi çalıştırma:**

```bash
flutter run
```

---

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan, net, anlaşılır ve doğrudan olacaktır.
- **Değişiklik Sunumları:** Örneğin 200 satırlık bir dosyada 5 satır değiştiyse tüm dosyayı baştan sona tekrar basma; yalnızca hedef satırları ve `diff` (fark) yapısını göster.
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka proje kök dizinine göre tıklanabilir dosya yolu ver (Örn: `lib/features/investors/views/investors_view.dart`).
- **Doğrulama:** Her adım sonunda `yapilanlar.md` dosyasını güncelle ve kullanıcıya _"Şimdi `flutter analyze` komutu ile kod kalitesini doğrulayabilirsin."_ şeklinde yönlendirme yap.

---

## 6. Liquid Glass (Apple iOS) Tasarım Sistemi ve Son Güncellemeler

- **Ambient Mesh Glow:** `lib/core/widgets/ambient_background.dart` üzerinde ekran içi canlı sıvı ışık küreleri (İndigo, Viyole, Zümrüt, Cyan) konumlandırılmış, cam arkasından gerçekçi optik kırılma sağlanmıştır.
- **Translucent Specular Glass Container:** `lib/core/widgets/liquid_glass_container.dart` çift katmanlı yayvan gölgeler, parlak beyaz cam kenarlıklar ve yarı saydam akışkan gradyan dolgu ile güçlendirilmiştir.
- **Scroll & Form Deneyimi:** `lib/features/onboarding/views/onboarding_view.dart` `SingleChildScrollView(physics: BouncingScrollPhysics())` ile bütünleşik iOS kaydırma yapısına alınmış ve `no_plan_form.dart` menü senkronizasyonu tamamlanmıştır.
- **Yüksek Kontrastlı Bildirim (Floating SnackBar):** Siyah zemin üzerine siyah metin sorunu giderilmiş; neon zümrüt ışıklı yüzen kapsül ve saf beyaz tipografi entegre edilmiştir.

---

## 7. Rol Tabanlı Çoklu Portal Mimarisi ve Admin Denetim Konsolu

Uygulama, ekosistemdeki farklı aktörlerin ihtiyaçlarına göre 3 ayrı Liquid Glass giriş portalına ve denetim mekanizmasına sahiptir:

1. **Girişimci (Yatırım Alan) Portalı (`lib/features/shell/`):**
   - Hukuk, mali müşavirlik, KOSGEB/TÜBİTAK hibeleri, melek yatırımcılara pitch deck iletimi ve topluluk paylaşımları.
2. **Yatırımcı Portalı (`lib/features/investor_portal/`):**
   - **Deal Flow (Girişim Havuzu):** Yatırım arayan onaylı girişimleri aşama, sektör ve finansal ihtiyaca göre inceleme.
   - **Gelen Başvurular:** Girişimcilerin gönderdiği pitch deck'leri değerlendirme, doğrudan toplantı planlama veya Term Sheet (Niyet Mektubu) iletme.
   - **Portföy & KPI:** Aktif yatırımlar, yatırılan sermaye (18.5M ₺) ve çarpan (MOIC) takibi.
3. **Admin Denetim Konsolu (`lib/features/admin_portal/`):**
   - **Başvuru Onay Masası:** Yeni start-up başvurularını denetleme, onaylama veya incelemeye alma.
   - **Uzman Atama:** Girişimciye ekosistem avukatını (Av. Selin Kaya vb.) ve mali müşavirini (SMMM Emre Demir vb.) atama yetkisi.
   - **Yatırımcı Akreditasyonu:** Melek ve VC yatırımcıların yetki belgelerini inceleyip mavi tikli akreditasyon rozeti verme.
   - **Metrikler & Denetim Günlüğü:** 85.4M ₺ fon hacmi, sektörel grafikler ve tüm sistem içi hareketlerin şeffaf logları.
4. **Rol Geçiş Altyapısı (`lib/features/auth/` & `RootRoleGate`):**
   - Kullanıcı dilediğinde `RoleSelectionView` üzerinden rolünü seçebilir veya tüm ekranların üst çubuğundaki **Rol Değiştir** butonu ile diğer portallara kesintisiz geçebilir.

---

## 8. Layout Taşma (Overflow) Çözümleri ve Apple Azure Renk Sistemi

1. **Taşma (Overflow) ve Sarı-Siyah Çizgili Bar Çözümleri:**
   - Üst bilgi barlarındaki (`_buildTopInvestorBar`, `_buildTopAdminBar`) kullanıcı ve rol etiketleri, esnek genişleyen `Expanded` ve `TextOverflow.ellipsis` ile sarılmış; sağ taraftaki "Rol Değiştir" butonuyla çakışması ve 7.x piksel taşması engellenmiştir.
2. **Renk Paleti Optimizasyonu (Mor Yerine Apple Okyanus Azure):**
   - Liquid Glass şeffaf cam estetiği ile uyumsuz olan parlak mor tonlar yerine, Apple iOS sistem standardı olan **Okyanus Azure (`#0284C7`)** ve **Buzul Cam Mavisi (`#38BDF8`)** renkleri entegre edilmiştir.
   - Bu renkler `AppColors.investorAccent` ve `AppColors.investorAccentLight` altında modülerleştirilmiştir.
   - Arka plan ambient ışık kürelerinde viyoleden derin safir/indigo geçişlerine geçilerek renk ahengi sağlanmıştır.



