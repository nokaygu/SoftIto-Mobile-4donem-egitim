abstract class LoncaUyesi {
  final String rumuz;

  LoncaUyesi({required this.rumuz});
  //soyut metod abstract metod
  void ozelYetenekKullan();
  void loncaSelamVer() {
    print("$rumuz Lonca bayrağını selamadı:'Onu ve zafer için '");
  }
}

class Sovalye extends LoncaUyesi {
  Sovalye({required super.rumuz});

  @override
  void ozelYetenekKullan() {
    print("$rumuz Demir Kalkanını kaldırdı ve savunma duvarı ördü");
  }
}

class Sifaci extends LoncaUyesi {
  Sifaci({required super.rumuz});
  @override
  void ozelYetenekKullan() {
    print("$rumuz kutsal ışık büyüsüyle tüm takımın canını tazeledi");
  }
}

void savasAlanindaKomutVer(List<LoncaUyesi> takim) {
  print("Liderin emriyle takım yetenekleri devreye girsin");
  for (var t in takim) {
    t.loncaSelamVer();
    t.ozelYetenekKullan();
  }
}

void main() {
  print("Lonca Takımı");
  final List<LoncaUyesi> loncaBirligi = [
    Sovalye(rumuz: "Kızıl Sovalye Adil"),
    Sifaci(rumuz: "Orman Perisi Shahd"),
    Sovalye(rumuz: "Gümüşi Muhafız Eren"),
  ];
  //hepsini tek bir emir ile çalıştırıyoruz
  savasAlanindaKomutVer(loncaBirligi);
}
//soyu canavar sınıfı void kükre metod olacak ondan kurt canavarı ejderha canavarı üret
