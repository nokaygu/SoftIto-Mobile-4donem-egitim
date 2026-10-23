# `flutter_secure_storage` & `Hive` Veri Akışı Rehberi (`state_flow.md`)

Bu doküman, harici backend olmadan `flutter_secure_storage` ve `hive_flutter` ile kimlik, görev, ajanda ve streak liderlik tablosunun nasıl çalışacağını tanımlar.

---

## 1. Kimlik Doğrulama Akışı (`flutter_secure_storage`)

- `SecureAuthStorage` (`lib/core/storage/secure_auth_storage.dart`) sınıfı üzerinden:
  - Kullanıcı "Üye Ol" BottomSheet'inde **İsim** ve **Şifre** girdiğinde `users_json` anahtarı altında güvenli şekilde saklanır ve `active_user` anahtarına mevcut kullanıcı yazılır.
  - Kullanıcının seçtiği **Avatar İndeksi (0..4)** de güvenli depoda kullanıcı kaydıyla eşleştirilir.
  - "Çıkış Yap" butonuna basıldığında `active_user` silinir ve ekran `LoginView`'a döner.

---

## 2. Görev, Tekrarlama ve Streak Akışı (`Hive`)

- `HiveTaskStorage` (`lib/core/storage/hive_task_storage.dart`) içinde `tasks_box` adında bir Hive kutusu açılır.
- Her `HabitTaskModel` nesnesi `toMap()` ve `fromMap()` metodlarıyla (ekstra TypeAdapter kod üretimi karmaşasına gerek kalmadan saf Map olarak) Hive içine kaydedilir:
  - `id` (`String`)
  - `title` (`String`)
  - `timeString` (`String?` - Örn: `"08:30"`)
  - `difficulty` (`int` - `0`: Bebek Mavisi, `1`: Normal Mavi, `2`: Lacivert)
  - `isRecurring` (`bool`)
  - `repeatWeekdays` (`List<int>` - `1` Pazartesi ... `7` Pazar)
  - `specificDateIso` (`String?` - Tekrarlamayan görevler için seçilen tarih)
  - `completedDatesIso` (`List<String>` - `"YYYY-MM-DD"` formatında tamamlanan günler)
  - `streakCount` (`int` - Tamamlandıkça artan zincir puanı)

---

## 3. Ajanda, Bugün ve Görevle Ekranları Senkronizasyonu

1. **Bir Gün İçin Görevlerin Bulunması (`getTasksForDate(DateTime date)`):**
   - Tekrarlamayan görevlerde `specificDateIso == dateKey(date)` olanlar,
   - Tekrarlayan görevlerde ise `repeatWeekdays.contains(date.weekday)` olanlar döndürülür.
2. **Ajanda Takvim Hücresi Renk ve İlk Kelime Mantığı:**
   - O güne ait görevler içinde en az bir tane `difficulty == 2` (Lacivert/Acil) varsa gün kutusu temanın **Koyu Mavi** tonunu alır; yoksa ve görev varsa **Bebek Mavisi** tonunu alır.
   - O gündeki ilk görevin başlığının ilk kelimesi (`task.title.split(' ').first`) gün kutusunun içinde gösterilir.
3. **Görev Silme Onayı:**
   - Görevlerimi Düzenle ekranında çarpı (`✕`) ikonuna basıldığında onay diyaloğu açılır.
   - Eğer `task.isRecurring == true` ise: _"Emin misiniz? Bu görev haftada ${task.repeatWeekdays.length} gün tekrarlanıyor. Silerseniz artık tekrarlanmayacak ve ${task.streakCount} zincir puanınız kaybolacaktır."_ mesajı gösterilir.
4. **Streak Leaderboard (Profil -> Dashboard):**
   - Kullanıcının tüm tekrarlayan görevlerinden topladığı `streakCount` toplamı hesaplanır ve örnek açık deniz kaptanlarıyla birlikte sıralı Liderlik Tablosunda (`LeaderboardDashboardView`) gösterilir.
