import '../models/kategori.dart';
import '../models/urun.dart';
import 'i_urun_servisi.dart';

class MockUrunServisi implements IUrunServisi {
  final List<Urun> _urunDeposu = const [
    Urun(
      id: 1,
      baslik: 'Macbook m5 pro laptop',
      aciklama: 'Güçlü işlemci ve harika ekran',
      fiyat: 179999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 5,
    ),
    Urun(
      id: 2,
      baslik: "Apple Iphone 18 Pro MAax",
      aciklama: "iphone 17 pro max tıpkı iphone 17 gibi",
      fiyat: 179999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 14,
    ),
    Urun(
      id: 3,
      baslik: "Erkek L Gömlek",
      aciklama: "Kısa kollu",
      fiyat: 299.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.giyim,
      stokAdedi: 5,
    ),
    Urun(
      id: 4,
      baslik: 'Macbook m5 pro laptop',
      aciklama: 'Güçlü işlemci ve harika ekran',
      fiyat: 179999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 5,
    ),
    Urun(
      id: 5,
      baslik: 'kadın spor ayakkabı',
      aciklama: 'şık ve rahat',
      fiyat: 1799.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.ayakkabi,
      stokAdedi: 52,
    ),
    Urun(
      id: 6,
      baslik: 'erkek spor ayakkabı',
      aciklama: 'şık ve rahat',
      fiyat: 1999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.ayakkabi,
      stokAdedi: 35,
    ),
    Urun(
      id: 7,
      baslik: 'saat',
      aciklama: 'şık ve rahat',
      fiyat: 999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.ayakkabi,
      stokAdedi: 35,
    ),
    Urun(
      id: 8,
      baslik: 'güneş gözlüğü',
      aciklama: 'şık ve güneşten korur',
      fiyat: 499.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.giyim,
      stokAdedi: 12,
    ),
    Urun(
      id: 9,
      baslik: 'smart kol saati',
      aciklama: 'adım sayar ve telefon görüşmesi özelliği',
      fiyat: 2999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.giyim,
      stokAdedi: 24,
    ),
  ];
  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return List.from(_urunDeposu);
  }

  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (kategori == Kategori.hepsi) {
      return List.from(_urunDeposu);
    }
    final filitreliListe = _urunDeposu
        .where((urun) => urun.kategori == kategori)
        .toList();
    return filitreliListe;
  }

  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (aramaMetni.trim().isEmpty) {
      return List.from(_urunDeposu);
    }
    final sonuc = _urunDeposu
        .where(
          (urun) =>
              urun.baslik.toLowerCase().contains(aramaMetni.toLowerCase()),
        )
        .toList();
    return sonuc;
  }
}
