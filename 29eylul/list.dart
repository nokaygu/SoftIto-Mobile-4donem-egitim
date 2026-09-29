void main() {
  final List<String> aktifMikroservisler = [
    "auth-service:v2.1",
    "gateway-service:v1.9",
    "payment-processor:v3.0",
  ];
  aktifMikroservisler.add("telemetry-collector:v1.0");
  print(
    "Aktif servisler: (${aktifMikroservisler.length} adet):$aktifMikroservisler",
  );
  //sabit uzunluktaki liste(fixed-length)
  final List<String> cekirdekYukDengeleyiciler = List.filled(
    4,
    "Port-Kapalı",
    growable: false,
  );
  cekirdekYukDengeleyiciler[0] = "LB-NOD-E01;192.168.1.10";
  cekirdekYukDengeleyiciler[1] = "LB-NOD-E02;192.168.1.11";
  cekirdekYukDengeleyiciler[2] = "LB-NOD-E05";
  // cekirdekYukDengeleyiciler.add("lb-node-5");
  //hata fixed legnth listeye eleman ekleneemez
  print("Çekirdek YÜk dengeleyeci portlar:$cekirdekYukDengeleyiciler");

  //programatik list üretici
  final List<String> kubernetesPodlari = List.generate(
    3,
    (index) => "pod-node-eu-west-${index + 1} [ram:16gb , cpu: 4 cores]",
  );
  print("oluşturulan k8s podları : $kubernetesPodlari");
  //değiştirilemez list
  final List<String> guvenlikDuvariPortlari = List.unmodifiable([
    "22/TCP (SSH)",
    "443/TCP (HTTPS)",
    "644/TCP (k8s-API)",
  ]);
  //guvenlikDuvariPortlari[0] = "80"; //hata cannod modify and unmodifiable list
  print("güvenlik duvarı korumalı portlar:$guvenlikDuvariPortlari");
}
