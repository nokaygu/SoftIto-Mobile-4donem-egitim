# 4 Kapsamlı Tema, 5 Avatar, SOLID ve Responsive Tasarım Rehberi

Bu doküman, uygulamanın 4 temasının tüm renk paletlerini, 5 avatar tanımını, SOLID prensiplerini ve sıfır sıkışma (Responsive) kurallarını tanımlar.

---

## 1. 4 Kapsamlı Tema Paleti (`lib/core/theme/app_themes.dart`)

Profil ekranında bir `Card` içinde **4 adet seçilebilir ikon** olarak sunulacak temalar, uygulamadaki her bileşeni (`primary`, `secondary`, `background`, `surface`, `card`, `button`, `fail`, `success`, `textPrimary`, `textSecondary`) eksiksiz kapsar:

### Tema 1: Kırmızı - Siyah Neon (Crimson Cyber Neon) - _Varsayılan_

- **İkon:** `Icons.bolt_rounded`
- **Background:** `Color(0xFF08090C)` (Derin Siyah)
- **Surface / BottomBar:** `Color(0xFF12141C)` (Karbon Siyahı)
- **Card:** `Color(0xFF1A1D28)` (Koyu Antrasit Kart)
- **Primary / Button:** `Color(0xFFFF1E42)` (Neon Kızıl / Kırmızı)
- **Secondary:** `Color(0xFFFF5E7E)` (Parlak Mercan Kırmızı)
- **Fail / Aramadan Ayrıl:** `Color(0xFFD90429)` (Keskin Alarm Kırmızısı)
- **Success:** `Color(0xFF00F5D4)` (Neon Turkuaz Yeşil)
- **TextPrimary:** `Color(0xFFF8FAFC)` (Net Beyaz)
- **TextSecondary:** `Color(0xFF94A3B8)` (Metalik Açık Gri)

### Tema 2: Solarized Light (Orijinal Solarized Açık Tema)

- **İkon:** `Icons.wb_sunny_rounded`
- **Background:** `Color(0xFFFDF6E3)` (Solarized Base3 - Sıcak Krem)
- **Surface / BottomBar:** `Color(0xFFEEE8D5)` (Solarized Base2)
- **Card:** `Color(0xFFF7F0DC)` (Yumuşak Parşömen Kart)
- **Primary / Button:** `Color(0xFF268BD2)` (Solarized Mavi)
- **Secondary:** `Color(0xFF2AA198)` (Solarized Camgöbeği / Cyan)
- **Fail / Aramadan Ayrıl:** `Color(0xFFDC322F)` (Solarized Kırmızı)
- **Success:** `Color(0xFF859900)` (Solarized Yeşil)
- **TextPrimary:** `Color(0xFF073642)` (Solarized Base02 - Yüksek Kontrast Koyu)
- **TextSecondary:** `Color(0xFF586E75)` (Solarized Base01)

### Tema 3: Nordic Aurora Dark (Kuzey Işıkları Gece Paleti)

- **İkon:** `Icons.nights_stay_rounded`
- **Background:** `Color(0xFF242933)` (Nordik Gece Grisi)
- **Surface / BottomBar:** `Color(0xFF2E3440)` (Kutup Kayası)
- **Card:** `Color(0xFF3B4252)` (Buzul Kart Yüzeyi)
- **Primary / Button:** `Color(0xFF88C0D0)` (Buzul Mavi / Frost Cyan)
- **Secondary:** `Color(0xFF81A1C1)` (Arktik Mavi)
- **Fail / Aramadan Ayrıl:** `Color(0xFFBF616A)` (Aurora Kırmızısı)
- **Success:** `Color(0xFFA3BE8C)` (Aurora Yeşili)
- **TextPrimary:** `Color(0xFFECEFF4)` (Kar Beyazı)
- **TextSecondary:** `Color(0xFFD8DEE9)` (Buz Grisi)

### Tema 4: Emerald Matrix (Zümrüt Okyanus Paleti)

- **İkon:** `Icons.diamond_rounded`
- **Background:** `Color(0xFF061316)` (Derin Okyanus Siyahı)
- **Surface / BottomBar:** `Color(0xFF0B2025)` (Koyu Zümrüt Yüzey)
- **Card:** `Color(0xFF112E36)` (Zümrüt Kart)
- **Primary / Button:** `Color(0xFF10B981)` (Canlı Zümrüt Yeşili)
- **Secondary:** `Color(0xFF06B6D4)` (Akuamarin Mavi)
- **Fail / Aramadan Ayrıl:** `Color(0xFFF43F5E)` (Mercan Kırmızısı)
- **Success:** `Color(0xFF34D399)` (Parlak Nane Yeşili)
- **TextPrimary:** `Color(0xFFF0FDF4)` (Nane Beyazı)
- **TextSecondary:** `Color(0xFF99F6E4)` (Yumuşak Turkuaz Gri)

---

## 2. 5 Özel Avatar Tanımı (`lib/core/constants/avatar_constants.dart`)

Kullanıcıların Profil ekranından seçebileceği ve Konferans Odasında (kamera kapalıyken veya katılımcı kartında) görünecek 5 hazır avatar:

1. **Avatar 0 - Siber Pilot:** `Icons.rocket_launch_rounded` (Kızıl-Ateş Gradyan)
2. **Avatar 1 - Bilge Ninja:** `Icons.AutoAwesome` / `Icons.psychology_rounded` (Altın-Kehribar Gradyan)
3. **Avatar 2 - Kutup Kaşifi:** `Icons.ac_unit_rounded` (Buzul Mavi Gradyan)
4. **Avatar 3 - Zümrüt Hacker:** `Icons.terminal_rounded` (Zümrüt Yeşili Gradyan)
5. **Avatar 4 - Galaksi Kaptanı:** `Icons.public_rounded` (Kraliyet Mavisi-Turkuaz Gradyan)

---

## 3. SOLID ve Sıfır Sıkışma (Responsive) Kuralları

1. **Single Responsibility (SRP):**
   - `ConferenceController` yalnızca Agora video/ses akışlarını ve oda içi mesajları yönetir.
   - `PermissionService` yalnızca izin kontrolü ve talebinden sorumludur.
   - `LanguageController` yalnızca TR/EN metin dönüşümünü yönetir.
2. **Responsive Grid Hesaplaması:**
   - Konferans odasındaki `GridView`, katılımcı sayısına ve ekranın `Orientation` (Dikey/Yatay) durumuna göre `crossAxisCount` değerini dinamik belirler (Örn: Yatay modda yan yana 2 veya 3 sütun; dikey modda 1 veya 2 sütun).
3. **Sıfır Taşma Garantisi:**
   - Tüm kart başlıkları `Flexible` içinde `maxLines: 1, overflow: TextOverflow.ellipsis` ile korunur.
   - Tüm form ve ayar ekranları `SafeArea` + `SingleChildScrollView` (veya `ListView`) içinde yer alır; klavye açıldığında veya ekran yatay çevrildiğinde asla sarı-siyah taşma hatası vermez.
