---
name: flutter-feature-scaffold
description: Flutter projelerinde feature bazlı modüler kod mimarisini oluşturur. ValueNotifier reaktif state mimarisini, UI/Controller/Model katman ayrımını, 40 satır altı widget kuralını ve birim test iskeletini standartlara tam uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, **Susadım** ve benzeri Flutter projelerinde yeni bir ekran ya da işlev modülü açarken Clean UI ve reaktif state kurallarına tam uyulmasını garanti altına alır.

---

## 1. Temel Kurallar ve Kırmızı Çizgiler

1. **Asla Tek Dosyada Toplama:**
   - Görünüm (`_view.dart`),
   - Durum Yöneticisi (`_controller.dart`),
   - Model (`_model.dart`),
   - Alt Bileşenler (`_card.dart` vb. `widgets/` altında)
   dosyaları kesinlikle ayrı ayrı açılmalıdır.
2. **Reaktif State Yönetimi (`ValueNotifier`):**
   - Sayfa düzeyinde ağır `setState` kullanımı yasaktır.
   - Durumlar için `ValueNotifier<T>` ve `ValueListenableBuilder<T>` kullanılmalıdır.
   - Harici ağır kütüphaneler (Bloc, Riverpod vb.) proje onayı olmadan eklenemez.
3. **Const Zorunluluğu:**
   - Statik ve değişmeyen tüm widget düğümlerinde `const` kullanımı zorunludur.
4. **40 Satır Kuralı:**
   - Hiçbir widget'ın `build` metodu 40 satırı geçemez. Geçen yapılar bağımsız alt widget'lara parçalanmalıdır.
5. **Bellek Güvenliği:**
   - Her Controller sınıfı, dinleyicileri serbest bırakan bir `dispose()` metoduna sahip olmalıdır.

---

## 2. Yardımcı Belgeler ve Otomasyon

Bu yetenek kapsamında aşağıdaki modüler kaynaklar hazırlanmıştır:

- **Mimari Referans Dokümanı:** [references/state_flow.md](file:///Users/d1-10/projects/SoftIto-Mobile-4donem-egitim/19ekim3/.agents/skills/references/state_flow.md)
- **Modül Üretici Betik:** [script/generate_feature.sh](file:///Users/d1-10/projects/SoftIto-Mobile-4donem-egitim/19ekim3/.agents/skills/script/generate_feature.sh)
- **Örnek Ekran Uygulaması:** [examples/sample_screen.dart](file:///Users/d1-10/projects/SoftIto-Mobile-4donem-egitim/19ekim3/.agents/skills/examples/sample_screen.dart) (ve detaylı dokümanı [examples/sample_screen.md](file:///Users/d1-10/projects/SoftIto-Mobile-4donem-egitim/19ekim3/.agents/skills/examples/sample_screen.md))

---

## 3. Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma

Hedeflenen modül adını (örn: `water_tracker`), `lib/features/<feature_name>` altına kur:

```text
lib/features/<feature_name>/
    controllers/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    view/
        <feature_name>_view.dart
    widgets/
        <feature_name>_card.dart

test/features/<feature_name>/
    <feature_name>_controller_test.dart
```

> [!TIP]
> Bu klasörleme ve temel dosyaları tek komutla otomatik üretmek için [script/generate_feature.sh](file:///Users/d1-10/projects/SoftIto-Mobile-4donem-egitim/19ekim3/.agents/skills/script/generate_feature.sh) betiğini çalıştırabilirsiniz:
> ```bash
> ./.agents/skills/script/generate_feature.sh <feature_name>
> ```

---

### Adım 2: Controller Dosyasını Yaz

`controllers/<feature_name>_controller.dart` içinde iş mantığını ve `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/foundation.dart';

class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final int dailyGoalWater = 2000; // 2 litre

  void addWater(int amount) {
    if (amount <= 0) return;
    currentWater.value += amount;
  }

  void resetWater() {
    currentWater.value = 0;
  }

  void dispose() {
    currentWater.dispose();
  }
}
```

---

### Adım 3: Model Dosyasını Oluşturma

`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson` ve `toJson` metodlarını içerecek şekilde `immutable` olarak tanımla:

```dart
class WaterRecordModel {
  final String id;
  final int amount;
  final DateTime timestamp;

  const WaterRecordModel({
    required this.id,
    required this.amount,
    required this.timestamp,
  });

  WaterRecordModel copyWith({
    String? id,
    int? amount,
    DateTime? timestamp,
  }) {
    return WaterRecordModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WaterRecordModel.fromJson(Map<String, dynamic> json) {
    return WaterRecordModel(
      id: json['id'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
```

---

### Adım 4: View Dosyasını Oluşturma

`view/<feature_name>_view.dart` dosyasında `StatelessWidget` kullanarak UI katmanını oluştur:

```dart
import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../widgets/water_quick_buttons.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Takibi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder<int>(
              valueListenable: controller.currentWater,
              builder: (context, currentValue, _) {
                return Text(
                  'Mevcut Su: $currentValue ml',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 24),
            WaterQuickButtons(controller: controller),
          ],
        ),
      ),
    );
  }
}
```

---

### Adım 5: Widget Dosyasını Oluşturma

`widgets/<feature_name>_card.dart` dosyasında 40 satırı geçmeyen, yeniden kullanılabilir sunum bileşenini oluştur:

```dart
import 'package:flutter/material.dart';
import '../models/water_record_model.dart';

class WaterRecordCard extends StatelessWidget {
  final WaterRecordModel record;

  const WaterRecordCard({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: const Icon(Icons.water_drop, color: Colors.cyan),
        title: Text('+${record.amount} ml', style: theme.textTheme.titleMedium),
        trailing: Text(
          '${record.timestamp.hour.toString().padLeft(2, '0')}:${record.timestamp.minute.toString().padLeft(2, '0')}',
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }
}
```

---

### Adım 6: Clean Architecture Kurallarına Uyum

- **Separation of Concerns:** Her dosyanın belirli ve tek bir sorumluluğu olmalıdır.
- **Reusability:** Widget'lar ve controller'lar diğer ekranlarda da kullanılabilecek şekilde tasarlanmalıdır.
- **Testability:** Her katman için bağımsız birim testleri yazılmalıdır.

---

## 4. Birim Testleri (`flutter test`)

Controller testleri saf Dart ortamında UI render edilmeden koşar:

```dart
import 'package:flutter_test/flutter_test.dart';
import '../../lib/features/water_tracker/controllers/water_tracker_controller.dart';

void main() {
  group('WaterTrackerController Testleri', () {
    late WaterTrackerController controller;

    setUp(() {
      controller = WaterTrackerController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç su miktarı sıfır olmalıdır', () {
      expect(controller.currentWater.value, 0);
    });

    test('addWater çağrıldığında miktar artmalıdır', () {
      controller.addWater(250);
      expect(controller.currentWater.value, 250);
    });
  });
}
```

---

## 5. Doğrulama ve SSS

### Doğrulama Komutları:
```bash
# Kod analizi (0 hata ve 0 uyarı zorunludur)
flutter analyze

# Birim testleri
flutter test
```

### Soru & Cevap:
- **Soru:** Hangi durumlarda bu yeteneği kullanmalıyım?
  - **Cevap:** Yeni bir ekran, özellik (feature) veya işlev modülü oluştururken bu yeteneği kullanmalısın.
- **Soru:** Bu yetenek hangi durumlarda kullanılmamalıdır?
  - **Cevap:** Küçük bir hata düzeltmesi veya var olan bir widget içindeki ufak stil güncellemesi yapılırken yeni modül iskeleti açılmamalıdır.
