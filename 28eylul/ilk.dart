/*void main() {

  //jsdeki gibi let x="ahmet"; x=42;
  // print("ilk desrimiz-dark sdk aktif olmaşo");
  int seansSuresiDakika=45;
  double seansUcretiTl=2750.50;
  String uzmanAdi="Dr Aygen Yıldırım";
  bool AktifMi=true;

  //2.string interpolation
  // jsdeki $`{}` bubun yerinde sadece $degisken işlem varsa ${} kullanılır
  print("Uzman: $uzmanAdi | Süre: $seansSuresiDakika dk | Ücret: $seansUcretiTl TL");
  print("KDV dahil (%20): ${seansUcretiTl * 1.20} TL");
  //var ile tip çıkarımı
  var tedaviAdi="kahve ile peeling";
  //tedaviAdi=99;
  // dynamic veri tipini bağımsız kullanabilirsiniz
  // ancak flutterde öğrenilmez
  dynamic serbestKutu="lazer epilasyon";
  serbestKutu=1000; //izin veirlir veri tip güvenilğini yok eder
  //const:Derleme anında değeri belli olan veirler, bellekte tek bir yerde sakklanır
  const String KLINIK_ADI="Softİto Güzellik Merkezi";
  const double KDV_ORANI=0.20;
//  const DateTime suankiZaman=DateTime.now();// hata derleme anında bilemeyiz
  // final: çalışma anında hesaplanaır, bir kere atandıktan sonra değiştirilmez
  final DateTime randevuZamani=DateTime.now();
  final String takipKodu="SOFT-"+randevuZamani.microsecondsSinceEpoch.toString();
  print("klinik adı:$KLINIK_ADI");
  print("oluşturulma tarihi : $randevuZamani | Kod: $takipKodu");
  //dartta değişken varsayılan olarak null olamaz bunun yerine null safety opretorleri kullanıır (?,??,!)
  String zorunluDanisanAdi = "Meltem Demir";
  String? danisanAlerjiNotu;
  print("alerji notu:$danisanAlerjiNotu");

  //ifnulloperatoru null ise varasılarn deger atama
  String goruntulenecekNot = danisanAlerjiNotu ?? "bilinen bir alerjisi yok";
  print("rapor:$goruntulenecekNot");
  //nul aware
  print("alerji metin uzunlu: ${danisanAlerjiNotu?.length}");
  double topla(double a, double b) => a + b;}*/
//modern dart flutter standartları named parameter ({})
void seansKaydiOlustur({
  required String danisan,
  required String tedavi,
  required double birimFiyat,
  int seansSayisi = 1, //default değer
  double indirimOrani = 0.0, //default değer
  String? uzmanHekim,
}) {
  final double brutTutar = birimFiyat * seansSayisi;
  final double indirimTutari = brutTutar * (indirimOrani / 100);
  final double netTutar = brutTutar - indirimTutari;
  print("""
===============================

Softito Seans Sözleşmesi

===============================
Danışan         :     $danisan
Tedavi          :     $tedavi  (x$seansSayisi Seans)
Uzman Hekim     :     ${uzmanHekim ?? "Nöbetçi Estetisyen"}
Brüt tutar      :     $brutTutar TL
İndirim         :     -$indirimTutari TL ($indirimOrani)
Ödenecek Tutar  :     $netTutar TL
""");
}

void main() {
  seansKaydiOlustur(
    danisan: "Sümeyye Muhammed",
    tedavi: "Medikal Cilt Yenileme",
    birimFiyat: 4500.0,
    seansSayisi: 3,
    indirimOrani: 15.0,
    uzmanHekim: "Dr.Shahd",
  );
}
