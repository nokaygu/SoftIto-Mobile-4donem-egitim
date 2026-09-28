//1.Enumları (derleme Zamanı güvenliği)
// enumları genelde backenden gelen kodları/stringleri vs çevirmek için kullanırım
enum HizmetKategorisi { ciltYenileme, medikalEstetik, lazerEpilasyon, Lipo }

enum SeansDurumu { bekliyor, odadaIslemde, tamamlandi, iptalEdildi }

enum OdemeYontemi { krediKarti, havaleEft, nakit, klinikPaketKredisi }

//Danışan (müşteri) Modeli
// fieldlarımızı constructorlarımızı yazıyoruz .birleşik de yazıklabiir
// constructor'ın const olabilmesi için sınıftaki instance field'ların da değiştirilemez olması gerekir
class Danisan {
  final String id;
  final String adSoyad;
  final String telefon;
  final bool vipUyeMi;
  final List<String> alerjiler; // boş olabilir ama null olamaz
  final String? ozelCiltNotu; // Opsiyonel Null olabilir

  const Danisan({
    //required bu bilgi verilmeli
    // parametre ile verilen id id fielda setlenecek
    required this.id,
    required this.adSoyad,
    required this.telefon,
    //default değeri false olan named parameter
    this.vipUyeMi = false,
    this.alerjiler = const [],
    this.ozelCiltNotu,
  });
  //getter
  // her çağrıldığında tekrardan hesaplanır
  bool get hassasCiltMi => alerjiler.isNotEmpty;

  //Bilgi özet kartı
  String get bilgiOzeti {
    //alerjiler boş diziyse kayıtlı alerji yok,
    // değilse dizideki elemanlar virgülle beraber tek stringe birleşsin
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"
        : "Alerjiler: ${alerjiler.join(', ')}";
    //nulsa sağdaki stringe setle
    final String notBilgisi = ozelCiltNotu ?? "Özel medikal not girilmemiş";
    // vipüyemi truesa vipfalsesa standart
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans (randevu) Modeli
//soru işareti olanlar null olabilir
// final değişmez const verisi en başta bir kere verilir kod yazılırken
class SeansKaydi {
  final String seansKodu;
  final Danisan danisan;
  final HizmetKategorisi kategori;
  final String islemAdi;
  final double birimFiyat;
  final int seansSayisi;
  final double indirimOrani; // Örn 10.0
  final String? sorumluUzman; //nullable
  SeansDurumu durum;
  OdemeYontemi? odemeTipi;

  SeansKaydi({
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi,
    required this.birimFiyat,
    this.seansSayisi = 1,
    this.indirimOrani = 0.0,
    this.sorumluUzman,
    this.durum = SeansDurumu.bekliyor,
    this.odemeTipi,
  });
  //brüttutar seans sayısı kadar birim fiyatla çarpılır
  double get brutTutar => birimFiyat * seansSayisi;

  double get indirimTutari {
    double toplamOran = indirimOrani;
    //eğer danışan vipüyeyse 10 fazladan indirim
    if (danisan.vipUyeMi) {
      toplamOran += 10.0;
    }
    //yüzde kaç indiirm bulduk toplam fiyat çarpınca indirim fiyatı çıktı
    return brutTutar * (toplamOran / 100.0);
  }

  //bildiğimiz net fiyat hesaplama formülü
  double get netTutar => brutTutar - indirimTutari;
}

// Yönetim Servisi

class KlinikYoneticisi {
  final String subeAdi;
  //private seanslar dizisi ancak class içinden müdahele edilebilr
  final List<SeansKaydi> _seanslar = [];
  //private map/dictionary string key danışan value
  final Map<String, Danisan> _danisanRehberi = {};
  //constructor sadece subeadi fieldini belirtilmesini istiyor
  KlinikYoneticisi({required this.subeAdi});

  //Danışan kaydetme
  // diziye manuel müdahala etmiyorum bu fonksiyon aracılığıyla diziye danisan ekleyebiliyorum
  void danisanKaydet(Danisan danisan) {
    _danisanRehberi[danisan.id] = danisan;
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }

  //seanslar da private bu public fonksiyonu kullanrak dşardan seans ekliyırum
  void randevuOlustur(SeansKaydi seans) {
    _seanslar.add(seans);
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }

  //{ } şeklinde parametrede seanskodu: gibi isim vererek parameter verebilirm. required veri vereceğim null olamyacak diyorum
  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    //seanslardaki tüm seansları dönerim her biri işlem sırasında seans olarak değerlendirilir dizinin doğrudan elemanlarını kullanırım
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        // dizideki seans objesinin durumu tamamlandı olur odeme tipi de fonksiyona verildiği şekilde setlenir
        seans.durum = SeansDurumu.tamamlandi;
        seans.odemeTipi = odeme;
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
        return; //return burda çalışması gerekiyor eşlenik bulunca kod bitsin
        //print tarafına gidilmesin
      }
    }
    print("Hata [$seansKodu] kodlu seans bulunamadı");
  }

  //üsttekinin aynısı sadece iptal ediyor
  // iptalnedeni null verilebilir, nuıl verilirse gerekçe belirtilmedi olcak
  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurumu.iptalEdildi;
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );
        return;
      }
    }
  }

  // Finansal Rapor Metotları(fonksiyonel dart)
  // durumu tamamlandı olan seanslar filtrelenir sonra da bu kalanlar üst üste toplanır toplamı dönülür
  double get toplamTahsilEdilenCiro => _seanslar
      .where((s) => s.durum == SeansDurumu.tamamlandi)
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  //beklemede veya işlemde olan seanslar için tutar hesaplaması yapıyoruz
  double get beklenenPotansiyelCiro => _seanslar
      .where(
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // kategori bazlı seans sayıları
  //hizmetkategorisnin ne kadarları varmış onu hesaplıyoruz
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {};
    for (var kat in HizmetKategorisi.values) {
      //baştan tüm kategoriler mape konuyor başlanıç valueları da sıfır setleniyor
      dagilim[kat] = 0;
    }
    for (var s in _seanslar) {
      //üstteki işlemde kategorimi mapime yerleştirmiş olmalyıım value 0 olarak buırada bir arttırarak seans dizisinde eşi varsa kategorideki hizmet sayısı artmış olacak
      // yok yukarda bulunmadıysa başlangıç 0 olacak şekilde mape ekleme olacak
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }
    return dagilim;
  }

  //sorumlu uzmanlarımı akışa aldım sonra set içinde koydum ki iki kere aynı uzmanı koymayayım
  Set<String> gorevliUzmanKadrosu() {
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet();
  }

  //uzmanı olmayan seansları filtreledim sonra direkt bu seans nesnelerimi listeye koydum (üsttekilerde seansların içindeki uzman değerleri kullanmıştım)
  //Uzmansız kalan seanslar
  List<SeansKaydi> uzmansizSeanslariGetir() {
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  //void demek dönüş değeri yapmıyorum
  void gunSonuRaporuYazdir() {
    print("Günlük Seans ve İşlem Çizelgesi");
    print("---------------------------------------");
    //width kısaysa yana padding ver diyor
    print(
      "${'Kod'.padRight((10))} | "
      "${'Danışan'.padRight(16)} | "
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | ",
    );
    print("---------------------------------------");
    //tüm seansları döndüm ön
    for (var s in _seanslar) {
      //önce seansım içindeki uzman adımı aldım burada her şeyfor içinde olduğu için tek bir satırı yapıyor gibi düşünebiliriz
      // uzman yoksa nöbetçi bekliyor
      final String uzman = s.sorumluUzman ?? " Nöbetçi Bekliyor";
      //switchi bu şekilde value gibi kuollanmayı özellikle enumla kulanmayı çok seviyorum çok kullanışlı bir yöntem
      // enum durumuna göre tek kodlamada string eşine çeviriyorum
      final String durumRozet = switch (s.durum) {
        SeansDurumu.tamamlandi => "Tamamlandı",
        SeansDurumu.odadaIslemde => "İşlemde",
        SeansDurumu.bekliyor => "Bekliyor",
        SeansDurumu.iptalEdildi => "İptal",
      };
      //satırımı giriyorum
      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        "$durumRozet",
      );
    }
    //tablonun altındaki finanszal özet kısmı
    print("---------------------------------------");
    print("Finansal Özet:");
    //2 dijite göre ayarladım
    // cirolarımı verdim
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );
    print(
      " * Bekleyen Potansiyen Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );
    //dizimin üye sayısı kadar seansım vardır o kadar da randevum olur
    print(" * Toplam Seans : ${_seanslar.length} Randevu");
    print("---------------------------------------");
    print("Aktif Uzmanlar");
    final uzmanlar = gorevliUzmanKadrosu();
    //uzmanlar  boşsa  kayıtlı uzman yok demektir
    if (uzmanlar.isEmpty) {
      print("Kayıtlı Uzman Bulunamadı");
    } else {
      //uzmanlar dizim boş değğilse tüm üyelerimi tek stringtevirgülle birleşitridim
      print(" ${uzmanlar.join(', ')}");
    }
    final uzmansizlar = uzmansizSeanslariGetir();
    if (uzmansizlar.isNotEmpty) {
      //kaç uzmansız seans varsa o akdar seansa uzman gerek
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );
      //tüm uzmansızları alt alta giriyorum
      for (var u in uzmansizlar) {
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    print("---------------------------------------");
  }
}

void main() {
  print("Klinik yönetim sistemi başlatılıyor....");
  final yonetici = KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");

  //danışanları oluşturalım
  final d1 = Danisan(
    id: "DAN-101",
    adSoyad: "Ahmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );
  final d2 = Danisan(
    id: "DAN-102",
    adSoyad: "Ahmet Yılan",
    telefon: "0555 555 55 55",
    vipUyeMi: false,
    //boş dizi alrerjisi yok
    alerjiler: [],
  );
  final d3 = Danisan(
    id: "DAN-103",
    adSoyad: "Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
  );
  final d4 = Danisan(
    id: "DAN-104",
    adSoyad: "Ahmet Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: [],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );
  //yonetici danisankaydet ile diziye dışarıdan ekleme yapaabilyorum private dizi de olsa
  yonetici.danisanKaydet(d1);
  yonetici.danisanKaydet(d2);
  yonetici.danisanKaydet(d3);
  yonetici.danisanKaydet(d4);

  print("Danışan güvenlik kontrolü");
  print(d1.bilgiOzeti);
  print(d2.bilgiOzeti);
  print("----------------------------------");

  // randevular oluşturuluyor
  final seans1 = SeansKaydi(
    seansKodu: "SNS-2026-1",
    danisan: d1,
    kategori: HizmetKategorisi.Lipo,
    islemAdi: "Lipo gerisini bilmiyorum",
    birimFiyat: 6500.0,
    seansSayisi: 2,
    indirimOrani: 5.0,
    sorumluUzman: "Sümeyye Arab",
  );
  final seans2 = SeansKaydi(
    seansKodu: "SNS-2026-2",
    danisan: d2,
    kategori: HizmetKategorisi.ciltYenileme,
    islemAdi: "Siverex ile yüz temizleme",
    birimFiyat: 2500.0,
    seansSayisi: 5,
    indirimOrani: 15.0,
    sorumluUzman: null,
  );
  final seans3 = SeansKaydi(
    seansKodu: "SNS-2026-3",
    danisan: d3,
    kategori: HizmetKategorisi.lazerEpilasyon,
    islemAdi: "Tüm Vücut",
    birimFiyat: 25000.0,
    seansSayisi: 15,
    indirimOrani: 0.0,
    sorumluUzman: "Tuba Aydın",
  );
  final seans4 = SeansKaydi(
    seansKodu: "SNS-2026-4",
    danisan: d4,
    kategori: HizmetKategorisi.medikalEstetik,
    islemAdi: "Burun Estetiği",
    birimFiyat: 1500.0,
    seansSayisi: 3,
    sorumluUzman: "Alaaddin Odabaşı",
  );
  //randevular oluşturuluyor
  yonetici.randevuOlustur(seans1);
  yonetici.randevuOlustur(seans2);
  yonetici.randevuOlustur(seans3);
  yonetici.randevuOlustur(seans4);
  print("Seanslar Gönderiliyor");

  //seans 1 başarıyla tamamlanıyor (kredi kartı ile ödeme);
  yonetici.seansiTamamla(
    seansKodu: "SNS-2026-1",
    odeme: OdemeYontemi.krediKarti,
  );
  //seans 2 başarıyla tamamlanıyor (nakit ödeme);
  yonetici.seansiTamamla(seansKodu: "SNS-2026-2", odeme: OdemeYontemi.nakit);
  //seans 4 iptal ediliyor
  yonetici.seansiIptalEt(
    "SNS-2026-04",
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
  );

  yonetici.gunSonuRaporuYazdir();
}
