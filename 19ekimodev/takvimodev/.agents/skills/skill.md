---
name: flutter-feature-scaffold
description: Flutter projelerinde feature (özellik) bazlı kod yazmak için gerekli klasör yapısını oluşturur. Harici paket kullanmadan ValueNotifier state mimarisini, saf (pure) UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran ya da işlev modülü (örneğin özel takvim görünümü veya günlük yazma ekranı) açarken Clean UI, sıfır harici paket prensibi ve reaktif state kurallarına tam uyulmasını garanti altına alır.

## Temel Kurallar

1. **Asla Tek Dosyada Toplama:** UI (`_view.dart`), State Controller (`_controller.dart`), Alt Bileşenler (`_widget.dart`) ve Model (`_model.dart`) dosyaları ayrı ayrı açılmalıdır.
2. **State Yönetimi:** Reaktif durumlar için yalnızca Flutter'ın yerleşik `ValueNotifier` ve `ValueListenableBuilder` yapıları kullanılmalıdır. Devasa `StatefulWidget`'lar veya harici state paketleri yazarak işi karmaşıklaştırma.
3. **Const Zorunluluğu ve Modern Syntax:** Mümkün olan tüm widget'larda `const` kullanılmalı ve kurucu metodlarda `super.key` tercih edilmelidir.
4. **Sıfır Harici Paket (Zero External Package):** Takvim, metin düzenleyici veya kart tasarımları tamamen Flutter'ın yerleşik widget'ları (`GridView`, `AnimatedContainer`, `DateTime` vb.) ile inşa edilmelidir.

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma

Hedeflenen modül adını (örn: `diary` veya `calendar`), `lib/features/<feature_name>` altına aşağıdaki standartta kur:

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
class DiaryEntryModel {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final String moodEmoji;

  const DiaryEntryModel({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.moodEmoji,
  });

  DiaryEntryModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? content,
    String? moodEmoji,
  }) {
    return DiaryEntryModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      moodEmoji: moodEmoji ?? this.moodEmoji,
    );
  }

  factory DiaryEntryModel.fromJson(Map<String, dynamic> json) {
    return DiaryEntryModel(
      id: json['id'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      moodEmoji: json['mood_emoji'] as String? ?? '📝',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'content': content,
      'mood_emoji': moodEmoji,
    };
  }
}
```

### Adım 3: Controller Dosyasını Yazma

`controllers/<feature_name>_controller.dart` içinde iş mantığını ve `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/foundation.dart';
import '../models/diary_model.dart';

class DiaryController {
  final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<Map<String, DiaryEntryModel>> entries = ValueNotifier<Map<String, DiaryEntryModel>>({});

  String _dateKey(DateTime date) => '${date.year}-${date.month}-${date.day}';

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void saveEntry({required String title, required String content, String mood = '✨'}) {
    final key = _dateKey(selectedDate.value);
    final newEntry = DiaryEntryModel(
      id: key,
      date: selectedDate.value,
      title: title,
      content: content,
      moodEmoji: mood,
    );

    final updatedMap = Map<String, DiaryEntryModel>.from(entries.value);
    updatedMap[key] = newEntry;
    entries.value = updatedMap;
  }

  DiaryEntryModel? getEntryForDate(DateTime date) {
    return entries.value[_dateKey(date)];
  }

  void dispose() {
    selectedDate.dispose();
    entries.dispose();
  }
}
```

### Adım 4: Widget Dosyasını Oluşturma

`widgets/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanarak yeniden kullanılabilir, estetik alt bileşenleri oluştur:

```dart
import 'package:flutter/material.dart';

class CalendarDayTile extends StatelessWidget {
  final int dayNumber;
  final bool isSelected;
  final bool hasEntry;
  final VoidCallback onTap;

  const CalendarDayTile({
    super.key,
    required this.dayNumber,
    required this.isSelected,
    required this.hasEntry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dayNumber',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              ),
            ),
            if (hasEntry) ...[
              const SizedBox(height: 4),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.secondary,
                ),
              ),
            ],
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
import '../controllers/diary_controller.dart';

class DiaryView extends StatelessWidget {
  final DiaryController controller;

  const DiaryView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Günce'),
      ),
      body: ValueListenableBuilder<DateTime>(
        valueListenable: controller.selectedDate,
        builder: (context, currentDate, _) {
          final entry = controller.getEntryForDate(currentDate);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seçili Tarih: ${currentDate.day}.${currentDate.month}.${currentDate.year}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  entry?.content ?? 'Bu gün için henüz bir anı yazılmamış.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Adım 6: Clean Architecture Kurallarına Uyum

- **Separation of Concerns:** Takvim tarih hesaplamaları ile UI çizim kodlarını birbirine karıştırma.
- **Reusability:** Widget'ları ve controller'ları dışarıdan parametre alacak şekilde bağımsız tasarla.
- **Testability:** Her katman için (özellikle tarih hesaplamaları ve günlük kayıt mantığı) birim testleri yazılabilir olduğundan emin ol.

## Ekstra İpuçları

- **Dependency Injection:** Harici paket kullanmadan controller'ları üstten alta constructor (kurucu metod) yoluyla veya yerleşik `InheritedWidget` ile aktar.
- **Tarih Hesaplamaları:** Bir ayın kaç gün çektiğini bulmak için dış paket yerine `DateUtils.getDaysInMonth(year, month)` veya `DateTime(year, month + 1, 0).day` yerleşik metodunu kullan.

## SSS

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Projede yeni bir ekran (örneğin Takvim ekranı, Günlük okuma/yazma ekranı, İstatistik ekranı) veya yeni bir modül oluştururken bu yeteneği kullanmalısın.

### Soru: Bu yeteneği hangi durumlarda kullanmamalıyım?
**Cevap:** Mevcut bir ekranın sadece renk/padding değerini güncellerken veya küçük bir hata düzeltmesi (bugfix) yaparken tüm iskeleti baştan kurmamalısın.
