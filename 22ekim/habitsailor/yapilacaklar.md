# Habit Sailor - Seyir Ajandası (Agenda) UI/UX Analizi ve Çözüm Planı

Bu belge, **Habit Sailor** uygulamasının "Seyir Ajandası" (`AgendaView`) ekranındaki mevcut kullanıcı deneyimi ve görsel tasarım kusurlarını, takvim hücrelerindeki anlamsız metin tekrarı sorununu ("Sabah" stop-word problemi) ve modern denizci temasına uygun yeni mimari çözüm planını detaylandırmaktadır.

---

## 1. Mevcut Durum Analizi ve Tespit Edilen Kusurlar

### 1.1. "Sabah Zart Zurt" Tekrarı (Stop-Word & Dumb First-Word Sorunu)
* **Kök Neden:** `TaskController.getFirstWordForDate(date)` fonksiyonu, o güne ait görev başlığını sadece boşluklardan bölüp ilk kelimeyi (`words.first`) almaktadır.
* **Sonuç:** Kullanıcıların veya demo görevlerin başlıkları çoğunlukla *"Sabah Rotasını ve Hedefleri Belirle"*, *"Sabah Egzersizi"*, *"Sabah Kitap Okuma"* gibi başladığı için; takvimdeki neredeyse **30 günün tamamında** hücrelerin içinde tekdüze ve bilgi vermeyen **"Sabah"** yazısı görünmektedir.
* **Etki:** Kullanıcıya o güne dair hiçbir gerçek bağlam veya ayırt edici bilgi sunulmamakta, arayüz prototip seviyesinde ve özensiz durmaktadır.

### 1.2. 7 Kolonlu Izgara Sıkışması ve Hücre Boğulması
* **Kök Neden:** Mobil ekran genişliği (360-400px) 7 eşit kolona bölündüğünde her gün hücresine yalnızca ~45-50px genişlik kalmaktadır.
* **Sonuç:** 45 piksellik alana hem gün numarası hem 9px fontlu arka planlı hap (chip) sığdırılmaya çalışılmakta; bu da hücreleri nefessiz, dar ve okunaksız hale getirmektedir.

### 1.3. İnteraktif Önizleme Eksikliği (Zorunlu Sayfa Değiştirme)
* **Kök Neden:** Kullanıcı takvimde bir güne baktığında o günün görevlerini görmek için mutlaka hücreye basıp ayrı bir sayfaya (`DayDetailView`) gitmek zorunda kalmaktadır.
* **Sonuç:** Ay genelinde gezinirken hangi gün ne olduğunu hızlıca taramak (browse & scan) imkansızdır.

### 1.4. Runtime ListTile DecoratedBox Uyarısı
* **Kök Neden:** Flutter Material 3'te `ListTile` bileşenleri doğrudan renkli bir `DecoratedBox` veya `Container` içine konulduğunda arka plan ve mürekkep (splash) efektleri kaybolmakta ve konsola exception basılmaktadır.
* **Çözüm:** Bileşenler `Material` widget'ı ile sarılarak çözülmelidir.

---

## 2. Mimari ve Tasarım Çözümü

### 2.1. Akıllı Görev Kırpma ve Anlamsız Kelimeleri Eleme Motoru (`Smart Task Snippets`)
`TaskController` içine akıllı bir metin analiz fonksiyonu eklenir:
1. Türkçe ve denizcilik bağlamındaki genel/dolgu kelimeler filtrelenir:
   `{'sabah', 'akşam', 'öğle', 'günlük', 'her', 've', 'bir', 'ile', 'için', 'yap', 'et'}`
2. Görev başlığındaki **eylem ve nesne odaklı ilk 1-2 anlamlı kelime** çıkarılır:
   - *"Sabah Rotasını ve Hedefleri Belirle"* ➔ **"Rotayı Belirle"** veya **"Rota"**
   - *"Acil Fırtına Tedbirleri ve Güverte Kontrolü"* ➔ **"Fırtına Tedbiri"**
   - *"Akşam Kitap Okuma"* ➔ **"Kitap Okuma"**
   - *"Dümen ve Seyir Kontrolü"* ➔ **"Dümen Kontrolü"**
3. Takvim hücresinde bu anlamlı anahtar kelime şık bir mikro-rozet olarak gösterilir.

### 2.2. Yeni Nesil Ajanda Arayüzü (Master-Detail Aynı Ekranda)
Ayrı bir sayfaya gitmeye gerek kalmadan takvimin hemen altına **"Seçili Günün Seyir Planı"** bölümü entegre edilir:

```
┌──────────────────────────────────────────────┐
│  ⛵ Habit Sailor - Seyir Ajandası           │
├──────────────────────────────────────────────┤
│  ◀            Ekim 2026            ▶  [Bugün] │
├──────────────────────────────────────────────┤
│  Pzt   Sal   Çar   Per   Cum   Cmt   Paz     │
│   1     2     3     4     5     6     7      │
│ [Rota]       [Dümen]   [Fırtına]             │
│   8     9    (10)   11    12    13    14     │
│ [Kitap]      [Pruva]                         │
├──────────────────────────────────────────────┤
│ ⚓ 10 Ekim Cuma Rotası (2 Görev)   [+ Görev]  │
│ ┌──────────────────────────────────────────┐ │
│ │ 🔵 Sabah Rotasını Belirle     08:00     │ │
│ │ ⚡ 5 Günlük Seri • Normal Görev          │ │
│ └──────────────────────────────────────────┘ │
│ ┌──────────────────────────────────────────┐ │
│ │ 🔷 Güverte ve Pruva Bakımı    14:30     │ │
│ │ ⚡ 8 Günlük Seri • Acil Görev           │ │
│ └──────────────────────────────────────────┘ │
└──────────────────────────────────────────────┘
```

### 2.3. Estetik ve Görsel İyileştirmeler (Denizci Teması)
1. **Ay Değiştirici Kartı:** Yumuşak köşeli, `primaryContainer` arka planlı, hızlı "Bugün" butonlu modern navigasyon bandı.
2. **Takvim Hücreleri:**
   - Bugün: Parlak şimşek sarısı (`lightningYellow`) dış çerçeve ve hafif parlama.
   - Seçili Gün: Denizci mavisi dolgulu ve seçili olduğunu belirten kalın vurgu.
   - Görev Durumu: Acil görev varsa derin lacivert (`urgentDayBg`), normal görev varsa açık deniz mavisi (`normalDayBg`).
   - Çoklu görev varsa minik `+X` rozeti veya renkli durum noktaları.
3. **Seçili Günün Görevleri Kartı:**
   - Seçilen güne tıklandığında anında alt listede o günün görevleri kartlar halinde açılır.
   - Görevin saati, zorluk rozeti, serisi ve tamamlanma durumu net biçimde okunur.
   - İstenirse tek tıkla güne yeni görev ekleme (`TaskFormBottomSheet`) ve detay ekranına geçme olanağı sunulur.

---

## 3. Uygulama Adımları

1. **`lib/features/controllers/task_controller.dart`:**
   - `getTaskSnippetForDate(DateTime date)` metodunun yazılması (dolgu kelimeleri atlayan akıllı 1-2 kelimelik özet).
   - `getTasksForDate(DateTime date)` ile tam görev listesinin reaktif entegrasyonu.
2. **`lib/features/views/agenda/agenda_view.dart`:**
   - Takvim Grid'inin temizlenmesi ve `childAspectRatio` oranının optimize edilmesi.
   - Hücre içi tasarımın güncellenmesi (anlamlı kelime rozeti + durum rozeti).
   - Takvimin altına dinamik **"Seçili Günün Rotası"** listesinin ve aksiyon butonlarının eklenmesi.
3. **`project.md` ve Diğer Belgelerin Senkronizasyonu:**
   - Yapılan tüm geliştirmelerin (Seyir Defteri, 5 sekmeli mimari, vektörel kutlamalar, yeni Ajanda tasarımı) `project.md` ve `yapilanlar.md` dosyalarına işlenmesi.
4. **Kalite Doğrulaması:**
   - `flutter analyze` ile 0 hata & 0 uyarı.
   - `flutter test` ile tüm testlerin yeşil geçmesi.
