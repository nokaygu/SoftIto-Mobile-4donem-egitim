# Habit Sailer - "Zinciri Kırma ⚡" Alışkanlık ve Görev Takip Uygulaması

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zeka asistanları ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

---

## 1. BİRİNCİ DERECE KIRMIZI ÇİZGİLER (İHLAL EDİLEMEZ)

1. **TEK İŞ = TEK WIDGET KURALI (DRY - Don't Repeat Yourself):**
   - Uygulamada aynı işi yapan iki ayrı widget **KESİNLİKLE YAZILMAYACAKTIR**.
   - **Görev Kartı (`HabitTaskCard`):** Bugün, Planlananlar, Ajanda Gün Detayı ve Görevlerimi Düzenle ekranlarının tamamında **aynı `HabitTaskCard` widget'ı** kullanılacaktır.
   - **Görev Ekleme / Düzenleme BottomSheet (`TaskFormBottomSheet`):** Ajanda'dan güne özel görev eklerken, Görevle sayfasından yeni görev yaratırken ve mevcut görevi düzenlerken **aynı `TaskFormBottomSheet` widget'ı** kullanılacaktır.
   - **Kullanıcı Avatar Rozeti (`UserAvatarBadge`):** Profil, Görevle üst barı ve Liderlik Tablosu'nda **aynı avatar widget'ı** kullanılacaktır.

2. **TEMA DOSYASI DIŞINDA SIFIR RENK KURALI (ZERO HARDCODED COLOR):**
   - `lib/core/theme/app_theme.dart` dosyası dışındaki **HİÇBİR `.dart` dosyasında** `Color(0x...)`, `Colors.blue`, `Colors.white`, `Colors.black`, `Color.fromRGBO` vb. doğrudan renk tanımlaması **KESİNLİKLE BULUNMAYACAKTIR**.
   - Tüm widget'lar arka plan, metin, kenarlık, gölge, zorluk seviyesi (bebek mavisi, normal mavi, lacivert), slogan şimşek sarısı ve streak neon renklerini **yalnızca** `Theme.of(context).colorScheme` (`primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`, `secondary`, `onSecondary`, `surface`, `onSurface`, `surfaceContainerHighest`, `outline`, `outlineVariant`, `error`, `onError`) ve tema dosyasındaki `HabitSailerThemeExtension` üzerinden alacaktır.

3. **EN SERT `flutter analyze` VE LINT KURALLARI:**
   - `analysis_options.yaml` içinde en sıkı kurallar (`prefer_const_constructors`, `prefer_const_declarations`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `prefer_final_fields`, `prefer_final_locals`, `use_key_in_widget_constructors`) aktif olacaktır.
   - Hiçbir `deprecated` (kullanımdan kalkmış) API (`withOpacity`, `MaterialStateProperty`, `WillPopScope` vb.) kullanılmayacak; güncel Flutter API'leri (`withValues(alpha: ...)`, `WidgetStateProperty`, `PopScope`) kullanılacaktır.

4. **SADECE İZİN VERİLEN PAKETLER (BAŞKA KÜTÜPHANE YOK):**
   - Kimlik ve oturum bilgileri için: `flutter_secure_storage`
   - Görevler, tekrarlama günleri, ajanda kayıtları ve streak (zincir) puanları için: `hive` ve `hive_flutter`
   - Bunun dışında hiçbir harici UI, takvim, ikon veya state paketi **EKLENMEYECEKTİR**.

5. **%100 RESPONSIVE VE YAZI/ARKA PLAN KONTRAST UYUMU:**
   - Farklı ekran boyutlarında hiçbir kartta, haftanın günleri seçicisinde, takvim hücresinde veya butonda yazı sıkışması/taşması (`RenderFlex overflowed`) olmayacaktır.
   - Bebek mavisi ve açık sarı yüzeylerin üzerinde koyu deniz laciverti (`onPrimaryContainer` / `onSurface`) metinler; koyu mavi ve lacivert (acil/zor) yüzeylerin üzerinde ise parlak beyaz (`onPrimary`) metinler kullanılarak kusursuz okunabilirlik sağlanacaktır.

---

## 2. Marka Kimliği: Logo ve Slogan ("Habit Sailer - Zinciri Kırma ⚡")

- **Genel Atmosfer:** Açık denizlerde ferah bir yelken gezintisine çıkıyormuş hissi veren **Bebek Mavisi / Deniz Mavisi** ana palet.
- **Logo & Slogan Widget'ı (`HabitSailerBrandHeader`):**
  - Mobil arayüzde (Giriş sayfası, AppBar vb.) görünür şekilde; bebek mavisi/deniz mavisi yelkenli rozeti ve hemen yanında **açık sarı şimşek (`⚡`)** efektiyle parlayan **"Zinciri Kırma"** slogan bandı yer alır.

---

## 3. Ekranlar ve Detaylı Kullanıcı Akışı

### 1. Giriş ve Üye Olma Ekranı (`views/auth/login_view.dart`)

- Üstte **Habit Sailer** logosu ve açık sarı şimşekli **"Zinciri Kırma ⚡"** slogan görseli yer alır.
- **Giriş Formu:** E-posta alanı **YOKTUR**. Sadece **İsim (Kullanıcı Adı)** ve **Şifre** ile giriş yapılır.
- **Üye Ol (`ModalBottomSheet`):** Kullanıcı "Üye Ol" butonuna tıklarsa alttan şık bir `BottomSheet` açılır. Sadece **İsim** ve **Şifre** girerek kayıt olur. Bilgiler `flutter_secure_storage` içine güvenli şekilde kaydedilir ve doğrudan giriş yapılır.

### 2. Alt Navigasyon Barı (`BottomNavigationBar` - 4 Ana Sekme)

Giriş yapıldıktan sonra altta sırasıyla şu 4 sekme görünür olur:

1. **Bugün** (`views/today/today_view.dart`)
2. **Ajanda** (`views/agenda/agenda_view.dart`)
3. **Görevle** (`views/tasks/tasks_hub_view.dart`)
4. **Profil** (`views/profile/profile_view.dart`)

### 3. Evrensel Görev Kartı (`widgets/habit_task_card.dart`)

Tüm sayfalarda kullanılan tek, büyük, derinlikli ve görsel olarak çekici kart:

- **Tekrarlayan Görev İkonu:** Görev tekrarlayansa kartın üst/yan kısmında dönen ok ikonu (`Icons.loop_rounded`) yer alır.
- **Saat Bilgisi:** Saat seçildiyse şık bir rozet içinde (`09:00` vb.) gösterilir.
- **Zorluk / Önem Rengi ve Derinlikli Gölge (3 Seviye):**
  1. _Seviye 1 (Bebek Mavisi):_ Yumuşak bebek mavisi arka plan, koyu lacivert metin.
  2. _Seviye 2 (Normal Deniz Mavisi):_ Canlı deniz mavisi arka plan, net kontrastlı metin.
  3. _Seviye 3 (Lacivert - Acil/Zor):_ Derin lacivert arka plan, parlak beyaz metin ve **daha derin/belirgin border gölgesi (`BoxShadow`)**.
- **Streak (Zincir) Puanı Rozeti:** Tekrarlayan görevlerin üst kısmında mevcut streak puanı (`⚡ 7 Günlük Seri` vb.) bulunur. Streak puanı yükseldikçe bu rozetin rengi temadan gelen **daha neon ve çekici** (açık sarı şimşek / neon camgöbeği) bir tona dönüşür.

### 4. Sekme 1: Bugün Sayfası (`views/today/today_view.dart`)

- Günün aktif görevleri büyük `HabitTaskCard` bileşenleriyle listelenir ve tamamlandıkça zincir (streak) puanı `Hive` üzerinde artar.
- **Planlananlar (Yaklaşan Görevler) Alt Sayfası/Bölümü:** Sayfanın üst kısmındaki sekme/geçiş alanı üzerinden **"Planlananlar"** görünümüne geçilebilir; burada yaklaşan görevler listelenir.

### 5. Sekme 2: Ajanda Sayfası (`views/agenda/agenda_view.dart`)

- `Hive` veritabanı ile tam entegre, özel tasarım estetik takvim arayüzü.
- **Takvim Gün Hücreleri:**
  - Görev olan günlerde, görev başlıklarının **ilk kelimesi** gün kutusunun içinde kısa etiket olarak görünür.
  - **Acil / Lacivert** görevlerin olduğu günler **Koyu Mavi**, **Sıradan** görevlerin olduğu günler **Bebek Mavisi** tonlarıyla renklendirilir.
- **Gün Detay Sayfası (`views/agenda/day_detail_view.dart`):**
  - Takvimde bir güne tıklandığında o günün detay sayfası açılır.
  - O güne ait tüm görevler listelenir ve kullanıcı **"Görev Ekle"** butonuna basarak açılan `TaskFormBottomSheet` ile doğrudan o güne özel yeni görev ekleyebilir.

### 6. Sekme 3: Görevle Sayfası (`views/tasks/tasks_hub_view.dart`)

- Üst barda kullanıcının seçtiği **Avatar** küçük bir ikon olarak görünür.
- **1. "Yeni Görev Yarat" Kartı:**
  - Tıklandığında önce **"Tekrarlayan Görev mi, Tekrarlamayan Görev mi?"** diye soran şık bir `Dialog` açılır.
  - Seçime göre `TaskFormBottomSheet` açılır:
    - Görev adı, isteğe bağlı saat seçimi ve **3 Renkli Zorluk İkonu (Bebek Mavisi, Normal Mavi, Lacivert)** seçimi bulunur.
    - Eğer **Tekrarlayan** seçildiyse: **Samsung Alarm mantığında** haftanın günlerinin tek harfli yuvarlak simgelerle (**`P`, `S`, `Ç`, `P`, `C`, `C`, `P`**) listelendiği seçici görünür; kullanıcı tıklayarak hangi günlerde tekrarlanacağını seçer.
- **2. "Görevlerimi Düzenle" Düğmesi (`views/tasks/manage_tasks_view.dart`):**
  - Kayıtlı tüm görevler listelenir.
  - Göreve tıklanırsa `TaskFormBottomSheet` düzenleme modunda açılır.
  - Çarpı (`✕`) butonuna tıklanırsa silmeden önce **"Emin misiniz?"** onay diyaloğu çıkar. Eğer görev **tekrarlayan** bir görevse diyalogda _"Bu görev silinirse haftada X kez tekrarlanmayacak ve mevcut Y zincir puanınız sıfırlanacaktır"_ uyarısı gösterilir.

### 7. Sekme 4: Profil Sayfası (`views/profile/profile_view.dart`)

- **Avatar Seçimi:** Tıklanarak hazır verilen **5 Denizci/Yelkenli Avatarından** biri seçilir (Seçilen avatar Görevle sayfasında da küçük ikon olarak görünür).
- **Dashboard & Streak Leaderboard (`views/profile/leaderboard_dashboard_view.dart`):**
  - Kullanıcı "Dashboard / Liderlik Tablosu" kartına tıkladığında; tekrarlayan görevlerden topladığı **Toplam Streak Puanlarını**, kırılmayan zincir istatistiklerini ve diğer kaptanlarla yarıştığı **Liderlik Tablosunu (Leaderboard)** görür.
- **Ek Özellikler ve Çıkış:** Denizci Rütbesi (Toplam puana göre: _Tayfa, Dümenci, Açık Deniz Kaptanı_), hatırlatıcı bildirimi tercihi, şifre değiştirme ve **Çıkış Yap** butonu.

---

## 4. Klasör Yapısı (Zorunlu Şablon)

```text
lib/
├── core/
│   ├── constants/
│   │   └── avatar_constants.dart        # 5 Denizci Avatarının ikon ve başlık tanımları (Renk kodu içermez!)
│   ├── storage/
│   │   ├── secure_auth_storage.dart     # flutter_secure_storage ile üyelik ve oturum yönetimi
│   │   └── hive_task_storage.dart       # hive_flutter ile görev ve streak kalıcılığı
│   ├── theme/
│   │   └── app_theme.dart               # UYGULAMADAKİ TEK RENK DOSYASI (ColorScheme + HabitSailerThemeExtension)
│   └── state/
│       └── app_state.dart               # Tekil (Singleton) controller erişim merkezi
├── features/
│   ├── controllers/
│   │   ├── auth_controller.dart         # Giriş, Üye Ol, Avatar ve kullanıcı istatistikleri
│   │   └── task_controller.dart         # Hive tabanlı görev, ajanda, filtreleme ve streak hesaplamaları
│   ├── models/
│   │   ├── user_model.dart              # İsim, avatarIndex, toplam streak puanı modeli
│   │   └── habit_task_model.dart        # Görev, zorluk (0-2), tekrarlama günleri (1-7), saat, streak modeli
│   ├── views/
│   │   ├── auth/
│   │   │   └── login_view.dart          # Logo, Şimşek Slogan, Giriş ve BottomSheet Üye Ol ekranı
│   │   ├── main_shell_view.dart         # 4 Sekmeli BottomAppBar (Bugün, Ajanda, Görevle, Profil)
│   │   ├── today/
│   │   │   └── today_view.dart          # Bugün görevleri + Üstte Planlananlar (Yaklaşanlar) görünümü
│   │   ├── agenda/
│   │   │   ├── agenda_view.dart         # Hive entegreli, ilk kelime ve renk tonlu özel takvim
│   │   │   └── day_detail_view.dart     # Seçilen günün detay sayfası ve güne özel görev ekleme
│   │   ├── tasks/
│   │   │   ├── tasks_hub_view.dart      # Küçük avatar ikonu, Yeni Görev Yarat kartı, Görevlerimi Düzenle
│   │   │   └── manage_tasks_view.dart   # Tüm görevleri düzenleme ve detaylı onay ile silme ekranı
│   │   └── profile/
│   │       ├── profile_view.dart        # 5 Avatar seçimi, Denizci rütbesi, Dashboard geçişi ve Çıkış Yap
│   │       └── leaderboard_dashboard_view.dart # Toplam Streak puanları ve Liderlik Tablosu
│   └── widgets/
│       ├── habit_sailer_brand_header.dart # Vektörel Yelkenli Logosu ve Açık Sarı Şimşek "Zinciri Kırma" Sloganı
│       ├── habit_task_card.dart           # TÜM SAYFALARDA KULLANILAN TEK GÖREV KARTI WIDGET'I
│       ├── task_form_bottom_sheet.dart    # TÜM SAYFALARDA KULLANILAN TEK GÖREV EKLEME/DÜZENLEME BOTTOMSHEET'İ
│       ├── weekday_selector_bar.dart      # Samsung Alarm tarzı tek harfli (P S Ç P C C P) gün seçici
│       └── user_avatar_badge.dart         # TÜM SAYFALARDA KULLANILAN TEK AVATAR ROZETİ WIDGET'I
└── main.dart
```
