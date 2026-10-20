---
name: flutter-feature-scaffold
description: Flutter projelerinde feature (özellik) bazlı kod yazmak için gerekli klasör yapısını oluşturur. Harici paket ve backend kullanmadan ValueNotifier state mimarisini, saf (pure) UI ayrımını, yapılanlar.md takibini ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran ya da işlev modülü (örneğin İş Planı & Ekip Tablosu, Mentor & Hukuk Takibi, Yatırımcı Eşleşme, Hibe Başvurusu veya Topluluk Akışı) açarken Clean UI, sıfır harici paket prensibi ve reaktif state kurallarına tam uyulmasını garanti altına alır.

## Temel Kurallar

1. **Asla Tek Dosyada Toplama:** UI (`_view.dart`), State Controller (`_controller.dart`), Alt Bileşenler (`_widget.dart`) ve Model (`_model.dart`) dosyaları ayrı ayrı açılmalıdır.
2. **State Yönetimi (Backend'siz Reaktif Yapı):** Reaktif durumlar ve lokal veri akışı için yalnızca Flutter'ın yerleşik `ValueNotifier` ve `ValueListenableBuilder` yapıları kullanılmalıdır. Devasa `StatefulWidget`'lar veya harici state paketleri yazarak işi karmaşıklaştırma.
3. **Const Zorunluluğu ve Modern Syntax:** Mümkün olan tüm widget'larda `const` kullanılmalı ve kurucu metodlarda `super.key` tercih edilmelidir.
4. **Sıfır Harici Paket (Zero External Package):** Tablolar, formlar, sekmeler, kart tasarımları ve durum rozetleri tamamen Flutter'ın yerleşik widget'ları (`Table`, `GridView`, `ListView`, `AnimatedContainer` vb.) ile inşa edilmelidir.
5. **`yapilanlar.md` Güncelleme Zorunluluğu:** Yeni bir modül açarken ve tamamlandığında kök dizindeki `yapilanlar.md` dosyası adım adım güncellenmelidir.

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma

Hedeflenen modül adını (örn: `grants`, `investors`, `community`, `onboarding` veya `mentors_legal`), `lib/features/<feature_name>` altına aşağıdaki standartta kur:

```text
lib/features/<feature_name>/
    controllers/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    views/
        <feature_name>_view.dart
    widgets/
        <feature_name>_card.dart
```

### Adım 2: Model Dosyasını Oluşturma

`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metodlarını içerecek şekilde `immutable` (değişmez) olarak tanımla:

```dart
class GrantItemModel {
  final String id;
  final String title;
  final String institution; // KOSGEB, TÜBİTAK, Yurt Dışı (AB) vb.
  final String category;    // Yurt İçi / Yurt Dışı / Devlet
  final String maxAmount;
  final bool isApplied;

  const GrantItemModel({
    required this.id,
    required this.title,
    required this.institution,
    required this.category,
    required this.maxAmount,
    this.isApplied = false,
  });

  GrantItemModel copyWith({
    String? id,
    String? title,
    String? institution,
    String? category,
    String? maxAmount,
    bool? isApplied,
  }) {
    return GrantItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      institution: institution ?? this.institution,
      category: category ?? this.category,
      maxAmount: maxAmount ?? this.maxAmount,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory GrantItemModel.fromJson(Map<String, dynamic> json) {
    return GrantItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      category: json['category'] as String? ?? '',
      maxAmount: json['max_amount'] as String? ?? '',
      isApplied: json['is_applied'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'institution': institution,
      'category': category,
      'max_amount': maxAmount,
      'is_applied': isApplied,
    };
  }
}
```

### Adım 3: Controller Dosyasını Yazma

`controllers/<feature_name>_controller.dart` içinde lokal iş mantığını ve `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/foundation.dart';
import '../models/grants_model.dart';

class GrantsController {
  final ValueNotifier<String> selectedCategory = ValueNotifier<String>('Tümü');
  final ValueNotifier<List<GrantItemModel>> grants = ValueNotifier<List<GrantItemModel>>([
    const GrantItemModel(
      id: 'g1',
      title: 'İleri Girişimci Destek Programı',
      institution: 'KOSGEB',
      category: 'Yurt İçi',
      maxAmount: '1.500.000 ₺',
    ),
    const GrantItemModel(
      id: 'g2',
      title: 'EIC Accelerator Tohum Fonu',
      institution: 'Avrupa İnovasyon Konseyi',
      category: 'Yurt Dışı',
      maxAmount: '2.500.000 €',
    ),
  ]);

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleApplication(String grantId) {
    final updatedList = grants.value.map((item) {
      if (item.id == grantId) {
        return item.copyWith(isApplied: !item.isApplied);
      }
      return item;
    }).toList();
    grants.value = updatedList;
  }

  List<GrantItemModel> get filteredGrants {
    if (selectedCategory.value == 'Tümü') {
      return grants.value;
    }
    return grants.value.where((g) => g.category == selectedCategory.value).toList();
  }

  void dispose() {
    selectedCategory.dispose();
    grants.dispose();
  }
}
```

### Adım 4: Widget Dosyasını Oluşturma

`widgets/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanarak yeniden kullanılabilir, estetik alt bileşenleri oluştur:

```dart
import 'package:flutter/material.dart';
import '../models/grants_model.dart';

class GrantCard extends StatelessWidget {
  final GrantItemModel grant;
  final VoidCallback onApplyTap;

  const GrantCard({
    super.key,
    required this.grant,
    required this.onApplyTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(grant.institution)),
                Text(
                  grant.maxAmount,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(grant.title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: onApplyTap,
                child: Text(grant.isApplied ? 'Başvuru Yapıldı ✓' : 'Hemen Başvur'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Adım 5: View Dosyasını Oluşturma

`views/<feature_name>_view.dart` dosyasında `StatelessWidget` ve `ValueListenableBuilder` kullanarak UI katmanını oluştur:

```dart
import 'package:flutter/material.dart';
import '../controllers/grants_controller.dart';
import '../models/grants_model.dart';
import '../widgets/grants_card.dart';

class GrantsView extends StatelessWidget {
  final GrantsController controller;

  const GrantsView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hibeler ve Destekler'),
      ),
      body: ValueListenableBuilder<List<GrantItemModel>>(
        valueListenable: controller.grants,
        builder: (context, _, __) {
          final items = controller.filteredGrants;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GrantCard(
                grant: item,
                onApplyTap: () => controller.toggleApplication(item.id),
              );
            },
          );
        },
      ),
    );
  }
}
```

### Adım 6: Clean Architecture Kurallarına Uyum

- **Separation of Concerns:** İş mantığı (başvuru onayları, ekip tablosu ekleme/çıkarma, beğeni sayacı) kesinlikle Controller içinde tutulmalı, UI sadece durumu dinlemelidir.
- **Reusability:** Widget'ları ve controller'ları dışarıdan parametre alacak şekilde bağımsız tasarla.
- **Testability:** Her katman için birim ve widget testleri yazılabilir olduğundan emin ol.

## Ekstra İpuçları

- **Dependency Injection:** Harici paket kullanmadan üst seviye durumları (örneğin kullanıcının "Onaylı Girişimci" olup olmadığı bilgisini) constructor (kurucu metod) yoluyla veya yerleşik `InheritedWidget` ile alt ekranlara aktar.
- **Dinamik Tablolar:** İş planı formundaki ekip tablosu için Flutter'ın yerleşik `Table` veya `DataTable` widget'larını kullan.

## SSS

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?

**Cevap:** Projede yeni bir sekme (Mentorlar, Yatırımcılar, Hibeler, Topluluk) veya iş planı başvuru/onay modülü oluştururken bu yeteneği kullanmalısın.

### Soru: Bu yeteneği hangi durumlarda kullanmamalıyım?

**Cevap:** Mevcut bir ekranın sadece renk/padding değerini güncellerken veya küçük bir hata düzeltmesi (bugfix) yaparken tüm iskeleti baştan kurmamalısın.
