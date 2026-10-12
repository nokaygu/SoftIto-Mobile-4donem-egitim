class CanSistemi {
  final String karakterAdi;
  double _canPuani =
      100.0; //başındaki alt çizgi bu değişkeni GİZLİ olarak tutar
  CanSistemi({required this.karakterAdi});

  //getter ile can puanı güvenli dışarıya okutma
  double get canPuani {
    return _canPuani;
  }

  //setter ile can değeri değişirken oyun kurallarını denetleyelim
  set canPuani(double yeniCan) {
    if (yeniCan <= 0.0) {
      _canPuani = 0.0;
      print("$karakterAdi canı tükendi ve yere yığıldı");
    } else if (yeniCan > 100.0) {
      _canPuani = 100;
      print("Can tamamen dolu(Maksimum 100 hp olabilir");
    } else {
      _canPuani = yeniCan;
    }
  }

  bool get hayattaMi {
    return _canPuani > 0.0;
  }
}

void main() {
  print("Can barı güvenlik sistemi");

  final savasciCani = CanSistemi(karakterAdi: "meltem demir");
  print("Başlangıç canı        :HP ${savasciCani.canPuani}");
  print("35 hasar aldı");
  savasciCani.canPuani = 65.0;
  print("Kalan can  : HP${savasciCani.canPuani}");
  print("200 can veren iksir içildi");
  savasciCani.canPuani = 200.0;
  print("sabitlenen can: HP${savasciCani.canPuani}");
  print("Ölümcül darbe aldı");
  savasciCani.canPuani = -50.0;
  print("Nihai can: HP${savasciCani.canPuani}");
  print("Savaşçı hayatta mı : ${savasciCani.hayattaMi ? 'hayatta' : 'ölü'}");
}

class Kasa(final String oyuncuAdi) {
  int _altin = 0;
  int get altin => _altin;
  void set altin(int yeniAltin) {
    if (yeniAltin < 0) {
      print("sahte altın girilemez");
    } else {
      _altin = yeniAltin;
      print("yeni altın: $_altin");
    }
  }
}
