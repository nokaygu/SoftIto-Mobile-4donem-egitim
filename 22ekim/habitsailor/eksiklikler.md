# Habit Sailor - Görev Kartı Etkileşimi ve Planlanan Görevler İnceleme Raporu

> **Tarih:** 23 Ekim 2026  
> **Konu:** 
> 1. Kartın tamamına tıklayarak görevi tamamlama (Fitts Kanunu ve Dokunma Alanı - Touch Target Optimizasyonu)  
> 2. Planlananlar ve gelecek tarihli görevler için erkenden onaylama (pre-completion) yapılmasının engellenmesi

---

## 1. Tespit 1: "Küçük Yuvarlağa Tıklama Zorluğu" ve Dokunma Alanı (Touch Target)

### Mevcut Durum Analizi:
`lib/features/widgets/habit_task_card.dart` incelendiğinde:
```dart
child: InkWell(
  borderRadius: BorderRadius.circular(20),
  onTap: onTap, // <-- Dışarıdan onTap verilmezse kartın tamamı tıklanamaz oluyor!
  child: ...
    Row(
      children: [
        if (onToggleComplete != null)
          IconButton(
            onPressed: onToggleComplete,
            icon: Icon(isCompletedToday ? ... : Icons.radio_button_unchecked_rounded),
          ),
        ...
```
- `TodayView` ve `DayDetailView` ekranlarında `HabitTaskCard`'a yalnızca `onToggleComplete` parametresi verilmekte, `onTap` parametresi **verilmemektedir** (`null` kalmaktadır).
- Bu sebeple kartın %90'ını kaplayan başlık, saat, gün sayısı ve geniş arka plan alanı **dokunmaya tamamen duyarsızdır**.
- Kullanıcı görevi tamamlamak veya geri almak için sol baştaki 28x28 piksellik küçücük radyo ikonuna parmağını milimetrik olarak denk getirmek zorunda kalmaktadır.
- Bu durum **Fitts Kanunu**'na (hedef küçüldükçe tıklama süresi ve hata oranı artar) ve mobil UX standartlarına (Material Design min 48x48dp dokunma alanı kuralı) aykırıdır; tek elle kullanımda ergonomik zorluk yaratmaktadır.

### Önerilen Çözüm:
`HabitTaskCard` bileşeni şu akıllı dokunma mantığına kavuşturulmalıdır:
```dart
onTap: onTap ?? onToggleComplete,
```
- **Sonuç:**
  - `TodayView` ve `DayDetailView` gibi tamamlama ekranlarında kullanıcı kartın **neresine dokunursa dokunsun** görev anında "tamamlandı / geri alındı" olur. Sol baştaki yuvarlak ise animasyonlu görsel gösterge (tick) işlevini sürdürür.
  - `ManageTasksView` gibi görevin düzenlendiği ekranlarda ise dışarıdan özel `onTap: () => _openEditTask(...)` verildiği için kart tıklandığında düzenleme modalı açılmaya devam eder (çakışma olmaz).

---

## 2. Tespit 2: "Planlananlar İçin Şimdiden Onaylama Olmaması" (Erken Tamamlama Sorunu)

### Mevcut Durum Analizi:
Alışkanlık takibi ve "Zinciri Kırma ⚡" (Don't Break The Chain) felsefesinde:
- Bir alışkanlık **geleceğe yönelik peşinen yapılamaz**. Yarının sporunu, pazar gününün kitap okumasını ya da haftaya planlanan yelken bakımını bugünden *"yaptım"* diye işaretlemek alışkanlık psikolojisine ve zincir matematiğine tamamen aykırıdır.
- Mevcut kodda:
  1. `lib/features/views/today/today_view.dart` içindeki Planlananlar sekmesinde:
     `(isTodayTab || isDueToday)` şartı yer almaktadır. Haftalık tekrarlayan bir görev tesadüfen bugün de yapılması gereken bir günse, "Planlananlar" sekmesinde listelendiğinde de tamamlama butonu aktif görünmekte ve bugünün tarihiyle erken tamamlanabilmektedir.
  2. `lib/features/views/agenda/day_detail_view.dart` ekranında:
     Kullanıcı takvimden yarını, haftaya cumayı ya da 1 ay sonrasını seçip gün detayına girdiğinde, `onToggleComplete` koşulsuz olarak aktiftir. Kullanıcı 2026-11-15 tarihindeki bir göreve bugün tıklayarak o tarihi tamamlanmış yapabilmektedir.

### Önerilen Çözümler:

#### A. "Planlananlar" Sekmesi Kuralı (`TodayView`):
- `_selectedTabIndex == 1` ("Planlananlar") iken `onToggleComplete` parametresi **kesinlikle `null`** geçilmelidir.
- Kartın sol başında boş veya tıklanamayan bir radyo butonu yerine:
  - Şık bir **"Planlandı 🗓️"** veya **"Gününde Açılır 🔒"** rozeti gösterilmelidir.
- Kullanıcı karta tıkladığında hiçbir şey olmaması yerine bilgilendirici ve eğitici bir geri bildirim (SnackBar / Toast) verilmelidir:
  - *"Bu görev geleceğe aittir. Günü geldiğinde Bugünün Rotası üzerinden tamamlayabilirsiniz ⚓"*

#### B. Ajanda Gün Detayı Kuralı (`DayDetailView`):
- Seçilen tarih bugünden sonraysa (`selectedDate.isAfter(DateTime.now())`):
  - Kartlarda tamamlama aksiyonu devre dışı bırakılmalıdır.
  - Sayfanın üstüne yumuşak bir bilgi şeridi eklenmelidir:
    - *"Gelecek günlerin görevleri günü geldiğinde tamamlanabilir."*
- Seçilen tarih bugün veya geçmişse:
  - Kullanıcı dün unuttuğu görevi telafi edebilsin veya bugünkü görevini yapabilsin diye tamamlama aktif kalmalıdır.

---

## 3. Karşılaştırma ve Etki Tablosu

| Özellik | Mevcut Davranış | Önerilen Yeni Davranış | UX / Mantık Kazanımı |
|---|---|---|---|
| **Karta Dokunma** | Sadece 28px'lik küçük yuvarlak ikona basınca tick oluyor. Karta basınca tepki yok. | **Kartın gövdesine herhangi bir yere dokununca da tick oluyor.** | Hızlı, tek elle rahat kullanım, sıfır tıklama zorluğu. |
| **Planlanan Görevler** | "Planlananlar" sekmesinde bazı görevler erken tamamlanabiliyor. | **Planlanan görevler erkenden onaylanamaz.** Kilit/Planlandı rozeti ve rehber mesaj çıkar. | "Zinciri Kırma" felsefesi korunur; sahte erken tamamlama engellenir. |
| **Gelecek Ajanda Günleri** | Gelecekteki bir günün detayında görevler şimdiden tamamlanabiliyor. | **Gelecek günlerin görevleri günü gelmeden tamamlanamaz.** | Tarih tutarsızlığı ve streak bozulması önlenir. |

---

## 4. Uygulama Adımları (Eylem Planı)

1. `lib/features/widgets/habit_task_card.dart`:
   - `onTap: onTap ?? onToggleComplete` ile kartın tamamını dokunabilir yap.
   - `isLocked` veya `isScheduledOnly` durumunda kilit/takvim ikonu ve uygun stil göster.
2. `lib/features/views/today/today_view.dart`:
   - "Bugün" sekmesinde kart tıklamasıyla anında tamamlama.
   - "Planlananlar" sekmesinde tamamlama butonunu kapat; karta basılınca *"Günü geldiğinde tamamlanabilir"* uyarısı ver.
3. `lib/features/views/agenda/day_detail_view.dart`:
   - `isFutureDate` kontrolü ekle; gelecek tarihlerde erken tamamlamayı engelle.

---

## 5. Uygulama Durumu: ✅ BAŞARIYLA TAMAMLANDI

Kullanıcının onayıyla ("a olsun eksiklikler yapılsın") her iki geliştirme de projeye tam olarak uygulandı:

1. **Geniş Dokunma Alanı (Karta Tıklayarak Tick Yapma):**
   - [habit_task_card.dart](file:///Users/d1-10/projects/SoftIto-Mobile-4donem-egitim/22ekim/habitsailor/lib/features/widgets/habit_task_card.dart) güncellendi.
   - `InkWell` dokunma dinleyicisi `onTap: onTap ?? onToggleComplete` olarak bağlandı.
   - Kullanıcı artık kartın herhangi bir yerine dokunarak görevi anında tamamlayabilir veya geri alabilir; küçük 28px yuvarlağa denk getirme zorunluluğu ortadan kalktı.
2. **Planlananlar Sekmesinde Erken Onaylama Engeli:**
   - [today_view.dart](file:///Users/d1-10/projects/SoftIto-Mobile-4donem-egitim/22ekim/habitsailor/lib/features/views/today/today_view.dart) güncellendi.
   - "Planlananlar" sekmesindeki görevlerde `onToggleComplete` kaldırıldı, `isLocked: true` yapıldı.
   - Karta şık bir `Planlandı` rozeti ve kilit saati ikonu eklendi.
   - Karta dokunulduğunda *"Bu görev geleceğe aittir. Günü geldiğinde Bugünün Rotası üzerinden tamamlayabilirsiniz ⚓"* bilgilendirme uyarısı verildi.
3. **Ajanda Gün Detayında Gelecek Tarih Koruması:**
   - [day_detail_view.dart](file:///Users/d1-10/projects/SoftIto-Mobile-4donem-egitim/22ekim/habitsailor/lib/features/views/agenda/day_detail_view.dart) güncellendi.
   - Geleceğe ait günlerdeki görevler de erken tamamlamaya karşı kilitlendi ve rehber mesaj bağlandı.
4. **Test ve Lint:**
   - `flutter analyze` ile 0 hata & 0 uyarı; 18/18 birim ve widget testi yeşil olarak onaylandı.
