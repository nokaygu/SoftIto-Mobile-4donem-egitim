void main() {
  print("map metrikleri");

  final Map<String, Map<String, dynamic>> mikroservisRehberi = {
    "aut-api": {
      "port": 8801,
      "saglik": "Healthy",
      "restartSayisi": 0,
      "bellekKullanimiMB": 384.5,
      "otonomOlcekleme": true,
    },
    "payment-gateway": {
      "port": 8802,
      "saglik": "Degraded",
      "restartSayisi": 4,
      "bellekKullanimiMB": 1280.0,
      "otonomOlcekleme": false,
    },
  };
  //yeni servis ekleme (putifabsent ile çakışmasız ekleme)
  mikroservisRehberi.putIfAbsent(
    "reporting-worker",
    () => {
      "port": 9091,
      "saglik": "Healthy",
      "restartSayisi": 0,
      "bellekKullanimiMB": 512.0,
      "otonomOlcekleme": true,
    },
  );
  if (mikroservisRehberi.containsKey("payment-gateway")) {
    mikroservisRehberi["payment-gateway"]!["restartSayisi"] =
        (mikroservisRehberi["payment-gateway"]!["restartSayisi"] as int) + 1;
  }
  print("güncel servis durum raporu");
  print("--------------------");
  for (var entry in mikroservisRehberi.entries) {
    final String servis = entry.key;
    final Map<String, dynamic> ozet = entry.value;
    final String saglik = ozet["saglik"];
    final String durumRozet = saglik == "Healthy" ? "OK" : "Alert";
    print(
      "$durumRozet ${servis.padRight(18)} | port: ${ozet["port"]} | Ram: ${ozet['bellekKullanimiMB']}MB | Restart: ${ozet['restartSayisi']}",
    );
  }
}
