import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yenimagaza/models/urun_model.dart';
import 'package:yenimagaza/services/i_urun_servisi.dart';

class CanliApiUrunServisi implements IUrunServisi {
  static const String _base_url = "https://fakestoreapi.com/products";
  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try {
      final yanit = await http
          .get(Uri.parse(_base_url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Ağ zaman aşımına uğradı.');
            },
          );
      if (yanit.statusCode == 200) {
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Sunucu hatasıı: ${yanit.statusCode}');
      }
    } catch (e) {
      print('Ağ hatası: $e');
      rethrow;
    }
  }
}
