# Reaktif State Akışı ve Ekranlar Arası Senkronizasyon (`state_flow.md`)

Bu doküman, harici state paketi kullanmadan `AppState` üzerinden tüm ekranların nasıl senkronize çalışacağını açıklar.

---

## 1. Merkezi `AppState` Yapısı (`lib/core/state/app_state.dart`)

Uygulamadaki tüm controller'lar tekil (Singleton) olarak `AppState` üzerinden paylaşılır:

- `AppState.auth` (`AuthController` - Aktif kullanıcı `ali` veya `veli`, seçili avatar)
- `AppState.theme` (`ThemeController` - Aktif tema: 0, 1, 2 veya 3)
- `AppState.language` (`LanguageController` - Aktif dil: `TR` veya `EN`)
- `AppState.conference` (`ConferenceController` - Agora motoru, oda durumu, oda içi chat)
- `AppState.friends` (`FriendsController` - Arkadaş listesi ve özel mesajlar)
- `AppState.settings` (`SettingsController` - Mikrofon/kamera test ve ses seviyesi)

---

## 2. Konferans Odası, Landscape Uyarısı ve Chat'ten Arkadaş Ekleme Akışı

1. **Odaya Giriş ve BottomBar Gizleme:**
   - Kullanıcı **Konferans Oluştur/Katıl** ekranından (veya Giriş ekranındaki hızlı katıl alanından ya da Arkadaşlar listesinden) bir `channelName` ile katıldığında tam ekran `ConferenceRoomView` sayfasına geçilir. Bu ekranda `BottomNavigationBar` yer almaz.
2. **Landscape (Yatay Ekran) Kontrolü:**
   - `ConferenceRoomView` açıldığında ve ekran boyutu değiştiğinde `MediaQuery.orientationOf(context)` kontrol edilir.
   - Eğer `Orientation.portrait` ise kullanıcıya `SnackBar` ile _"Daha iyi bir konferans deneyimi için lütfen telefonunuzu yatay (landscape) konuma çevirin."_ (veya İngilizce seçiliyse İngilizce karşılığı) uyarısı gösterilir.
3. **Konferans İçi Chat -> Arkadaş Ekleme / Özel Mesaj Akışı:**
   - Konferans odasındaki sohbet panelinde (`room_chat_panel.dart`) bir mesajın üzerindeki **kullanıcı adına tıklandığında** bir `ModalBottomSheet` veya `Dialog` açılır.
   - İçinde **"Arkadaş Olarak Ekle"** ve **"Özel Mesaj Gönder"** butonları yer alır.
   - "Arkadaş Olarak Ekle" tıklandığında `AppState.friends.addFriend(...)` çağrılır ve kişi anında **Arkadaşlar** sekmesine eklenir.

---

## 3. Avatar, Tema ve Dil Değişimi Senkronizasyonu

1. **5 Avatar Akışı:**
   - Profil ekranında 5 avatardan biri seçildiğinde `AppState.auth.updateAvatar(index)` tetiklenir.
   - Bu değişiklik hem Profil ekranında hem de `ConferenceRoomView` içindeki yerel kullanıcı kutusunda (kamera kapalıyken merkezde, açıkken isim rozeti yanında) anında görünür.
2. **4 Tema Akışı:**
   - Profil ekranındaki 4 tema ikonundan birine tıklandığında `AppState.theme.setTheme(index)` çalışır ve `main.dart` içindeki `ValueListenableBuilder` tüm uygulamanın `ThemeData` ve özel renklerini anında günceller.
3. **TR / EN Dil Akışı:**
   - Ayarlar ekranında Türkçe veya İngilizce seçildiğinde `AppState.language.setLanguage(...)` tetiklenir ve tüm ekran başlıkları, butonlar ve uyarılar anında seçilen dile çevrilir.
