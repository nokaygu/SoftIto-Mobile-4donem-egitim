class BildirimModeli {
  final String id;
  final String baslik;
  final String icerik;
  final DateTime tarih;
  final bool okunduMu;
  const BildirimModeli({
    required this.id,
    required this.baslik,
    required this.icerik,
    required this.tarih,
    this.okunduMu = false,
  });
//okundu mu final değiştirmek için copywith kullanarak tamaen yeni bir obje oluştur
  BildirimModeli copyWith({
    String? id,
    String? baslik,
    String? icerik,
    DateTime? tarih,
    bool? okunduMu,
  }) => BildirimModeli(
    id: id ?? this.id,
    baslik: baslik ?? this.baslik,
    icerik: icerik ?? this.icerik,
    tarih: tarih ?? this.tarih,
    okunduMu: okunduMu ?? this.okunduMu,
  );
}
