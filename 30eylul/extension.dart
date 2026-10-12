extension oyunSayiUzantisi on int {
  String get toXpFormat {
    if (this < 1000) return "${this}XP";
    return "${(this / 1000).toStringAsFixed(1)}K XP";
  }
}

extension MetinSansurUzantisi on String {
  String get temizOyuncuAdi {
    if (this.toLowerCase().contains("hile")) {
      return "[YASAKLI_OYUNCU]";
    }
    return "$this";
  }
}

void main() {
  print("Extension metotları(tip genişletmeleri)");
  final int kazanilanXp1 = 450;
  final int kazanilanXp2 = 1280;
  print("Görev 1 Ödülü : ${kazanilanXp1.toXpFormat}");
  print("boss savaşı : ${kazanilanXp2.toXpFormat}");
  final String oyuncu1 = "EjderKatili";
  final String oyuncu2 = "HileciAlaaddin";
  print("Kayıt 1 ${oyuncu1.temizOyuncuAdi}");
  print("Kayıt 2 ${oyuncu2.temizOyuncuAdi}");
}
//yuzmeyetisi mixin icine dalis metodu ve sualtina daldı
//denizci sınıfı mixin ekle
