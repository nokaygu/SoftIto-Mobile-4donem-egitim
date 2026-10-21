# VizyonMeet - Responsive Sosyal Video Konferans Platformu

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zeka asistanları ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** **VizyonMeet** (Gerçek Zamanlı Video Konferans, Oda İçi Sohbet ve Arkadaş Ağı)
- **Kullanılacak Paketler (`pubspec.yaml`):**
  - `agora_rtc_engine: ^6.3.2` (En güncel Agora v6.x mimarisi)
  - `permission_handler: ^11.3.1` (Kamera ve Mikrofon izin yönetimi)
  - _Not:_ State yönetimi, çoklu dil (TR/EN) ve tema yönetimi için harici paket kullanılmayacak, saf Flutter (`ValueNotifier`, `ValueListenableBuilder`) kullanılacaktır.
- **Agora Yapılandırması (Gerçek Değerler - Testing Mode):**
  - **App ID:** `7aad306718aa4fe1a09d2c2f9ba68136`
  - **Mod:** App ID Only (Testing Mode). `joinChannel` çağrılarında `token: ""` (boş string) gönderilecektir.
- **KIRMIZI ÇİZGİ - %100 Responsive ve Sıfır Sıkışma (Zero Overflow):**
  - Uygulamadaki **TÜM widget, buton, kart, dialog ve barlar tam responsive** olacaktır.
  - Ekran dikey (Portrait) veya yatay (Landscape) olduğunda, ya da küçük ekranlı cihazlarda hiçbir yazıda, butonda veya kart içinde sıkışma, taşma (`RenderFlex overflowed`) **KESİNLİKLE OLMAYACAKTIR**.
  - Metinlerde `Flexible`, `Expanded`, `FittedBox(fit: BoxFit.scaleDown)`, `maxLines` ve `TextOverflow.ellipsis`; buton ve kart dizilimlerinde `Wrap`, `LayoutBuilder` ve `SingleChildScrollView` kullanımı zorunludur.

---

## 2. Ekranlar ve Detaylı Kullanıcı Akışı

### 1. Giriş Ekranı (`views/login_view.dart`)

- **Örnek Kullanıcılar:**
  1. Kullanıcı Adı: `ali` | Şifre: `123`
  2. Kullanıcı Adı: `veli` | Şifre: `123`
- Kullanıcı adı ve şifre alanlarının yanı sıra, ekranın alt kısmında şık bir `Card` içinde tek tıkla giriş sağlayan **"Hızlı Giriş: ali / 123"** ve **"Hızlı Giriş: veli / 123"** seçenekleri bulunur.
- Ayrıca hızlı test için doğrudan bir **"Oda Adı (Channel Name)"** girip **"Katıl"** diyerek girişle birlikte doğrudan odaya bağlanma opsiyonu da sunulur.

### 2. Ana İskelet ve Alt Navigasyon Barı (`views/main_shell_view.dart`)

Giriş sonrasında altta 4 sekmeli modern bir `BottomNavigationBar` yer alır (Konferans odasına girildiğinde bu bar tamamen gizlenir):

1. **Sekme 1 - Konferans Oluştur / Katıl (`views/conference/conference_lobby_view.dart`):**
   - Kullanıcıdan bir **'Oda Adı (Channel Name)'** isteyen metin kutusu ve modern **'Katıl / Konferans Oluştur'** butonu.
   - Odaya girmeden önce hızlı mikrofon/kamera açık-kapalı tercihi ve aktif avatar önizlemesi.
2. **Sekme 2 - Arkadaşlar (`views/friends/friends_view.dart`):**
   - Mevcut arkadaşların listesi (Avatarları, çevrimiçi durumları).
   - Her arkadaş kartında iki aksiyon butonu:
     - **Doğrudan Video Konferans Başlat:** Ortak bir oda adı oluşturup anında video konferans ekranına yönlendirir.
     - **Özel Mesaj / Konferans Talebi Gönder:** Arkadaşa özel mesaj ve oda davet linki/kodu gönderen pencere açar.
3. **Sekme 3 - Ayarlar (`views/settings/settings_view.dart`):**
   - **Mikrofon Ayarları:** Mikrofon izin durumu kontrolü, **Mikrofon Test Et** butonu (canlı ses seviyesi/desibel barı simülasyonu ve Agora ses seviyesi ayarı) ve Mikrofon Ses Seviyesi (`Slider` - 0% ile 200% arası `adjustRecordingSignalVolume`).
   - **Kamera Ayarları:** Kamera izin durumu kontrolü, **Kamera Test Et** alanı (canlı önizleme/test kutusu), Ön/Arka kamera yönü değiştirme ve ayna (mirror) modu seçimi.
   - **Dil Ayarları:** Sadece **Türkçe (TR)** ve **İngilizce (EN)** seçenekleri. Seçildiği anda tüm uygulamanın metinleri anında seçilen dile dönüşür.
4. **Sekme 4 - Profilim (`views/profile/profile_view.dart`):**
   - **Avatar Seçimi (5 Özel Avatar):** Kullanıcının seçebileceği 5 farklı özel tasarım avatar. Seçilen avatar hem profilde hem arkadaş listesinde hem de **Konferans Odası ekranında** (kullanıcı kamerası kapalıyken veya video kartı köşesinde) görünür.
   - **Tema Seçimi (4 Kapsamlı Tema):** Şık bir `Card` içinde yan yana/grid şeklinde **4 adet tema ikonu**. Tıklandığında uygulamanın tüm renkleri (`primary`, `secondary`, `button`, `fail`, `surface`, `text`) anında değişir:
     1. _Tema 1:_ Kırmızı - Siyah Neon (Crimson Cyber Neon)
     2. _Tema 2:_ Solarized Light (Orijinal Solarized Açık Palet)
     3. _Tema 3:_ Nordic Aurora Dark (Kuzey Işıkları Gece Paleti)
     4. _Tema 4:_ Emerald Matrix (Zümrüt Okyanus Paleti)
   - **Çıkış Yap:** Oturumu kapatıp güvenli şekilde `login_view.dart` ekranına yönlendirir.

### 3. Konferans Odası Ekranı (`views/conference/conference_room_view.dart`)

- **Tam Ekran Deneyimi:** Alt navigasyon barı (`BottomNavigationBar`) ve gereksiz tüm barlar bu ekranda gizlenir.
- **Yatay Ekran (Landscape) Uyarısı:** Kullanıcı odaya girdiğinde cihaz dikey (`Orientation.portrait`) konumdaysa, ekranı yatay (`landscape`) konuma çevirmesini öneren şık bir **SnackBar uyarısı** gösterilir.
- **Dinamik Video Grid (`GridView`):**
  - Odadaki tüm kullanıcıların (yerel kullanıcı + Agora `remoteUids`) videoları katılımcı sayısına göre dinamik ve responsive bir `GridView` içinde gösterilir.
  - Kamerası kapalı olan katılımcıların kutusunda seçtikleri **Avatar** ve kullanıcı adları gösterilir.
- **Alt Modern Yuvarlak Kontrol Butonları:**
  - Ekran dikey veya yatay çevrildiğinde de pozisyonunu koruyan, sıkışma yapmayan alt kontrol barı:
    1. **Mikrofon Aç / Kapat**
    2. **Kamera Aç / Kapat**
    3. **Ön / Arka Kamera Değiştir**
    4. **Sohbet Panelini Aç / Kapat**
    5. **Aramadan Ayrıl** (Temanın `fail` renginde belirgin buton)
- **Konferansa Özel Chat Ekranı ve Kullanıcı Etkileşimi:**
  - Yatay modda sağ panelde, dikey modda alt/yan açılır panelde odaya özel canlı sohbet alanı bulunur.
  - **Sohbette Kullanıcı Adına Tıklama Özelliği:** Chat ekranında mesaj yazan herhangi bir kullanıcının adına veya avatarına tıklandığında açılan menüden o kişi **"Arkadaş Olarak Eklenebilir"** veya kendisine **"Özel Mesaj / Konferans İsteği"** gönderilebilir.

---

## 3. İzin Yönetimi (iOS & Android Zorunluluğu)

- Uygulama açılışında, Konferans Odasına girerken ve Ayarlar > Kamera/Mikrofon test ekranlarında `permission_handler` ile `Permission.camera` ve `Permission.microphone` izinleri kontrol edilir.
- İzin verilmemişse her zaman `request()` ile izin istenir; kalıcı olarak reddedilmişse kullanıcıya ayarları açma (`openAppSettings`) uyarısı gösterilir.
- `android/app/src/main/AndroidManifest.xml` içine `INTERNET`, `CAMERA`, `RECORD_AUDIO`, `MODIFY_AUDIO_SETTINGS`, `BLUETOOTH`, `ACCESS_NETWORK_STATE` izinleri; `ios/Runner/Info.plist` içine `NSCameraUsageDescription` ve `NSMicrophoneUsageDescription` anahtarları mutlaka eklenecektir.

---

## 4. Klasör Yapısı (Zorunlu Şablon)

```text
lib/
├── core/
│   ├── constants/
│   │   ├── agora_config.dart          # App ID: 7aad306718aa4fe1a09d2c2f9ba68136 ve kanal ayarları
│   │   └── avatar_constants.dart      # 5 özel avatar tanımı (ikon, renk, başlık)
│   ├── localization/
│   │   ├── app_strings.dart           # Türkçe ve İngilizce tam sözlük
│   │   └── language_controller.dart   # Reaktif dil kontrolcüsü (TR / EN)
│   ├── permissions/
│   │   └── permission_service.dart    # Kamera ve mikrofon izin kontrol/istek servisi
│   ├── theme/
│   │   ├── app_theme_model.dart       # Primary, secondary, button, fail vb. tam renk modeli
│   │   ├── app_themes.dart            # 4 Temanın (Kırmızı-Siyah Neon, Solarized Light vb.) tanımları
│   │   └── theme_controller.dart      # Reaktif 4'lü tema kontrolcüsü
│   └── state/
│       └── app_state.dart             # Tekil (Singleton) controller erişim merkezi
├── features/
│   ├── controllers/
│   │   ├── auth_controller.dart       # ali/123 ve veli/123 giriş, avatar ve profil yönetimi
│   │   ├── conference_controller.dart # Agora v6.x motoru, kamera/mikrofon, oda içi chat yönetimi
│   │   ├── friends_controller.dart    # Arkadaş listesi, arkadaş ekleme, özel mesaj ve çağrı daveti
│   │   └── settings_controller.dart   # Mikrofon/kamera test durumu ve ses seviyesi ayarları
│   ├── models/
│   │   ├── user_model.dart            # Kullanıcı, seçili avatar (0-4), durum modeli
│   │   ├── chat_message_model.dart    # Oda içi ve özel mesaj modeli
│   │   └── friend_model.dart          # Arkadaş ve özel davet modeli
│   ├── views/
│   │   ├── login_view.dart            # Giriş + ali/123 & veli/123 hızlı giriş kartı + hızlı oda katılımı
│   │   ├── main_shell_view.dart       # 4 sekmeli BottomBar ana yapısı
│   │   ├── conference/
│   │   │   ├── conference_lobby_view.dart # Oda adı girme ve konferans başlatma/katılma ekranı
│   │   │   └── conference_room_view.dart  # Dinamik Video Grid, Yuvarlak Butonlar ve Oda İçi Chat
│   │   ├── friends/
│   │   │   └── friends_view.dart      # Arkadaşlar listesi, doğrudan arama ve özel mesaj
│   │   ├── settings/
│   │   │   └── camera_settings.dart     # Mikrofon testi/seviyesi, kamera testi ve TR/EN dil seçimi
│   │   │   └── microphone_settings.dart
│   │   │   └── language_settings.dart
│   │   └── profile/
│   │       └── profile_view.dart      # 5 Avatar seçimi, 4 İkonlu Tema Kartı ve Çıkış Yap
│   └── widgets/
│       ├── responsive_wrapper.dart    # Taşma önleyici responsive yardımcı bileşenler
│       ├── video_grid_tile.dart       # Kamera açıkken AgoraVideoView, kapalıyken Avatar gösteren kutu
│       ├── call_control_bar.dart      # Yuvarlak modern kontrol butonları (Mikrofon, Kamera, Çevir, Ayrıl)
│       └── room_chat_panel.dart       # Kullanıcı adına tıklayınca arkadaş ekleyen konferans chat paneli
└── main.dart
```

---

## 5. Geliştirme, `yapilanlar.md` ve Doğrulama Kuralları

1. Kodlamaya başlamadan önce kök dizinde `yapilanlar.md` oluşturulacak ve her adım tamamlandıkça `[x]` olarak güncellenecektir.
2. Her adım sonunda `flutter analyze` çalıştırılarak **0 hata ve 0 uyarı** doğrulaması yapılacaktır.
