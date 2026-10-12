mixin YuzmeYetisi {
  int dalmaIrtifasiMetre = 100;
  void dalis() {
    print(
      "Yuzme yetisi: kollarını açtı ve $dalmaIrtifasiMetre metre sualtına daldı.",
    );
  }
}

class Denizci with YuzmeYetisi {
  final String isim;
  Denizci({required this.isim});
}

void main() {
  final denizci1 = Denizci(isim: "mehmet");
  denizci1.dalis();
}
