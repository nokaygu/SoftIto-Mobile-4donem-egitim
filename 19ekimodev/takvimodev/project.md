# Günce - Dijital Günlük ve Takvim Uygulaması

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zeka asistanları ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** **Günce** (Modern Dijital Günlük ve Anı Takvimi Uygulaması)
- **Temel İşleyiş:** Kullanıcıyı estetik, özel tasarım bir takvim karşılar. Takvim üzerinden herhangi bir güne tıklandığında, o güne özel günlük yazma/okuma ekranı (veya alt paneli) açılır. Kullanıcı o günün ruh halini (mood) seçebilir ve anılarını kaydedebilir. Günlük yazılmış günler takvim üzerinde zarif bir işaretçi (nokta/renk) ile belli olur.
- **Hedef Platformlar:** iOS ve Android öncelikli; ardından Web ve Masaüstü platformları (Responsive yapı).
- **Flutter SDK:** 3.29.0
- **Tasarım Dili:** Material 3, Çift Tema Desteği:
  - **Aydınlık Tema (Sıcak Parşömen Paleti):** Göz yormayan krem/kağıt beyazı arka plan (`#FAF8F5`), mürekkep kahvesi/antrasit metinler, adaçayı yeşili ve sıcak kiremit rengi (terracotta) vurgu tonları.
  - **Koyu Tema (Gece Mürekkebi Paleti):** Derin gece mavisi/obsidyen arka plan (`#121316`), yumuşak kırık beyaz metinler, sıcak kehribar (amber/gold) ve pastel lavanta vurgu tonları.
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
│   └── utils/
│       └── calendar_date_utils.dart  # Saf Dart ile ay/gün hesaplama yardımcıları
├── features/
│   ├── calendar/                     # Özel tasarım takvim modülü
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── views/
│   │   └── widgets/
│   └── diary/                        # Günlük yazma, düzenleme ve okuma modülü
│       ├── controllers/
│       ├── models/
│       ├── views/
│       └── widgets/
└── main.dart                         # Sadece uygulama başlatma ve tema bağlantısı
```

---

## 3. Kırmızı Çizgiler ve Kod Kalite Standartları

### 1. Sıfır Harici Paket (Zero External Package) Kuralı
- **Takvim ve UI:** `table_calendar`, `syncfusion_flutter_calendar`, `intl` gibi harici paketler **KESİNLİKLE KULLANILMAYACAKTIR**.
- Takvim ızgarası (Grid), ay geçiş animasyonları, haftanın günleri başlıkları ve seçili gün efektleri tamamen Flutter'ın yerleşik `GridView.builder`, `PageView`, `AnimatedContainer`, `CustomPainter` ve Dart'ın `DateTime` API'leri kullanılarak sıfırdan, estetik bir şekilde kodlanacaktır.
- **State Yönetimi:** Projeye onay alınmadan harici state paketleri (`bloc`, `provider`, `riverpod`, `getx` vb.) **EKLENMEYECEKTİR**. Dart ve Flutter'ın çekirdek API'lerini (`ValueNotifier`, `ValueListenableBuilder`, `InheritedWidget`) kullanmak esastır.

### 2. State Yönetim Standartları
- Sayfa düzeyinde tüm ekranı yeniden çizen ağır `setState` **KULLANILMAYACAKTIR**.
- Yalnızca mikro düzeyde yerel arayüz durumunu yöneten (örneğin bir butonun basılma animasyonu veya `TextEditingController` odak durumu) küçük `StatefulWidget` yapılarına izin verilir.

### 3. UI, Estetik ve Performans Kuralları
- Statik olan tüm widget'larda `const` kullanımı zorunludur.
- Renk, gölge, kenar yuvarlaklığı (`BorderRadius`) ve metin stilleri kesinlikle widget içine sabit (hardcoded) yazılmayacak, `app_theme.dart` ve `app_colors.dart` üzerinden çekilecektir.
- Büyük `build` metodları yasaktır! **40 satırı geçen** `build` metodları derhal anlamlı özel alt widget'lara (`widgets/` klasörü altına) bölünecektir.
- Takvim görünümü sıkışık olmamalı; ferah boşluklar (`padding`), yumuşak geçişler (`AnimatedSwitcher` / `AnimatedContainer`) ve tipografik hiyerarşi ile modern bir kırtasiye/defter hissi vermelidir.

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
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka proje kök dizinine göre tıklanabilir dosya yolu ver (Örn: `lib/features/calendar/views/calendar_view.dart`).
- **Doğrulama:** Kod yazdıktan veya güncelledikten sonra kullanıcıya *"Şimdi `flutter analyze` komutu ile kod kalitesini doğrulayabilirsin."* şeklinde yönlendirme yap.
