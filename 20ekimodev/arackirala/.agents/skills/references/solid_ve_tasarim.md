# SOLID Prensipleri ve Bordo-Siyah Liquid Glass Kontrast Rehberi

## 1. Bordo - Siyah - Gri Renk ve Kontrast Tablosu (`app_colors.dart`)

Blur (buzlu cam) kullanılan ekranlarda yazıların okunurluğu en kritik konudur. Aşağıdaki renk kodları standart olarak kullanılmalıdır:

- `backgroundDark`: `Color(0xFF0B0C0E)` (Derin Karbon Siyahı)
- `backgroundSecondary`: `Color(0xFF16181D)` (Koyu Antrasit Gri)
- `burgundyPrimary`: `Color(0xFF8B1E2F)` (Ana Bordo - Tüm ana butonlar ve aktif seçimler)
- `burgundyAccent`: `Color(0xFFB8293D)` (Parlak Bordo - Rozetler, vurgu kenarlıkları ve beğeni ikonu)
- `glassSurface`: `Color(0xB31E2028)` (%70 opaklıkta koyu dumanlı gri cam yüzeyi - yazıların net okunmasını sağlar)
- `glassBorder`: `Color(0x33FFFFFF)` (%20 opaklıkta keskin gümüş cam çerçevesi)
- `textPrimary`: `Color(0xFFF8FAFC)` (Tam okunur parlak beyaz)
- `textSecondary`: `Color(0xFFCBD5E1)` (Yüksek kontrastlı açık gümüş gri - asla koyu gri üzerine koyu gri yazı yazma!)

## 2. OOP ve Fonksiyon Parçalama Kuralları

- **Kural 1 (Metod Uzunluğu):** Hiçbir metod 30-35 satırı geçmemelidir. Karmaşık bir form veya liste öğesi varsa kendi özel metoduna (`_buildPriceBadge()`, `_buildUserScoreRow()`) ayrılmalıdır.
- **Kural 2 (Single Responsibility):** `AracController` yalnızca araç listesi, filtreleme, beğeni ve kiralama durumunu yönetir. Kullanıcı oturumu ve profil işlemleri `UserProfileController` içinde tutulur.
- **Kural 3 (Rol Tabanlı Görünüm Ayrımı):** `kiracilar` sekmesine tıklandığında `UserProfileController` içindeki aktif kullanıcının `rol` alanı kontrol edilir; kullanıcı `veren` ise `kiraci.dart`, `alan` ise `kiralayan.dart` bileşeni yüklenir.
