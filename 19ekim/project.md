#Fitness su takip uygulaması
Bu döküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

#1.Proje özeti ve teknolojiler -**Uygulama adi:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması) -**Hedef Platformlar:** IOS ve Android öncelikli ardından web ve masaüstü prlatformları. Egzersiz iconları olan cardboxları ekranda ekleme çıkarma eklenebilir yanında button olur vs.

- ** Flutter SDK:** 3.29.0

- ** Dart SDK:** 3.0.0
- **Tasarım Dili:** Material 3, Koyu Tema(gece spor salonu paleti, dark obsidion & neon);

---

## Mimari yapı : Özellik bazlı

kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlancaktır.

```text
lib/
core/
extensionlar
        constants/app_colors.dart
        theme/app_theme.dart

    features/
        water_tracker/
            controller/
            models/
            view/
            widget/
        workout/
            controller/
            models/
            view/
            widget/

    main.dart
```

#### sadece uygulama başlatma ve tema bölümleri

## 3 Kırmızı çizgiler kod kalite standartları

1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setstate` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır
Büyük build methodları yasaktır 40 satırı geçen build metodları özel widgetlara yazılacaktır.

3- **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4 Geliştirme analiz ve test komutları

Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

- **Statik kod analizi(0 uyarı ve 0 hata şart):**

```bash
flutter analyze
```

- **Birim ve widget testleri:**
  ``bash
  flutter test

````
* **Projeyi çalıştırma:**
```bash
flutter run
````

## 5 Ajanın çıktı ve yanıt verme standartları

**Açıklamalar** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse dosyaları baştan basma; hedf satırları ve diff yapısını göster.
**Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.
