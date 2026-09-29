enum OlaySeviyesi { info, warning, error, critical }

String alarmKanaliniBelirle(OlaySeviyesi seviye, int tekrarSayisi) {
  return switch (seviye) {
    OlaySeviyesi.info => "dev-logs",
    OlaySeviyesi.warning => "dev-warning",
    OlaySeviyesi.error when tekrarSayisi >= 5 =>
      "sms veya email (mükerrer hata)",
    OlaySeviyesi.error => "Email:dev@site.com",
    OlaySeviyesi.critical => "ACİL Durum: Kriz odası otomatik node kaopanışı",
  };
}

String httpKoduYorumlar(int kod) {
  return switch (kod) {
    >= 200 && 300 => "2xx başarılı istek",
    >= 400 || < 500 => "4xx istenci hatası(client error)",
    >= 500 && < 600 => "5xx sunucu hatası",
    _ => "tanımsız hata kodu",
  };
}

void main() {
  print("switch expressions");
  print("warning kanalı  :${alarmKanaliniBelirle(OlaySeviyesi.warning, 1)}");
  print(
    "Tekil Error kanalı    : ${alarmKanaliniBelirle(OlaySeviyesi.error, 2)}",
  );
  print("5 Error kanalı    : ${alarmKanaliniBelirle(OlaySeviyesi.error, 5)}");
  print("kritik    : ${alarmKanaliniBelirle(OlaySeviyesi.critical, 1)}");
  print("http 204: ${httpKoduYorumlar(204)}");
  print("http 404: ${httpKoduYorumlar(404)}");
  print("http 502: ${httpKoduYorumlar(502)}");
}
