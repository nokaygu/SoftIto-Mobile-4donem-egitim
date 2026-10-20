# Kurucu - Girişimci Hukuk, Finans, Yatırım ve Hibe Ekosistemi

Apple iOS standartlarında, **Liquid Glass (Frosted Glassmorphism)** tasarım diliyle geliştirilmiş bağımsız, çok rollü girişimcilik ve yatırım platformu.

---

## 💎 Temel Özellikler ve Tasarım

1. **Frosted Liquid Glassmorphism:**
   - Harici paket kullanılmadan tamamen Flutter yerleşik `BackdropFilter(filter: ImageFilter.blur(...))` ve `ClipRRect` altyapısı.
   - Ekran içi dinamik ambient mesh sıvı ışık küreleri (`lib/core/widgets/ambient_background.dart`).
   - Işıltılı cam kenarlıklar, çift katmanlı yayvan gölgeler ve yarı saydam akışkan gradyanlar (`lib/core/widgets/liquid_glass_container.dart`).

2. **Rol Tabanlı Üç Farklı Giriş Portalı (`lib/features/auth/`):**
   - **🚀 Yatırım Alan (Girişimci Portalı):** Fikrini şirketleştir, ücretsiz hukuk & mali müşavir desteği al, KOSGEB/TÜBİTAK hibelerine ve yatırımcılara başvur (`lib/features/shell/views/shell_view.dart`).
   - **💼 Yatırımcı Portalı (Deal Flow):** Erken aşama start-up havuzunu incele, pitch deck'leri değerlendir, Term Sheet (Niyet Mektubu) ilet ve portföyünü yönet (`lib/features/investor_portal/views/investor_portal_view.dart`).
   - **🛡️ Admin Kontrol & Denetim Masası:** Girişimci başvurularını denetle, onay rozeti tanımla, akredite avukat/müşavir ata, yatırımcı akreditasyonunu doğrula ve sistem KPI'larını yönet (`lib/features/admin_portal/views/admin_portal_view.dart`).

3. **Girişimci & Başvuru Modülü (`lib/features/onboarding/`):**
   - Bütünleşik kaydırma (`SingleChildScrollView` + `BouncingScrollPhysics`), dinamik satır eklenip silinebilen yerleşik ekip tablosu ve rehberli fikir aşaması formu.
   - Dynamic Island onay kapsülü ve havada yüzen iOS cam barı.

4. **Yatırımcı & Deal Flow Deneyimi (`lib/features/investor_portal/`):**
   - Canlı girişim havuzunda sektör ve aşama filtreleme (`deal_flow_view.dart`).
   - Gelen pitch deck başvurularını tek tıkla inceleme ve toplantı planlama (`incoming_pitches_view.dart`).
   - Portföy takibi: 18.5M ₺ toplam yatırım, MOIC çarpanları ve aktif hisse oranları (`investor_portfolio_view.dart`).

5. **Admin Denetim Masası (`lib/features/admin_portal/`):**
   - **Girişim Onay Masası:** Bekleyen başvuruları inceleyip "Onaylı Girişimci" rozeti tanımlama veya incelemeye alma (`admin_startup_review_view.dart`).
   - **Uzman Atama Modalı:** Av. Selin Kaya, SMMM Emre Demir gibi ekosistem profesyonellerini resmi olarak girişime atama (`specialist_assign_modal.dart`).
   - **Yatırımcı Akreditasyonu:** Melek ve VC yatırımcıların yetki belgelerini doğrulayıp mavi rozet tanımlama (`admin_investor_verify_view.dart`).
   - **Metrikler & Denetim Günlüğü:** 85.4M ₺ fonlama hacmi, sektörel dağılım ve şeffaf audit logları (`admin_metrics_view.dart`, `admin_audit_view.dart`).

6. **Yüksek Kontrast ve Erişilebilirlik:**
   - Bildirimler (`SnackBar`) için zümrüt ışıklı yüzen cam kapsül, saf beyaz ve antrasit tipografi.
   - Her ekranda bulunan "Rol Değiştir" butonu ile portallar arasında anlık ve kesintisiz geçiş.

7. **Apple Okyanus Azure Renk Sistemi & Taşma Koruması:**
   - Mor tonlar tamamen kaldırılarak yerine Apple iOS sistem standardı **Okyanus Azure (`#0284C7`)** ve **Buzul Cam Mavisi (`#38BDF8`)** getirilmiştir.
   - Tüm üst barlar ve metin kapsülleri `Expanded` ve `TextOverflow.ellipsis` ile donatılarak sarı-siyah çizgi taşmaları (overflow) tamamen engellenmiştir.

---

## 🛠️ Mimari ve Doğrulama

- **Sıfır Harici Paket:** Yalnızca yerleşik Flutter SDK ve reaktif `ValueNotifier`.
- **Statik Kod Analizi:** `flutter analyze` ile 0 hata & 0 uyarı.
- **Birim ve Widget Testleri:** `flutter test` ile %100 başarılı.
