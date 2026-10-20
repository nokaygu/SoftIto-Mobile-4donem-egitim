# Vites - Merkeziyetsiz Sosyal Araç Kiralama Platformu

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zeka asistanları ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** **Vites** (Merkeziyetsiz P2P Araç Kiralama ve Sosyal Otomobil Ağı)
- **Backend Durumu:** **Backend YOKTUR.** Tüm araç ilanları, kiralama durumları, mesajlaşmalar, şikayetler, kullanıcı puanlamaları/yorumları ve sosyal beğeniler tamamen Flutter içinde lokal/bellek içi (`ValueNotifier` tabanlı reaktif mimari) olarak çalışacaktır.
- **Varsayılan Kullanıcılar (Mock Auth - `login.dart`):**
  Sistemde hazır tanımlı iki ana rol/kullanıcı bulunur (`login.dart` içinde hem form ile hem de tek tıkla "Hızlı Seçim" butonlarıyla giriş yapılabilir):
  1. **Kiraya Veren (Araç Sahibi):** Kullanıcı Adı: `veren` | Şifre: `123`
  2. **Kiralayan (Kiracı):** Kullanıcı Adı: `alan` | Şifre: `123`
- **Temel İşleyiş ve Ekran Akışı:**
  1. **Araçlar ve Sosyal Akış (`views/araclar/`):**
     - `araclar.dart`: Kiralık araçların listelendiği ana akış. Kullanıcılar araçları sosyal medya gibi **beğenebilir (Like)**, yorum sayısını ve aracın şu an **Müsait** mi yoksa **Kirada** mı olduğunu (kimin kiraladığını) görebilir.
     - `arac_detay_ekrani.dart`: Aracın tüm teknik özellikleri, yılı, kira durumu, sahibinin güven skoru, araç hakkındaki sosyal yorumlar ve **"Hemen Kirala"** / **"Mesaj Gönder"** aksiyonları.
     - `arac_ekleme_ekrani.dart`: Yeni araç ilanı ekleme formu (Model, yıl, fiyat, özellikler).
     - `arac_filtreleme_ekrani.dart`: **Sahibinden tarzı** detaylı araç filtreleme ekranı (Marka, Model, Yıl aralığı, Fiyat aralığı, Vites/Yakıt tipi, Sadece Müsait Araçlar filtresi).
  2. **Kiracılar ve Kiralayanlar (`views/kiracilar/`):**
     - Giriş yapan kullanıcının rolüne göre dinamik çalışır:
     - Kullanıcı **Kiraya Veren (`veren`)** ise `kiraci.dart` ekranı aktif olur: Aracını kiralayan kiracıları görür, kiracılara **güven skoru (1-5 yıldız)** verir ve haklarında yorum yazar.
     - Kullanıcı **Kiralayan (`alan`)** ise `kiralayan.dart` ekranı aktif olur: Araç kiraladığı sahipleri görür, kiralama geçmişini takip eder, araç sahiplerini puanlar ve yorumlar.
  3. **Mesajlar ve Güvenlik (`views/mesajlar/`):**
     - `mesajlar.dart`: Kiracı ve araç sahibi arasındaki sohbetlerin listesi.
     - `mesaj_detay_ekrani.dart`: Anlık lokal mesajlaşma ekranı.
     - `sikayet_ekrani.dart`: Merkeziyetsiz güven ortamını korumak için kullanıcı veya araç hakkında anlaşmazlık/şikayet bildirme ekranı.
  4. **Profil (`views/profil.dart`):**
     - Kullanıcının rol rozeti (Kiraya Veren / Kiralayan), profil resmi değiştirme/ekleme (hazır avatar/ikon seçici), aldığı toplam güven skoru, hakkındaki yorumlar, aktif kiraladığı/kiraya verdiği araçlar ve `login.dart` ekranına döndüren **Çıkış Yap** butonu.

---

## 2. Tasarım Dili ve Renk Kuralları (KIRMIZI ÇİZGİ)

- **KESİNLİKLE MOR RENKLİ BUTON YOKTUR:** Flutter'ın varsayılan `deepPurple` M3 rengi tamamen ezilecektir. Hiçbir butonda, switch'te, rozette veya arka planda mor/eflatun tonları KULLANILMAYACAKTIR.
- **Renk Paleti (`app_colors.dart`):**
  - **Ana Vurgu (Bordo / Crimson):** `#8B1E2F` (Canlı Koyu Bordo) ve `#5E111E` (Derin Şarap Bordosu).
  - **Arka Plan ve Yüzeyler (Siyah & Antrasit Gri):** `#0D0E11` (Karbon Siyahı), `#181A20` (Koyu Antrasit), `#262932` (Kurşun Gri).
  - **Metin ve İkon Görünürlüğü (Yüksek Kontrast Zorunluluğu):** Blur (buzlu cam) üzerinde yazıların sönük kalmaması için birincil metinler `#F8FAFC` (Net Beyaz), ikincil metinler `#CBD5E1` (Açık Gümüş Gri) olacaktır. Bordo butonların üzerindeki yazılar her zaman `#FFFFFF` ve `FontWeight.w600` olacaktır.
- **Liquid Glass (Akışkan Buzlu Cam):** Material 3 bileşenleri üzerine `BackdropFilter` (`ImageFilter.blur`), bordonun ve koyu grinin yarı saydam (`withValues(alpha: 0.18)`) tonları ve ince metalik gri cam kenarlıkları (`Border.all(color: Colors.white.withValues(alpha: 0.15))`) monte edilecektir.

---

## 3. Mimari Yapı ve Klasör Düzeni (Zorunlu Şablon)

Kodlar tam olarak aşağıdaki klasör yapısına sadık kalınarak üretilecektir:

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart                  # Bordo, siyah, gri ve yüksek kontrastlı metin renkleri (Mor yok!)
│   ├── theme/
│   │   ├── app_theme.dart                   # Material 3 + Liquid Glass Bordo/Siyah/Gri tema tanımları
│   │   └── theme_controller.dart            # Reaktif tema kontrolcüsü
│   └── state/
│       └── user_profile_controller.dart     # Aktif kullanıcı (veren/alan), giriş/çıkış ve profil durumu
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
│   │   ├── login.dart                       # veren/123 ve alan/123 giriş + hızlı seçim ekranı
│   │   ├── araclar/
│   │   │   ├── araclar.dart                 # Araç vitrini ve sosyal beğeni akışı
│   │   │   ├── arac_detay_ekrani.dart       # Araç detay, kiralama ve yorum ekranı
│   │   │   ├── arac_ekleme_ekrani.dart      # Yeni kiralık araç ekleme formu
│   │   │   └── arac_filtreleme_ekrani.dart  # Sahibinden tarzı detaylı filtreleme ekranı
│   │   ├── kiracilar/
│   │   │   ├── kiraci.dart                  # Veren kullanıcı için: Kiracıları listeleme ve puanlama
│   │   │   └── kiralayan.dart               # Alan kullanıcı için: Araç sahiplerini listeleme ve puanlama
│   │   ├── mesajlar/
│   │   │   ├── mesajlar.dart                # Sohbet listesi ekranı
│   │   │   ├── mesaj_detay_ekrani.dart      # Mesajlaşma detay ekranı
│   │   │   └── sikayet_ekrani.dart          # Şikayet oluşturma ekranı
│   │   └── profil.dart                      # Profil resmi seçimi, skor, yorumlar ve Çıkış Yap ekranı
│   └── widgets/                             # Ortak Liquid Glass kartlar, butonlar ve modüler alt bileşenler
└── main.dart                                # Sadece uygulama başlatma ve tema/navigasyon bağlantısı
```

---

## 4. SOLID, OOP ve Kod Kalite Standartları

1. **`yapilanlar.md` İlerleme Takibi:**
   - Kodlamaya başlamadan önce kök dizinde `yapilanlar.md` oluşturulacak, her adım bittiğinde `[x]` olarak işaretlenip güncellenecektir.
2. **SOLID ve OOP Prensipleri:**
   - **Single Responsibility (Tek Sorumluluk):** Her sınıf, dosya ve fonksiyon yalnızca tek bir iş yapmalıdır.
   - **Uzun Kodları Parçalama Zorunluluğu:** Hiçbir `build` metodu **35-40 satırı** geçemez. Uzun ekranlar mutlaka anlamlı yardımcı metodlara (`_buildHeader()`, `_buildFilterBar()`) veya `lib/features/widgets/` altında ayrı widget sınıflarına bölünecektir.
   - **Kapsülleme (Encapsulation) ve Immutability:** Modellerde tüm alanlar `final` olmalı ve durum güncellemeleri `copyWith` üzerinden yapılmalıdır.
3. **Sıfır Harici Paket ve Reaktif State:**
   - Projeye harici paket eklenmeyecektir. Tüm durum yönetimi `ValueNotifier` ve `ValueListenableBuilder` ile sağlanacaktır.

---

## 5. Geliştirme ve Doğrulama Komutları

Her adım sonunda aşağıdaki komutla **0 hata ve 0 uyarı** doğrulaması yapılmalıdır:

```bash
flutter analyze
```
