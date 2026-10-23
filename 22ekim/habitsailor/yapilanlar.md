# Habit Sailor - Yapılanlar Listesi (İlerleme Takibi)

## Faz 1: Temel Mimari ve Ekranların Kurulumu
- [x] 1. `yapilanlar.md` dosyasının oluşturulması ve proje planlaması
- [x] 2. Flutter projesinin kök dizinde başlatılması (`flutter create`)
- [x] 3. `pubspec.yaml` içine temel paketlerin eklenmesi (`flutter_secure_storage`, `hive`, `hive_flutter`, `crypto`)
- [x] 4. En katı `analysis_options.yaml` lint kurallarının ayarlanması
- [x] 5. Tek Renk Kaynağı: `lib/core/theme/app_theme.dart` (ColorScheme + `HabitSailorThemeExtension`) kodlanması
- [x] 6. Sabitler ve Modeller: `avatar_constants.dart`, `user_model.dart`, `habit_task_model.dart`
- [x] 7. Depolama Katmanı: `secure_auth_storage.dart` (`flutter_secure_storage`) ve `hive_task_storage.dart` (`hive_flutter`)
- [x] 8. State ve Controller'lar: `auth_controller.dart`, `task_controller.dart`, `app_state.dart`
- [x] 9. DRY Ortak Bileşenler (Tek İş = Tek Widget):
  - [x] `HabitSailorBrandHeader` (Yelkenli logo + Sarı şimşek "ZİNCİRİ KIRMA" sloganı)
  - [x] `UserAvatarBadge` (Tekil Avatar Rozeti)
  - [x] `WeekdaySelectorBar` (Samsung Alarm tarzı P S Ç P C C P gün seçici)
  - [x] `HabitTaskCard` (Tek Evrensel Görev Kartı - 3 zorluk seviyesi, derinlikli gölge, streak neon rozeti)
  - [x] `TaskFormBottomSheet` (Tek Evrensel Görev Ekleme/Düzenleme Formu)
- [x] 10. Ekranların Geliştirilmesi:
  - [x] `LoginView` (İsim & Şifre girişi, Üye Ol BottomSheet'i)
  - [x] `MainShellView` (4 Sekmeli BottomNavigationBar: Bugün, Ajanda, Görevle, Profil)
  - [x] `TodayView` (Günün görevleri listesi + Planlananlar / Yaklaşanlar geçişi)
  - [x] `AgendaView` & `DayDetailView` (Hive bağlantılı özel takvim, gün detayı ve görev ekleme)
  - [x] `TasksHubView` & `ManageTasksView` (Avatar ikonu, dialog seçimi, görevleri düzenleme ve silme)
  - [x] `ProfileView` & `LeaderboardDashboardView` (5 Avatar seçimi, Denizci Rütbesi, Liderlik Tablosu, Çıkış Yap)
- [x] 11. `main.dart` entegrasyonu ve uygulama yaşam döngüsü
- [x] 12. Renk ve Lint Doğrulaması: `app_theme.dart` dışındaki dosyalarda `Color`/`Colors` kontrolü ve `flutter analyze` ile 0 hata & 0 uyarı onayı

---

## Faz 2: Yeniden Adlandırma (Re-branding: habitsailer ➔ habitsailor)
- [x] 13. Tüm proje çapında `habitsailer` ifadesi `habitsailor` olarak güncellendi:
  - [x] `pubspec.yaml` paket adı ve `pubspec.lock`
  - [x] Android: `applicationId`, `namespace`, `MainActivity.kt` paket dizini (`com/habitsailor/habitsailor/MainActivity.kt`), `AndroidManifest.xml`
  - [x] iOS: `Bundle Identifier` (`com.habitsailor.habitsailor`), `CFBundleDisplayName`, `project.pbxproj`
  - [x] macOS: `CFBundleIdentifier`, `Product Name`, Runner xcodeproj
  - [x] Web & Desktop: `index.html`, Linux & Windows CMake yapıları

---

## Faz 3: Güvenlik, Kayıt Mimarisi ve Eksikliklerin Çözümü (`eksiklikler.md`)
- [x] 14. **Kayıt ve Şifre Güvenliği Katmanı (Kolaya Kaçılmayan Güvenli Altyapı):**
  - [x] `crypto` paketi projeye entegre edildi.
  - [x] `lib/core/security/password_security.dart` modülü geliştirildi:
    - [x] `Random.secure()` ile 16-byte kriptografik rastgele tuz (salt) üretimi.
    - [x] HMAC-SHA256 ile tuzlanmış parola hash'leme (`salt:hmac_hash`).
    - [x] Güvenli şifre doğrulama ve geriye dönük eski düz metin şifreleri otomatik yükseltme (migration fallback).
    - [x] Kullanıcı adı ve şifre girdi kuralları: min 3 karakter kullanıcı adı, min 4 karakter şifre, alfanümerik kontrolü.
  - [x] **Var Olan Kullanıcı Adıyla Kayıt Engeli:**
    - [x] `SecureAuthStorage.registerUser` içinde kullanıcı adları `cleanName.toLowerCase()` ile taranır.
    - [x] Aynı kullanıcı adı (büyük/küçük harf fark etmeksizin) tekrar kayıt olmaya çalıştığında `RegisterResult.userAlreadyExists` fırlatılır.
    - [x] Kayıt ekranında "Bu kullanıcı adı zaten alınmış. Lütfen farklı bir isim seçiniz." uyarısı gösterilir.
  - [x] Kayıt formuna "Şifre Tekrar" alanı ve canlı uyuşmazlık kontrolü eklendi.
- [x] 15. **Şifre Güncelleme Hatasının Giderilmesi:**
  - [x] `SecureAuthStorage.updatePassword` fonksiyonu yazıldı (önceden `registerUser` çağrılarak işlem reddediliyordu).
  - [x] `AuthController.updatePassword` yazılarak katmanlı mimariye uygun şekilde `ProfileView`'a bağlandı.
  - [x] Şifre değiştirme modalına şifre tekrarı ve validasyon eklendi.
- [x] 16. **Çoklu Kullanıcı Veri İzolasyonu:**
  - [x] `HabitTaskModel` sınıfına zorunlu `userId` alanı eklendi.
  - [x] `HiveTaskStorage.getTasksForUser` metodu ile her kullanıcı yalnızca kendi görevlerini görür hale getirildi.
  - [x] Kullanıcı değiştiğinde görevler ve streak puanı `AppState` tarafından otomatik senkronize edildi.
- [x] 17. **NoSQL $O(1)$ Performans Optimizasyonu:**
  - [x] Hive'daki $O(N)$ linear döngü taramaları kaldırıldı; `box.put(task.id, ...)` ve `box.delete(task.id)` ile doğrudan $O(1)$ erişim sağlandı.
- [x] 18. **Navigasyon ve Durum Senkronizasyonu (Dual Navigation Fix):**
  - [x] `LoginView` ve `ProfileView` içerisindeki gereksiz `pushReplacement` ve `pushAndRemoveUntil` çağrıları kaldırıldı.
  - [x] Uygulama tamamen `main.dart` içindeki `ListenableBuilder(listenable: authController)` ile saf reaktif yönetime kavuşturuldu.
- [x] 19. **Dinamik "Zinciri Kırma ⚡" (Streak) Algoritması:**
  - [x] Statik `+1`/`-1` sayacı yerine `repeatWeekdays` ve `completedDatesIso` geçmişine bakan matematiksel ardışık gün algoritması yazıldı.
  - [x] "Planlananlar" sekmesinde gelecek görevlerin erken tamamlanması engellendi.
- [x] 20. **Liderlik Tablosu & Kalıcı Bildirimler:**
  - [x] Sistemdeki tüm kayıtlı kullanıcılar ve denizci mentorlar dinamik olarak birleştirilip toplam zincir puanlarına göre sıralandı.
  - [x] Bildirim ayarı `UserModel` ve `SecureAuthStorage` ile cihazda kalıcı hale getirildi.
- [x] 21. **Kapsamlı Test Paketi ve Doğrulama:**
  - [x] `test/unit/password_security_test.dart`
  - [x] `test/unit/auth_storage_test.dart`
  - [x] `test/unit/habit_task_model_test.dart`
  - [x] `test/unit/streak_calculation_test.dart`
  - [x] `test/widget_test.dart`
  - [x] Toplam test paketi başarıyla geçirildi.
  - [x] `flutter analyze` ile **0 hata & 0 uyarı** doğrulandı.

---

## Faz 4: Bağımlılık Sadeleştirmesi ve Tek Tabanca Hive Mimarisi (Senaryo A)
- [x] 22. **Fazla Bağımlılıkların ve Kütüphane Şişkinliğinin Temizlenmesi:**
  - [x] `flutter_secure_storage` paketi `pubspec.yaml`'dan tamamen kaldırıldı.
  - [x] `crypto` paketi `pubspec.yaml`'dan tamamen kaldırıldı.
  - [x] Yalnızca saf Dart ve ultra hafif `hive` + `hive_flutter` motoru bırakıldı.
- [x] 23. **Birleşik `HiveAuthStorage` Motoru Geliştirildi:**
  - [x] `habitsailor_users_box` Hive kutusu altında $O(1)$ anahtar-değer kimlik doğrulama mimarisi kuruldu.
  - [x] Büyük/küçük harf duyarsız mükerrer kayıt engeli (`box.containsKey('user_${cleanName.toLowerCase()}')`) korundu.
  - [x] Eski veriler için otomatik Hive migration desteği sağlandı.
- [x] 24. **Saf Dart Doğrulama Katmanı (`AuthValidator`):**
  - [x] `lib/core/security/auth_validator.dart` ile harici kütüphanesiz kullanıcı adı ve şifre kuralları yazıldı.
- [x] 25. **Controller ve Test Doğrulamaları:**
  - [x] `AuthController` ve `AppState` yeni birleşik `HiveAuthStorage` sınıfına bağlandı.
  - [x] `auth_storage_test.dart` ve `password_security_test.dart` saf Hive test yapısına uyarlandı.
  - [x] `flutter analyze` 0 hata & 0 uyarı ve tüm birim testleri %100 başarıyla geçti.

---

## Faz 5: UX Dokunma Alanı (Fitts Kanunu) ve Planlanan Görevler Koruması
- [x] 26. **Karta Tıklayarak Tamamlama (Geniş Dokunma Alanı):**
  - [x] `HabitTaskCard` bileşeni güncellendi; `onTap: onTap ?? onToggleComplete` ile kartın tüm gövdesi tıklanabilir hale getirildi.
  - [x] Kullanıcı artık sol baştaki 28px küçük yuvarlağa denk getirmek zorunda kalmadan kartın neresine dokunursa dokunsun görevi tick edebilmektedir.
- [x] 27. **Planlananlar ve Gelecek Görevlerin Erken Onaylanmasının Kilitlenmesi:**
  - [x] `TodayView` "Planlananlar" sekmesinde tamamlama aksiyonu kapatıldı; `isLocked: true` ve `Planlandı 🗓️` kilit rozeti eklendi.
  - [x] Karta tıklandığında *"Bu görev geleceğe aittir. Günü geldiğinde Bugünün Rotası üzerinden tamamlayabilirsiniz ⚓"* rehber uyarısı bağlandı.
  - [x] `DayDetailView` (Ajanda Gün Detayı) ekranında gelecek günlerin görevleri de erken tamamlamaya karşı kilitlendi ve bilgilendirici uyarı şeridi eklendi.

---

## Faz 6: 3 Sekmeli Rota Sistemi, Toplu Onay ve Saf Flutter Kutlama Animasyonları
- [x] 28. **3 Sekmeli Rota Navigasyonu (`TodayView`):**
  - [x] **Bugün Bitirilenler (Sol Sekme):** Tamamlanan görevleri yeşil onay rozeti, `+X Puan ⚡` rozeti ve "Rotaya Geri Al ↩" aksiyonu ile listeler.
  - [x] **Bugünün Rotası (Orta Sekme - Varsayılan):** Yalnızca bugün yapılması gereken aktif bekleyen görevleri gösterir; çoklu görev seçimi yapılabilir.
  - [x] **Planlananlar (Sağ Sekme):** Gelecek günlere ait kilitli görevleri gösterir (erken onaylama kapalı).
- [x] 29. **Toplu Tamamlama ve Kaptan Onay Akışı:**
  - [x] Ekranın altında gölgeli floating **"⚓ Rotayı Tamamla"** butonu (seçili görev sayısını veya tümünü bitirmeyi gösterir).
  - [x] Butona tıklandığında *"Rotayı Bitirdiniz mi? ⚓"* onay modalı açılır; onay verildiğinde görevler yapılacaklar listesinden silinip anında "Bugün Bitirilenler"e aktarılır.
- [x] 30. **Saf Flutter Günlük "Hurray!" Gemi Yüzme Kutlaması (`VoyageCelebrationDialog`):**
  - [x] Sıfır harici paket; `AnimationController` ve `CustomPainter` ile 60 FPS saf Dart performansı.
  - [x] Matematiksel `sin()` dalga simülasyonu, su üstünde batıp çıkan ve süzülen yelkenli gemi, etrafta patlayan parıltılı yıldızlar ve kazanılan zincir puanı banner'ı.
- [x] 31. **Haftalık "Limana Varış" Büyük Kutlaması (`HarborArrivalDialog`):**
  - [x] Haftanın tüm tekrarlayan görevleri tamamlandığında otomatik tetiklenir (`isWeeklyRouteCompleted`).
  - [x] Dönen deniz feneri ışığı, sakin koya yanaşan yelkenli, suya inen animasyonlu ağır çapa (`⚓`) ve +50 Haftalık Liman Bonusu.
- [x] 32. **Test ve Kod Kalitesi Güvencesi:**
  - [x] `test/unit/route_completion_test.dart` ile filtreleme, batch completion, geri alma (uncomplete) ve haftalık rota kontrolü test edildi.
  - [x] Toplam 22 test sıfır hatayla geçti (`22/22 tests passed`).
  - [x] `flutter analyze` ile 0 hata, 0 uyarı doğrulandı.

---

## Faz 7: Kaptanın Seyir Defteri & Görev Deneyim Notları (Logbook)
- [x] 33. **Veri Modelleri ve Kalıcılık Genişletmesi:**
  - [x] `HabitTaskModel` sınıfına `completionNotes: Map<String, String>` (tarih -> seyir notu) alanı eklendi.
  - [x] Yeni `CaptainLogModel` (`id`, `userId`, `dateIso`, `timeString`, `title`, `content`, `weather`, `createdAtIso`) oluşturuldu.
  - [x] Yeni `HiveLogStorage` (`habitsailor_logs_box`) ve `LogbookController` geliştirildi.
  - [x] `AppState` yaşam döngüsüne `logStorage` ve `logbookController` entegre edildi.
- [x] 34. **Görev Tamamlama Anında Deneyim Notu Yazma:**
  - [x] "Rotayı Tamamla" onay modalına *"📝 Seyir Notu / Deneyim (İsteğe Bağlı)"* alanı eklendi.
  - [x] Kullanıcı not girdiğinde görevle ilişkilendirilip aynı zamanda Kaptanın Seyir Defteri'ne otomatik işlenir.
  - [x] "Bugün Bitirilenler" sekmesinde ve Seyir Defteri'nde her göreve özel not kartı ve "Seyir Notu Ekle / Düzenle" desteği sağlandı.
- [x] 35. **Bottom Navigation Bar'a "Seyir Defteri" Sekmesi Eklendi:**
  - [x] `MainShellView`'a 5. sekme olarak `LogbookView` (`Icons.auto_stories_rounded`) yerleştirildi.
  - [x] Tarih bazlı kaydırılabilir filtre (carousel), hava durumu seçimi (☀️, ⛵, 🌊, ⚡, ⚓), serbest kaptan günlüğü yazma/düzenleme/silme özellikleri kuruldu.
- [x] 36. **Material 3 ListTile Uyarısının Düzeltilmesi:**
  - [x] `tasks_hub_view.dart` içerisindeki dialog ListTile bileşenleri `Material(color: Colors.transparent)` ile sarmalanarak terminaldeki arka plan uyarısı temizlendi.
- [x] 37. **Test Paketi ve Analiz Doğrulaması:**
  - [x] `test/unit/logbook_test.dart` yazılarak model serialization, welcome log seeding, not ekleme ve silme birim testleri yapıldı.
  - [x] 25/25 birim ve widget testi %100 başarıyla geçti.
  - [x] `flutter analyze` 0 hata & 0 uyarı doğrulandı.

---

## Faz 8: Seyir Ajandası UI Revizyonu & Akıllı Görev Snippet'ları
- [x] 38. **Akıllı Görev Özeti Algoritması (`TaskController`):**
  - [x] `getMeaningfulTaskSnippetForDate(date)` metodu yazıldı.
  - [x] Türkçe genel/dolgu kelimeleri ('sabah', 'akşam', 'günlük', 'her', 've', 'bir' vb.) filtreleyen stop-word motoru kuruldu.
  - [x] Takvim hücrelerinde artık tekdüze "Sabah" yerine gerçek görev içeriği ("Rotayı Belirle", "Fırtına Tedbiri", "Dümen Kontrolü", "Kitap") gösterilir.
- [x] 39. **Seyir Ajandası UI & Master-Detail Yenilenmesi (`AgendaView`):**
  - [x] `childAspectRatio: 0.90` ile ferah, nefes alan takvim hücreleri kuruldu.
  - [x] Seçili gün durum yönetimi eklendi (`_selectedDate`); seçilen güne tıklandığında sayfa değiştirmeden hemen altta **"Seçili Günün Rotası"** listesi dinamik açılır.
  - [x] Listedeki görevler tam adları, saatleri, zorluk seviyeleri, seri durumları ve tamamlanma rozetleriyle anında okunur.
  - [x] Tek tıkla güne görev ekleme (`TaskFormBottomSheet`) ve "Detay Sayfası"na geçiş sağlandı.
  - [x] Hızlı "Bugün" butonu eklendi.
- [x] 40. **Material 3 DecoratedBox / ListTile Düzeltmesi:**
  - [x] `profile_view.dart` içerisindeki `Container(BoxDecoration)` yerine `Material(clipBehavior: Clip.antiAlias, shape: ...)` kullanılarak terminaldeki runtime assertion tamamen ortadan kaldırıldı.
- [x] 41. **Mimari Doküman Senkronizasyonu:**
  - [x] `project.md`, `yapilacaklar.md` ve `yapilanlar.md` 5 sekmeli mimari ve tüm yeni özelliklerle eşitlendi.
- [x] 42. **Sıfır Hata Doğrulaması:**
  - [x] `flutter analyze` ile 0 hata, 0 uyarı.
  - [x] `flutter test` ile 25/25 test eksiksiz geçti.





