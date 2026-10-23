# Habit Sailor - "Zinciri Kırma ⚡" Alışkanlık ve Görev Takip Uygulaması

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zeka asistanları ve yazılım geliştiriciler için bağlayıcı bir mimari kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

---

## 1. BİRİNCİ DERECE KIRMIZI ÇİZGİLER (İHLAL EDİLEMEZ)

1. **TEK İŞ = TEK WIDGET KURALI (DRY - Don't Repeat Yourself):**
   - Uygulamada aynı işi yapan iki ayrı widget **KESİNLİKLE YAZILMAYACAKTIR**.
   - **Görev Kartı (`HabitTaskCard`):** Bugün (Bitirilenler, Bugünün Rotası, Planlananlar), Ajanda Gün Önizlemesi, Ajanda Gün Detayı ve Görevlerimi Düzenle ekranlarının tamamında **aynı `HabitTaskCard` widget'ı** kullanılacaktır.
   - **Görev Ekleme / Düzenleme BottomSheet (`TaskFormBottomSheet`):** Ajanda'dan güne özel görev eklerken, Görevle sayfasından yeni görev yaratırken ve mevcut görevi düzenlerken **aynı `TaskFormBottomSheet` widget'ı** kullanılacaktır.
   - **Kullanıcı Avatar Rozeti (`UserAvatarBadge`):** Profil, Görevle üst barı ve Liderlik Tablosu'nda **aynı avatar widget'ı** kullanılacaktır.

2. **TEMA DOSYASI DIŞINDA SIFIR RENK KURALI (ZERO HARDCODED COLOR):**
   - `lib/core/theme/app_theme.dart` dosyası dışındaki **HİÇBİR `.dart` dosyasında** `Color(0x...)`, `Colors.blue`, `Colors.white`, `Colors.black`, `Color.fromRGBO` vb. doğrudan renk tanımlaması **KESİNLİKLE BULUNMAYACAKTIR**.
   - Tüm widget'lar renklerini **yalnızca** `Theme.of(context).colorScheme` ve tema dosyasındaki `HabitSailorThemeExtension` (`urgentNavyBg`, `urgentNavyFg`, `lightningYellow`, `onLightningBanner`, `deepNavyShadow` vb.) üzerinden alacaktır.

3. **EN SERT `flutter analyze` VE LINT KURALLARI:**
   - `analysis_options.yaml` içinde en sıkı kurallar (`prefer_const_constructors`, `prefer_const_declarations`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `prefer_final_fields`, `prefer_final_locals`, `use_key_in_widget_constructors`) aktif olacaktır.
   - Hiçbir `deprecated` (kullanımdan kalkmış) API (`withOpacity`, `MaterialStateProperty`, `WillPopScope` vb.) kullanılmayacak; güncel Flutter API'leri (`withValues(alpha: ...)`, `WidgetStateProperty`, `PopScope`) kullanılacaktır.
   - `ListTile` bileşenleri Material 3 standartlarına uygun olarak `Material` widget'ı içerisinde barındırılacaktır.

4. **SADECE İZİN VERİLEN PAKETLER (TEK TABANCA HIVE MİMARİSİ & SIFIR ANİMASYON PAKETİ):**
   - Tüm yerel depolama, kimlik, oturum, görevler, ajanda ve seyir defteri için: `hive` ve `hive_flutter`
   - Doğrulama mantığı için: Saf Dart (`lib/core/security/auth_validator.dart`)
   - Kutlama animasyonları için: Lottie/Rive kullanılmaz; saf Flutter `CustomPainter`, `Path`, `sin()` dalga fiziği ve `AnimationController` kullanılır (60 FPS vektör).

5. **SAĞLAM VE SADE KAYIT/OTURUM MİMARİSİ:**
   - Kullanıcı adı büyük/küçük harf duyarsız (`cleanName.toLowerCase()`) taranır; var olan kullanıcı adıyla **ikinci kez kayıt olunamaz**.
   - Kullanıcı bilgileri `habitsailor_users_box`, görevler `habitsailor_tasks_box`, seyir defteri `habitsailor_logs_box` kutusunda $O(1)$ erişimle saklanır.
   - Çoklu kullanıcı izolasyonu esastır: Her görev `HabitTaskModel.userId`, her seyir notu `CaptainLogModel.userId` ile etiketlenir.

6. **%100 RESPONSIVE VE KONTRAST UYUMU:**
   - Farklı ekran boyutlarında hiçbir kartta, gün seçicisinde, takvim hücresinde veya dialogda yazı sıkışması/taşması (`RenderFlex overflowed`) olmayacaktır.
   - Denizci renk paletinde okunabilirlik (contrast ratio) daima ön plandadır.

---

## 2. Marka Kimliği: Logo ve Slogan ("Habit Sailor - Zinciri Kırma ⚡")

- **Genel Atmosfer:** Açık denizlerde ferah bir yelken gezintisine çıkıyormuş hissi veren **Bebek Mavisi / Deniz Mavisi** ana palet.
- **Logo & Slogan Widget'ı (`HabitSailorBrandHeader`):**
  - Vektörel yelkenli rozeti ve hemen yanında **açık sarı şimşek (`⚡`)** efektiyle parlayan **"Zinciri Kırma"** slogan bandı.

---

## 3. Ekranlar ve Detaylı Kullanıcı Akışı

### 1. Giriş ve Üye Olma Ekranı (`views/auth/login_view.dart`)
- **Giriş Formu:** Kullanıcı Adı ve Şifre ile giriş yapılır.
- **Üye Ol (`ModalBottomSheet`):** İsim, Şifre ve Şifre Tekrarı. Var olan isimler anında engellenir. Şifreler tuzlanmış hash ile saklanır.

### 2. Alt Navigasyon Barı (`BottomNavigationBar` - 5 Ana Sekme)
Giriş yapıldıktan sonra altta sırasıyla şu 5 sekme yer alır:
1. **Bugün** (`views/today/today_view.dart`)
2. **Seyir Defteri** (`views/logbook/logbook_view.dart`)
3. **Ajanda** (`views/agenda/agenda_view.dart`)
4. **Görevle** (`views/tasks/tasks_hub_view.dart`)
5. **Profil** (`views/profile/profile_view.dart`)

### 3. Sekme 1: Bugün Sayfası (3 Sekmeli Rota ve Kutlama Akışı)
- **3 Sekmeli Rota:**
  1. _Bugün Bitirilenler:_ Tamamlanan görevler, kazanılan puanlar (`+10`, `+20`, `+30`, `+40 Puan ⚡`), seyir notları ve "Rotaya Geri Al ↩" seçeneği.
  2. _Bugünün Rotası (Varsayılan):_ Bugün yapılması gereken aktif bekleyen görevler. Kartlara tıklanarak tekli veya çoklu seçim yapılır.
  3. _Planlananlar:_ Gelecek günlere ait kilitli görevler (erken tamamlama kapalı).
- **"⚓ Rotayı Tamamla" Butonu & Onay Modalı:**
  - Sayfanın altında yüzen buton seçilen görev sayısını dinamik gösterir.
  - Tıklandığında kaptan onay modalı açılır; kullanıcı isterse buraya günün **Seyir Notu / Deneyimini** yazar.
- **Saf Flutter Vektörel Kutlama Animasyonları:**
  - _Günlük Tamamlama:_ `VoyageCelebrationDialog` ile matematiksel $\sin(x)$ dalgaları üzerinde neşeyle süzülen yelkenli ve parıldayan yıldızlar ("Hurray!").
  - _Haftalık Zafer:_ `HarborArrivalDialog` ile dönen deniz feneri, limana yanaşan yelkenli, suya inen ağır çapa ve `+50 Puan` bonusu.

### 4. Sekme 2: Kaptanın Seyir Defteri (`views/logbook/logbook_view.dart`)
- **Tarih Şeridi (Date Carousel):** Son günlerin kayıtları arasında hızlı geçiş veya tüm kayıtlar görünümü.
- **Görev Deneyimleri:** O gün tamamlanan görevler ve her göreve yazılmış deneyim notları parşömen kartlarında toplanır.
- **Kaptanın Serbest Seyir Notları:** Deniz durumu rozetleri (`☀️ Sakin Deniz`, `⛵ Pupayelken`, `🌊 Dalgalı`, `⚡ Fırtına`, `⚓ Liman Huzuru`), tarih/saat damgası, başlık ve serbest kaptan günlüğü yazısı. Düzenleme ve silme desteği tamdır.

### 5. Sekme 3: Seyir Ajandası (`views/agenda/agenda_view.dart`)
- **Akıllı Görev Özeti (Smart Snippets):** Dolgu/stop kelimeler elenerek takvim hücrelerinde gerçek görev içeriği ("Rota", "Dümen", "Fırtına", "Kitap") gösterilir.
- **İnteraktif Gün Önizlemesi (Master-Detail):** Takvimde bir güne tıklandığında ekran değişmeden hemen altta o günün tam görev listesi açılır; saat, seri ve aciliyet rozetleriyle net olarak incelenebilir.
- **Güne Görev Ekleme ve Gün Detay Sayfası (`views/agenda/day_detail_view.dart`):** Tek tıkla güne yeni görev ekleme veya detay sayfasına geçiş.

### 6. Sekme 4: Görevle Sayfası (`views/tasks/tasks_hub_view.dart`)
- Üst barda aktif kullanıcının avatarı görünür.
- **Yeni Görev Yarat:** Tekrarlayan / Tek Seferlik seçimi, Samsung Alarm tarzı gün seçici (`P S Ç P C C P`).
- **Görevlerimi Düzenle Ekranı (`views/tasks/manage_tasks_view.dart`):** Görev güncelleme ve detaylı onaylı silme.

### 7. Sekme 5: Profil Sayfası (`views/profile/profile_view.dart`)
- **Avatar Seçimi:** 5 Denizci Avatarı.
- **Dashboard & Leaderboard:** Gerçek kayıtlı kullanıcılar ve denizci mentorlar dinamik olarak sıralanır.
- **Güvenli Şifre Değiştirme:** Yeni şifre ve şifre tekrarı ile anında güncelleme.
- **Kalıcı Bildirim Tercihi** ve deklaratif **Çıkış Yap**.

---

## 4. Klasör Yapısı

```text
lib/
├── core/
│   ├── constants/
│   │   └── avatar_constants.dart             # 5 Denizci Avatarının tanımları
│   ├── security/
│   │   ├── auth_validator.dart               # Saf Dart kullanıcı adı ve şifre kuralları
│   │   └── password_security.dart            # Geriye dönük uyumluluk katmanı
│   ├── storage/
│   │   ├── hive_auth_storage.dart            # TEK TABANCA HIVE KULLANICI DEPOLAMA (habitsailor_users_box)
│   │   ├── hive_task_storage.dart            # O(1) görev ve kullanıcı veri izolasyonu (habitsailor_tasks_box)
│   │   ├── hive_log_storage.dart             # Kaptanın Seyir Defteri depolaması (habitsailor_logs_box)
│   │   └── secure_auth_storage.dart          # Geriye dönük uyumluluk takma adı (typedef)
│   ├── theme/
│   │   └── app_theme.dart                    # UYGULAMADAKİ TEK RENK DOSYASI (ColorScheme + HabitSailorThemeExtension)
│   └── state/
│       └── app_state.dart                    # Tekil controller erişimi ve oturum/görev/günlük senkronizasyon merkezi
├── features/
│   ├── controllers/
│   │   ├── auth_controller.dart              # Güvenli giriş, kayıt, şifre değiştirme, dinamik leaderboard
│   │   ├── task_controller.dart              # Görevler, streak hesabı, toplu tamamlama, akıllı özet ve notlar
│   │   └── logbook_controller.dart           # Kaptanın Seyir Defteri yönetimi ve günlük durumları
│   ├── models/
│   │   ├── user_model.dart                   # İsim, avatarIndex, toplam puan, bildirim tercihi
│   │   ├── habit_task_model.dart             # userId, zorluk, tekrarlama, streak, completionNotes
│   │   └── captain_log_model.dart            # userId, dateIso, title, content, weather, createdAtIso
│   ├── views/
│   │   ├── auth/
│   │   │   └── login_view.dart               # Logo, slogan, giriş ve şifre tekrarlı güvenli kayıt ekranı
│   │   ├── main_shell_view.dart              # 5 Sekmeli NavigationBar (Bugün, Seyir Defteri, Ajanda, Görevle, Profil)
│   │   ├── today/
│   │   │   └── today_view.dart               # 3 Sekmeli Rota + Toplu Tamamlama + Not Yazma
│   │   ├── logbook/
│   │   │   └── logbook_view.dart             # Kaptanın Seyir Defteri ve Günlük Deneyimleri
│   │   ├── agenda/
│   │   │   ├── agenda_view.dart              # Akıllı takvim + İnteraktif Gün Önizlemesi
│   │   │   └── day_detail_view.dart          # Seçilen günün detayı ve güne özel görev ekleme
│   │   ├── tasks/
│   │   │   ├── tasks_hub_view.dart           # Avatar ikonu, Yeni Görev Yarat, Görevlerimi Düzenle
│   │   │   └── manage_tasks_view.dart        # Tüm görevleri düzenleme ve silme ekranı
│   │   └── profile/
│   │       ├── profile_view.dart             # Avatar seçimi, rütbe, güvenli şifre değiştirme ve Çıkış Yap
│   │       └── leaderboard_dashboard_view.dart # Dinamik kullanıcı sıralaması ve streak istatistikleri
│   └── widgets/
│       ├── celebrations/
│       │   ├── voyage_celebration_dialog.dart # Saf Flutter CustomPainter dalga ve gemi yüzme ("Hurray!") animasyonu
│       │   └── harbor_arrival_dialog.dart     # Saf Flutter dönen deniz feneri ve çapa atma liman animasyonu
│       ├── habit_sailor_brand_header.dart    # Vektörel Yelkenli Logosu ve Şimşek "Zinciri Kırma" Sloganı
│       ├── habit_task_card.dart              # TÜM SAYFALARDA KULLANILAN TEK GÖREV KARTI WIDGET'I
│       ├── task_form_bottom_sheet.dart       # TÜM SAYFALARDA KULLANILAN TEK GÖREV EKLEME/DÜZENLEME BOTTOMSHEET'İ
│       ├── weekday_selector_bar.dart         # Samsung Alarm tarzı gün seçici (P S Ç P C C P)
│       └── user_avatar_badge.dart            # TÜM SAYFALARDA KULLANILAN TEK AVATAR ROZETİ WIDGET'I
└── main.dart                                 # Reaktif kök yapı (ListenableBuilder)
```
