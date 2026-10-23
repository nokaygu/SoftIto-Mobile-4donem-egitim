# Tema Mimarisi, Renk Kontrast Kuralları, Responsive Tasarım ve Strict Lint Rehberi

Bu doküman, uygulamanın **tek renk kaynağı olan `lib/core/theme/app_theme.dart`** dosyasının kurallarını, metin-arka plan kontrast zorunluluklarını ve `analysis_options.yaml` kurallarını tanımlar.

---

## 1. Tek Renk Kaynağı Kuralı (`lib/core/theme/app_theme.dart`)

Uygulamada `app_theme.dart` dışında **HİÇBİR DOSYADA** renk sınıfı (`Colors` veya `Color`) kullanılamaz. Standart `ColorScheme` alanlarının tamamı (`primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`, `secondary`, `onSecondary`, `secondaryContainer`, `surface`, `onSurface`, `surfaceContainerHighest`, `outline`, `outlineVariant`, `error`, `onError`) eksiksiz tanımlanmalıdır:

- **`primary`:** `Color(0xFF0284C7)` (Canlı Açık Deniz Mavisi)
- **`onPrimary`:** `Color(0xFFFFFFFF)` (Parlak Beyaz)
- **`primaryContainer`:** `Color(0xFFE0F2FE)` (Ferah Bebek Mavisi Konteyner)
- **`onPrimaryContainer`:** `Color(0xFF082F49)` (Derin Okyanus Laciverti - Bebek mavisi üzerinde maksimum okunabilirlik)
- **`secondary`:** `Color(0xFF0EA5E9)` (Gökyüzü / Yelken Mavisi)
- **`onSecondary`:** `Color(0xFFFFFFFF)`
- **`surface`:** `Color(0xFFF0F9FF)` (Açık Deniz Köpüğü Beyazı/Mavisi)
- **`onSurface`:** `Color(0xFF0C4A6E)` (Koyu Denizci Laciverti Metin)
- **`surfaceContainerHighest`:** `Color(0xFFBAE6FD)` (Belirgin Bebek Mavisi Yüzey)
- **`outline`:** `Color(0xFF38BDF8)` (Deniz Mavisi Kenarlık)
- **`outlineVariant`:** `Color(0xFF7DD3FC)` (Yumuşak Mavi Kenarlık ve Hafif Gölge)
- **`error`:** `Color(0xFFDC2626)`
- **`onError`:** `Color(0xFFFFFFFF)`

### Özel Tema Eklentisi (`HabitSailorThemeExtension`)

3 zorluk seviyesi, takvim gün tonları, açık sarı şimşek sloganı ve yükseldikçe neonlaşan streak rozetleri için `ThemeExtension` içinde şu renkler ve yardımcı metodlar yer alır:

1. **Zorluk 0 (Bebek Mavisi - Sıradan):**
   - Arka Plan: `Color(0xFFE0F2FE)` | Metin (`Foreground`): `Color(0xFF082F49)` | Border: `Color(0xFF7DD3FC)`
2. **Zorluk 1 (Normal Deniz Mavisi - Orta):**
   - Arka Plan: `Color(0xFF38BDF8)` | Metin (`Foreground`): `Color(0xFF082F49)` | Border: `Color(0xFF0284C7)`
3. **Zorluk 2 (Lacivert - Acil / Yüksek Önem):**
   - Arka Plan: `Color(0xFF0F172A)` (Derin Lacivert) | Metin (`Foreground`): `Color(0xFFF8FAFC)` (Net Beyaz) | Border: `Color(0xFF38BDF8)` | Derin Gölge (`deepNavyShadow`): `Color(0x66082F49)`
4. **Slogan Açık Sarı Şimşek (`lightningYellow`):**
   - Şimşek Sarısı: `Color(0xFFFDE047)` | Slogan Rozet Arka Planı: `Color(0xFF0C4A6E)` | Slogan Metni: `Color(0xFFFEF08A)`
5. **Streak (Zincir) Neon Seviye Fonksiyonu (`streakNeonColor(int streak)`):**
   - `streak < 3`: `Color(0xFFBAE6FD)` (Başlangıç Mavisi)
   - `3 <= streak < 7`: `Color(0xFF22D3EE)` (Canlı Camgöbeği)
   - `streak >= 7`: `Color(0xFFFACC15)` / `Color(0xFF00F5D4)` (Parlak Neon Sarı-Turkuaz Şimşek Tonu, metin rengi `0xFF082F49`)

---

## 2. Yazı & Arka Plan Kontrastı ve %100 Responsive Kuralları

1. **Kontrast Garantisi:**
   - Açık mavi / bebek mavisi (`difficulty == 0` veya `surface`) kartların ve takvim günlerinin üzerinde **asla beyaz veya açık gri yazı kullanılmaz**; her zaman koyu lacivert (`onPrimaryContainer` / `onSurface`) kullanılır.
   - Lacivert / koyu mavi (`difficulty == 2` veya acil görevli takvim günü) üzerinde **asla koyu yazı kullanılmaz**; her zaman `onPrimary` (net beyaz) kullanılır.
2. **Sıfır Sıkışma (Responsive Layout):**
   - Ajanda takvim hücrelerinde görevlerin ilk kelimesi gösterilirken `FittedBox(fit: BoxFit.scaleDown)` veya `maxLines: 1, overflow: TextOverflow.ellipsis` kullanılır.
   - Samsung alarm tarzı 7 günlük seçici (`P S Ç P C C P`) `Row` içinde `Expanded` veya `LayoutBuilder` ile ekran genişliğine göre esnek boyutlandırılır, küçük ekranlarda asla taşmaz.
   - Tüm BottomSheet'ler `isScrollControlled: true` ve `Padding(padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom))` ile klavye açıldığında taşmayacak şekilde sarmalanır.

---

## 3. En Sert `analysis_options.yaml` Kuralları

`analysis_options.yaml` dosyasında aşağıdaki kurallar aktif edilmeli ve `flutter analyze` çıktısı **0 issue** olmalıdır:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    deprecated_member_use: error
    prefer_const_constructors: error
    prefer_const_declarations: error
    unused_import: error
     unused_local_variable: error

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_final_fields
    - prefer_final_locals
    - avoid_print
    - avoid_unnecessary_containers
    - use_key_in_widget_constructors
    - sized_box_for_whitespace
```
