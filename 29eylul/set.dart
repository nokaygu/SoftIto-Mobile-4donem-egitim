void main() {
  print("Beyaz liste ve küme analizi");
  final Set<String> istanbulVeriMerkeziTipleri = {
    "10.0.1.10",
    "10.0.1.11",
    "10.0.1.12",
    "10.0.1.13",
    "10.0.1.10", //çift kayıtteke üşer
  };
  print("istanbul ipleri:$istanbulVeriMerkeziTipleri");

  final Set<String> frankfurtVeriMerkeziTipleri = {
    "10.0.1.13",
    "10.0.1.30",
    "10.0.1.40",
  };
  print("frankfurt ipleri: $frankfurtVeriMerkeziTipleri");
  final ortakKopruIpler = istanbulVeriMerkeziTipleri.intersection(
    frankfurtVeriMerkeziTipleri,
  );
  print("ortak ağ ipleri (kesişim): $ortakKopruIpler");
  final tumGlobalIplar = istanbulVeriMerkeziTipleri.union(
    frankfurtVeriMerkeziTipleri,
  );
  print("tüm global ağ ipleri (birleşim): $tumGlobalIplar");
  final sadeceIstanbul = istanbulVeriMerkeziTipleri.difference(
    frankfurtVeriMerkeziTipleri,
  );
  print("sadece istanbul: $sadeceIstanbul");
}
