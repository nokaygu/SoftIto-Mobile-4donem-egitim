enum CihazTipi { sensor, gateway, edgeServer, router }

typedef CihazBilgi = ({String cihazAdi, CihazTipi tip, bool alarmDurumu});

class IotCihaz {
  final String seriNo;
  final String cihazAdi;
  final CihazTipi tip;
  double cpuYukYuzdesi;
  int bellekMb;
  final Set acikPortlar;
  final bool sslSertifikasiGecerliMi;
  var sonCpuYuzdesi = 0.0;
  var sonBellekMb = 0;
  new({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi,
  });
  @override
  String toString() =>
      "$cihazAdi [$seriNo](CPU %$cpuYukYuzdesi,Ram:${bellekMb}MB, Conn: $acikPortlar)\n ";
  bool get guvenlikAcigiVarMi =>
      !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET");

  String izolasyonBolgesiKoduAl() => switch (tip) {
    CihazTipi.sensor => "ZONE-S",
    CihazTipi.gateway => "ZONE-G",
    CihazTipi.edgeServer => "ZONE-E",
    CihazTipi.router => "ZONE-R",
  };
  //tum enum tipleri kullanılığı için return tip olduğu halde exhausted
  void cihazKapat() {
    sonCpuYuzdesi = cpuYukYuzdesi;
    sonBellekMb = bellekMb;
    cpuYukYuzdesi = 0;
    bellekMb = 0;
  }

  void kapaliCihazAc() {
    cpuYukYuzdesi = sonCpuYuzdesi;
    bellekMb = sonBellekMb;
  }

  void isYap() {
    if (cpuYukYuzdesi == 0.0 || bellekMb == 0) {
      throw CihazErisilemezException(
        "cihaz kapalı [cpu çalışmıyor/bellek boş]",
      );
    }
    print("cihaz iş yapıyor");
  }
}

class CihazErisilemezException implements Exception {
  final String mesaj;

  CihazErisilemezException(this.mesaj);

  @override
  String toString() => mesaj;
}

void main() {
  final cihazBirPortlar = {"22/DELNET", "21/BELNET", "20/ZELNET"};
  final cihazIkiPortlar = {"19/CELNET", "18/SELNET", "17/MELNET"};
  final cihazUcPortlar = {"24/YELNET", "25/KELNET", "23/TELNET"};
  final cihazDortPortlar = {"22/DELNET", "25/KELNET", "21/BELNET"};
  final cihazBesPortlar = {"24/YELNET", "21/BELNET", "23/TELNET"};
  final cihazAltiPortlar = {"21/BELNET", "25/KELNET", "22/DELNET"};

  final cihazBir = IotCihaz(
    seriNo: "1234556",
    cihazAdi: "Cihaz Bir",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 84.5,
    bellekMb: 789,
    acikPortlar: cihazBirPortlar,
    sslSertifikasiGecerliMi: true,
  );
  final cihazIki = IotCihaz(
    seriNo: "1234556",
    cihazAdi: "Cihaz İki",
    tip: CihazTipi.gateway,
    cpuYukYuzdesi: 44.5,
    bellekMb: 345,
    acikPortlar: cihazIkiPortlar,
    sslSertifikasiGecerliMi: false,
  );
  final cihazUc = IotCihaz(
    seriNo: "2345678",
    cihazAdi: "Cihaz Üç",
    tip: CihazTipi.edgeServer,
    cpuYukYuzdesi: 64.6,
    bellekMb: 432,
    acikPortlar: cihazUcPortlar,
    sslSertifikasiGecerliMi: true,
  );
  final cihazDort = IotCihaz(
    seriNo: "8765432",
    cihazAdi: "Cihaz Dört",
    tip: CihazTipi.router,
    cpuYukYuzdesi: 24.5,
    bellekMb: 543,
    acikPortlar: cihazDortPortlar,
    sslSertifikasiGecerliMi: true,
  );
  final cihazBes = IotCihaz(
    seriNo: "6554321",
    cihazAdi: "Cihaz Beş",
    tip: CihazTipi.gateway,
    cpuYukYuzdesi: 67.5,
    bellekMb: 654,
    acikPortlar: cihazBesPortlar,
    sslSertifikasiGecerliMi: false,
  );
  final cihazAlti = IotCihaz(
    seriNo: "6555432",
    cihazAdi: "Cihaz Altı",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 44.0,
    bellekMb: 789,
    acikPortlar: cihazAltiPortlar,
    sslSertifikasiGecerliMi: true,
  );
  final tumCihazlar = [
    cihazBir,
    cihazIki,
    cihazUc,
    cihazDort,
    cihazBes,
    cihazAlti,
  ];
  final ilkCihaz = tumCihazlar[0];
  print("3.adım tüm cihazlar:");
  for (var cihaz in tumCihazlar) {
    print(cihaz);
  }

  print("4.adım:");
  final guvensizCihazlar = guvensizCihazlarGetir(tumCihazlar);
  print("güvensiz cihazlar:$guvensizCihazlar");

  print("5.adım:");
  final tumCihazlarMb = cihazlarToplamBellek(tumCihazlar);
  print("cihazların sahip olduğu toplam bellek $tumCihazlarMb");

  print("6.adım:");
  try {
    print(cihazBilgiAl(ilkCihaz.seriNo, tumCihazlar));
  } catch (e) {
    print(e);
  }
  print("7.adım:");
  print(
    'Cihaz adı: "${ilkCihaz.cihazAdi}". Güvenlik izolasyon bölgesi kodu "${ilkCihaz.izolasyonBolgesiKoduAl()}"',
  );
  print("8.adım:");
  ilkCihaz.cihazKapat();
  try {
    ilkCihaz.isYap();
  } on CihazErisilemezException catch (e) {
    print("hata $e");
  } catch (e) {
    print("bilinmedik sistem hatası $e");
  }
}

List<IotCihaz> guvensizCihazlarGetir(List<IotCihaz> tumcihazlar) => tumcihazlar
    .where((cihaz) => cihaz.guvenlikAcigiVarMi || cihaz.cpuYukYuzdesi > 85)
    .toList();

int cihazlarToplamBellek(List<IotCihaz> cihazlar) =>
    cihazlar.fold(0, (toplam, cihaz) => toplam + cihaz.bellekMb);

CihazBilgi cihazBilgiAl(String seriNo, List<IotCihaz> cihazlar) {
  for (var cihaz in cihazlar) {
    if (cihaz.seriNo == seriNo) {
      final alarmDurumu = cihaz.guvenlikAcigiVarMi;
      return (
        cihazAdi: cihaz.cihazAdi,
        tip: cihaz.tip,
        alarmDurumu: alarmDurumu,
      );
    }
  }
  throw Exception("Böyle bir cihaz yok");
}
