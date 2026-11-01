import '../models/urun.dart';

abstract interface class IUrunServisi {
  Future<List<Urun>> urunleriGetir();
  Future<Urun?> urunGetirById(int id);
}
