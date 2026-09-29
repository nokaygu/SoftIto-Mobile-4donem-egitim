void main() {
  final bulutServisleri = {"Servis1", "Servis2", "Servis3"};
  bool isProduction = true;
  final List<String> aktifBulutServisleri = [
    if (isProduction) "vault-secret-manager",
    ...bulutServisleri,
  ];
  print(aktifBulutServisleri);
}
