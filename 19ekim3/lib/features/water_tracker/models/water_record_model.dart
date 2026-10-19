/// Su tüketim kaydı veri modeli
class WaterRecord {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String note;

  const WaterRecord({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.note = 'Hızlı Ekleme',
  });

  WaterRecord copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? note,
  }) {
    return WaterRecord(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  factory WaterRecord.fromJson(Map<String, dynamic> json) {
    return WaterRecord(
      id: json['id'] as String? ?? '',
      amountMl: json['amount_ml'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount_ml': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }
}
