import "kategori.dart";

import 'dart:math';

class Urun {
  final int id;
  final String baslik;
  final String aciklama;
  final double fiyat;
  final String resimUrl;
  final Kategori kategori;
  final int stokAdedi;
  final bool favoriMi;

  Urun({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.fiyat,
    this.resimUrl = "https://picsum.photos/${Random().nextInt(900)}/400",
    required this.kategori,
    required this.stokAdedi,
    this.favoriMi = false,
  });

  Urun copyWith({
    int? id,
    String? baslik,
    String? aciklama,
    double? fiyat,
    String? resimUrl,
    Kategori? kategori,
    int? stokAdedi,
    bool? favoriMi,
  }) {
    return Urun(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      fiyat: fiyat ?? this.fiyat,
      resimUrl: resimUrl ?? this.resimUrl,
      kategori: kategori ?? this.kategori,
      stokAdedi: stokAdedi ?? this.stokAdedi,
      favoriMi: favoriMi ?? this.favoriMi,
    );
  }

  @override
  String toString() {
    return 'Urun(id: $id, baslik: $baslik, aciklama: $aciklama, fiyat: $fiyat, favoriMi: $favoriMi)';
  }
}
