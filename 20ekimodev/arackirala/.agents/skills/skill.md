---
name: flutter-solid-liquid-scaffold
description: Vites projesi için SOLID ve OOP prensiplerine uygun, Bordo-Siyah-Gri Liquid Glass temalı, uzun kodları küçük fonksiyonlara ve widget'lara bölen modüler kod iskeleti üretir.
---

# Flutter SOLID & Liquid Glass Scaffold

Bu yetenek, projede yeni bir ekran, model veya controller oluştururken `project.md` içindeki klasör yapısına, SOLID prensiplerine ve Bordo/Siyah/Gri Liquid Glass tasarım kurallarına tam uyulmasını garanti eder.

## Temel Kurallar

1. **Klasör Yapısına Sadakat:**
   - Modeller `lib/features/models/` altına,
   - Controller'lar `lib/features/controllers/` altına,
   - Ekranlar `lib/features/views/` (ve ilgili alt klasörleri `araclar/`, `kiracilar/`, `mesajlar/`) altına,
   - Yeniden kullanılabilir cam bileşenler `lib/features/widgets/` altına yazılmalıdır.
2. **Uzun Fonksiyon Yasağı (Clean OOP):**
   - Bir fonksiyon veya `build` metodu 35 satırı geçiyorsa derhal özel küçük metodlara (`Widget _buildCarHeader(BuildContext context)`) veya ayrı bir `StatelessWidget` sınıfına parçalanmalıdır.
3. **Mor Renk Yasağı & Yüksek Kontrast:**
   - Asla varsayılan mor renk kullanılmaz. Tüm vurgu butonları `AppColors.burgundy` (`#8B1E2F`), yüzeyler koyu gri/siyah cam ve metinler yüksek görünürlüklü net beyaz/gümüş olmalıdır.

## Uygulama Şablonları

### 1. OOP & Immutable Model Şablonu (`lib/features/models/arac_model.dart`)

```dart
class AracModel {
  final String id;
  final String marka;
  final String model;
  final int yil;
  final double gunlukFiyat;
  final String vitesTipi;
  final String yakitTipi;
  final bool kiralandiMi;
  final String kirayaVerenId;
  final String? kiralayanId;
  final int begeniSayisi;
  final bool begenildiMi;
  final List<String> yorumlar;

  const AracModel({
    required this.id,
    required this.marka,
    required this.model,
    required this.yil,
    required this.gunlukFiyat,
    required this.vitesTipi,
    required this.yakitTipi,
    required this.kirayaVerenId,
    this.kiralandiMi = false,
    this.kiralayanId,
    this.begeniSayisi = 0,
    this.begenildiMi = false,
    this.yorumlar = const [],
  });

  AracModel copyWith({
    String? id,
    String? marka,
    String? model,
    int? yil,
    double? gunlukFiyat,
    String? vitesTipi,
    String? yakitTipi,
    bool? kiralandiMi,
    String? kirayaVerenId,
    String? kiralayanId,
    int? begeniSayisi,
    bool? begenildiMi,
    List<String>? yorumlar,
  }) {
    return AracModel(
      id: id ?? this.id,
      marka: marka ?? this.marka,
      model: model ?? this.model,
      yil: yil ?? this.yil,
      gunlukFiyat: gunlukFiyat ?? this.gunlukFiyat,
      vitesTipi: vitesTipi ?? this.vitesTipi,
      yakitTipi: yakitTipi ?? this.yakitTipi,
      kirayaVerenId: kirayaVerenId ?? this.kirayaVerenId,
      kiralandiMi: kiralandiMi ?? this.kiralandiMi,
      kiralayanId: kiralayanId ?? this.kiralayanId,
      begeniSayisi: begeniSayisi ?? this.begeniSayisi,
      begenildiMi: begenildiMi ?? this.begenildiMi,
      yorumlar: yorumlar ?? this.yorumlar,
    );
  }
}
```

### 2. Liquid Glass Bileşen Şablonu (`lib/features/widgets/liquid_glass_card.dart`)

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.burgundy.withValues(alpha: 0.28)
                : AppColors.glassSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isHighlighted
                  ? AppColors.burgundyLight
                  : AppColors.glassBorder,
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}
```

### 3. Parçalanmış (Modüler) View Şablonu

Ekran yazarken `build` metodunu her zaman küçük parçalara ayır:

```dart
class OrnekEkran extends StatelessWidget {
  const OrnekEkran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTopFilterBar(context),
          Expanded(child: _buildContentList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Araç Vitrini'));
  }

  Widget _buildTopFilterBar(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget _buildContentList() {
    return const Center(child: Text('İçerik'));
  }
}
```
