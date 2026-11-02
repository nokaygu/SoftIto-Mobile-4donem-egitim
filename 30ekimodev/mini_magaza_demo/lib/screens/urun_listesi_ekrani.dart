import 'package:flutter/material.dart';

import '../models/kategori.dart';
import '../services/api_urun_servisi.dart';
import '../services/i_urun_servisi.dart';

class UrunListesiEkrani extends StatefulWidget {
  final IUrunServisi _servis = ApiUrunServisi();
  final TextEditingControlller _aramaKontrolcusu = TextEditingController();
  List<Urun> _tumUrunler = [];
  List<Urun> _filtrelenmisUrunler = [];
  bool _yukleniyor = true;
  String? hataMesaji;
  Kategori _seciliKategori = Kategori.hepsi;

  @override
  void initState() {
    super.initState();
    _urunleriYukle();
  }

  @override
  void dispose() {
    _aramaKontrolcusu.dispose();
    super.dispose();
  }

  Future<void> _urunleriYukle() async {
    // Ekranı 'Yükleniyor' moduna sokmak ve eski hataları temizlemek için setState çağrılır
    setState(() {
      // Yüklenme animasyonunu başlatır
      _yukleniyor = true;
      // Varsa önceki hata mesajını sıfırlar
      _hataMesaji = null;
      // setState kapanışı
    });
  }
}
