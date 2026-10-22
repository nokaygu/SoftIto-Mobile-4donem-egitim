# VizyonMeet - Agora Entegrasyonu ve Durum Raporu

Bu rapor, Agora RTC v6 entegrasyonu, temp token güncellemesi ve giderilen eksikliklerin güncel durumunu içermektedir.

---

## 1. Agora Token ve Kanal Yapılandırması (GÜNCELLENDİ)

- **App ID:** `5cd255523c5543859f519ae66310d722` (Kullanıcının paylaştığı token içerisinden çözümlendi)
- **Geçici RTC Token:** `007eJxTYLj4MZ9pujWTwfkfcdNW7RMru/rOYHH07EPqWptu/Djfv99PgcE0OcXI1NTUyDjZ1NTE2MLUMs3U0DIx1czM2NAgxdzIKHj9zayGQEYGqw1rGJgYGMEQxGdjSEnNS81NZYCKgsRYGAwNDAwBHiojHQ==`
- **Varsayılan Test Kanalı:** `deneme` (Verilen token doğrudan `deneme` kanalı için üretildiğinden, uygulamanın varsayılan demo odası `deneme` olarak ayarlandı)

---

## 2. Çözülen ve Giderilen Sorunlar

Aşağıdaki maddelerin tamamı kod üzerinde çözülmüş ve test edilmiştir:

1. **[ÇÖZÜLDÜ] Canlı Katılımcı Profili ve Gerçek İsim:**
   - Agora RTC v6 DataStream kanalı kuruldu (`_broadcastLocalProfile`).
   - Kullanıcı odaya girdiğinde adı, kullanıcı adı ve avatarı DataStream üzerinden anında karşı cihaza iletilir.
   - Karşı cihazda Mac `ali` ile, Android `veli` ile girdiğinde her iki ekranda da karşı tarafın gerçek adı, canlı videosu ve avatarı doğru şekilde görüntülenir.
2. **[ÇÖZÜLDÜ] Canlı ve İki Yönlü Oda İçi Sohbet (Chat):**
   - Sohbet mesajları Agora `sendStreamMessage` ile doğrudan kanaldaki tüm katılımcılara P2P olarak canlı aktarılır.
   - Mac'ten yazılan mesaj Android'e, Android'den yazılan mesaj Mac'e anlık olarak düşer.
3. **[ÇÖZÜLDÜ] Simetrik 1-e-1 Arama Kanal Adı:**
   - `friends_view.dart` içinde kullanıcı isimleri alfabetik sıralanarak (`sortedUsers`) oda adı oluşturulur (`call_ali_veli`). Ali veya Veli kim ararsa arasın ikisi de aynı odaya yönlendirilir.
4. **[ÇÖZÜLDÜ] Gelişmiş Hata Yakalama ve Kullanıcı Bildirimi:**
   - Agora `onError` ve `joinChannel` hataları (Token süresi dolması, geçersiz kanal adı, izin hatası vb.) yakalanarak kullanıcıya kırmızı SnackBar ve durum mesajları ile iletilir. Bağlantı başarısız olduğunda siyah ekrana düşme engellendi.
5. **[ÇÖZÜLDÜ] Masaüstü Kamera Değiştirme Koruması:**
   - macOS ve masaüstünde `switchCamera` tıklandığında uygulamanın çökmesi veya sessiz kalması engellendi; kullanıcıya bilgilendirici arayüz uyarısı gösterilir.
6. **[ÇÖZÜLDÜ] Ağ Durumu ve Bağlantı Bildirimi:**
   - `onConnectionStateChanged` dinleyicisi eklendi; "Bağlanıyor...", "Yeniden bağlanıyor...", "Bağlantı koptu" durumları başlık barında canlı gösterilir.
7. **[ÇÖZÜLDÜ] Tek ve Birleşik Demo Odası:**
   - İlk demo odası `deneme` adıyla tekilleştirildi. Mac ve Android aynı `deneme` kanalına katılarak aynı oturumda buluşur.

---

## 3. Notlar ve Hatırlatmalar

- **Geçici Token Süresi:** Agora Console'dan alınan geçici token'lar genellikle 24 saat geçerlidir. 24 saat sonra görüşme başlatılamazsa Agora Console'dan `deneme` kanalı için yeni bir temp token alınıp `agora_config.dart` içine yapıştırılmalıdır.
- **Merkezi Sunucusuz Arama:** Projede harici bir WebSocket/Firebase sunucusu bulunmadığı için doğrudan "telefon çaldırma" özelliği yerine, her iki taraf da giriş ekranından veya lobiden `deneme` odasına girerek görüşmeyi başlatır.
