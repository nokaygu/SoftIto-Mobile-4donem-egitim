class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);
}

// Fiziksel ve dijital bir enuma konur backendden koduna göre döner
class FizikselUrun extends Urun {
  FizikselUrun(String id, String ad, double fiyat, int stok)
    : super(id, ad, fiyat, stok, "FIZIKSEL");

  double kargoUcretiHesapla() {
    return 29.90;
  }
}

class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
    : super(id, ad, fiyat, stok, "DIJITAL");
}

abstract class SiparisServisi {
  void siparisKaydet(String orderId, double tutar);
}

abstract class OdemeServisi {
  void odemeYap(double tutar);
}

abstract class KargoServisi {
  void kargoGonder(String orderId, String adres);
}

abstract class MailServisi {
  void mailGonder(String email, String mesaj);
}

abstract class SmsServisi {
  void smsGonder(String tel, String mesaj);
}

abstract class FaturaServisi {
  void faturaYazdir(String orderId);
}

abstract class Veritabani {
  void kaydet(String sql);
}

class SqliteVeritabani implements Veritabani {
  @override
  void kaydet(String sql) {
    print("DB calistirildi: " + sql);
  }
}

class SmtpMailServisi implements MailServisi {
  @override
  void mailGonder(String to, String body) {
    print("SMTP Mail gonderildi: " + to);
  }
}

class NetgsmSmsServisi {
  void smsYolla(String gsm, String text) {
    print("SMS iletildi: " + gsm);
  }
}

class SepetYoneticisi implements SiparisServisi {
  //dependency injection denemesi
  final Veritabani db;
  @override
  void siparisKaydet(String orderId, double tutar) {
    db.kaydet("INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }

  SepetYoneticisi(this.db);
}

class KrediKartiOdeme implements OdemeServisi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Kredi kartindan POS ile cekildi.");
  }
}

class HavaleOdeme implements OdemeServisi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Havale kontrol edildi.");
  }
}

class KapidaOdeme implements OdemeServisi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).");
  }
}

class Crypto implements OdemeServisi {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL USDT transferi onaylandi.");
  }
}

class KargoYoneticisi implements KargoServisi {
  final String orderID;
  final String adres;
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }

  KargoYoneticisi(this.orderID, this.adres);
}

class FaturaYoneticisi implements FaturaServisi {
  final String orderID;
  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }

  FaturaYoneticisi(this.orderID);
}

class SiparisYoneticisi {
  SiparisServisi siparisServisi;
  SiparisYoneticisi(this.siparisServisi);
  void siparisTamamla(
    String orderId,
    List<Urun> sepet,
    OdemeServisi odemeYontemi,
    String musteriAdi,
    String email,
    String tel,
    String adres,
    String kuponKodu,
  ) {
    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return;
      }
      toplam += sepet[i].fiyat;
      //enum dönmeli
      if (sepet[i].tip == "FIZIKSEL") {
        FizikselUrun fizikselUrun = sepet[i] as FizikselUrun;
        toplam += fizikselUrun.kargoUcretiHesapla();
      }

      sepet[i].stok--;
    }

    if (kuponKodu == "INDIRIM10") {
      toplam = toplam * 0.90;
    } else if (kuponKodu == "YAZ20") {
      toplam = toplam * 0.80;
    } else if (kuponKodu == "SEPETTE50") {
      toplam = toplam - 50;
    }

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    odemeYontemi.odemeYap(sonTutar);

    siparisServisi.siparisKaydet(orderId, sonTutar);
    final faturaYoneticisi = FaturaYoneticisi(orderId);
    faturaYoneticisi.faturaYazdir(orderId);
    final smtpMailServisi = SmtpMailServisi();
    smtpMailServisi.mailGonder(
      email,
      "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL",
    );
    final smsServisi = NetgsmSmsServisi();
    smsServisi.smsYolla(tel, "Siparisiniz onaylandi: $orderId");
    final kargoYoneticisi = KargoYoneticisi(orderId, adres);
    kargoYoneticisi.kargoGonder;
  }
}

void main() {
  //veritabanı servisi global scopeda tutulsun ki yeniden yaratılmasın
  final veritabani = SqliteVeritabani();
  final sepetYoneticisi = SepetYoneticisi(veritabani);
  var siparisci = SiparisYoneticisi(sepetYoneticisi);

  var urun1 = FizikselUrun("1", "Kablosuz Mouse", 450.0, 5);
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    KrediKartiOdeme(),
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    "INDIRIM10",
  );
}
