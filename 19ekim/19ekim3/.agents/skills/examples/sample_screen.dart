import 'package:flutter/material.dart';

// =============================================================================
// Susadım - Örnek Ekran Uygulaması (sample_screen.dart)
// 
// Bu dosya project.md kırmızı çizgilerine ve skill.md yetenek kurallarına
// %100 uyumlu referans ekran şablonudur:
// - Sayfa düzeyinde ağır setState KULLANILMAZ; ValueNotifier esastır.
// - Statik tüm widget'larda `const` zorunludur.
// - Hiçbir build metodu 40 satırı geçemez.
// - Modeller immutable, copyWith ve JSON metodlarına sahiptir.
// =============================================================================

// -----------------------------------------------------------------------------
// 1. Model Katmanı (Immutable Data Model)
// -----------------------------------------------------------------------------
class WaterRecordModel {
  final String id;
  final int amount; // Mililitre (ml)
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

// -----------------------------------------------------------------------------
// 2. Controller Katmanı (ValueNotifier Reaktif Durum Yöneticisi)
// -----------------------------------------------------------------------------
class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final ValueNotifier<List<WaterRecordModel>> records =
      ValueNotifier<List<WaterRecordModel>>(<WaterRecordModel>[]);

  final int dailyGoalWater = 2500; // Günlük 2500 ml hedef

  void addWater(int amount) {
    if (amount <= 0) return;
    currentWater.value += amount;

    final newRecord = WaterRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      timestamp: DateTime.now(),
    );

    // Değişmezliği koruyarak yeni liste referansı oluşturulur
    records.value = List<WaterRecordModel>.unmodifiable(<WaterRecordModel>[
      ...records.value,
      newRecord,
    ]);
  }

  void resetWater() {
    currentWater.value = 0;
    records.value = const <WaterRecordModel>[];
  }

  void dispose() {
    currentWater.dispose();
    records.dispose();
  }
}

// -----------------------------------------------------------------------------
// 3. Widget Katmanı (Atomik Sunum Bileşenleri - Build < 40 Satır)
// -----------------------------------------------------------------------------

/// İlerleme çubuğunu ve hedef yüzdesini gösteren gösterge kartı.
class WaterGaugeCard extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterGaugeCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ValueListenableBuilder<int>(
          valueListenable: controller.currentWater,
          builder: (context, current, _) {
            final double progress = (current / controller.dailyGoalWater).clamp(0.0, 1.0);
            final int percent = (progress * 100).toInt();

            return Column(
              children: <Widget>[
                Text(
                  'Günlük Hedef: ${controller.dailyGoalWater} ml',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  '$current ml',
                  style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6.0),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text('%$percent Tamamlandı', style: theme.textTheme.labelMedium),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Hızlı su ekleme ve sıfırlama butonları.
class WaterQuickButtons extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterQuickButtons({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FilledButton.tonalIcon(
          onPressed: () => controller.addWater(250),
          icon: const Icon(Icons.local_drink),
          label: const Text('+250 ml'),
        ),
        FilledButton.icon(
          onPressed: () => controller.addWater(500),
          icon: const Icon(Icons.water_drop),
          label: const Text('+500 ml'),
        ),
        IconButton.outlined(
          onPressed: controller.resetWater,
          icon: const Icon(Icons.refresh),
          tooltip: 'Sıfırla',
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. View Katmanı (Ana Ekran İskeleti - Build < 40 Satır)
// -----------------------------------------------------------------------------
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
        title: const Text('Susadım - Hidrasyon'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            WaterGaugeCard(controller: controller),
            const SizedBox(height: 20),
            WaterQuickButtons(controller: controller),
            const SizedBox(height: 28),
            _buildHistoryTitle(context),
            const SizedBox(height: 12),
            _buildRecordList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTitle(BuildContext context) {
    return Text(
      'Bugünkü Kayıtlar',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRecordList() {
    return ValueListenableBuilder<List<WaterRecordModel>>(
      valueListenable: controller.records,
      builder: (context, records, _) {
        if (records.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: Text('Henüz su kaydı girilmedi.')),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: records.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final record = records[index];
            final time =
                '${record.timestamp.hour.toString().padLeft(2, '0')}:${record.timestamp.minute.toString().padLeft(2, '0')}';
            return ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.cyanAccent),
              title: Text('+${record.amount} ml'),
              trailing: Text(time, style: Theme.of(context).textTheme.bodySmall),
            );
          },
        );
      },
    );
  }
}
