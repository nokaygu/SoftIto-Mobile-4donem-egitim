import 'package:mini_magaza_demo/models/kategori.dart';
import 'package:mini_magaza_demo/models/rating.dart';

class const Urun({
  required final int id,
  required final String title,
  required final double price,
  required final String description,
  required final Kategori category,
  required final String image,
  required final Rating rating,
}) {
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? 'İsimsiz Ürün',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: Kategori.kategoriGetir(json['category'] as String? ?? ''),
      image: json['image'] as String? ?? '',
      rating: json['rating'] != null
          ? Rating.fromJson(json['rating'] as Map<String, dynamic>)
          : const Rating(rate: 0.0, count: 0),
    );
  }
}
