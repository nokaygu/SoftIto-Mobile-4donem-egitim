import 'tekrar.dart';

void main() {
  final servis = GarantiBankasiServisi(apiAnahtari: "apiAnahtari");
  servis.odemeYap(miktar: 500);
  odemeSonucunuEkranaBas(OdemeBasarili((referansKodu: "veri", tutar: 222)));
}
