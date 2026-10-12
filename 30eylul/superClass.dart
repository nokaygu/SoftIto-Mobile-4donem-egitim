class TemelSavasci {
  final String ad;
  final double temelGuc;
  TemelSavasci({required this.ad, required this.temelGuc});
  void saldir() {
    print("[$ad] Temel fiziksel yumruk attı. Hasar: $temelGuc");
  }
}

class Buyucu extends TemelSavasci {
  int manaPuani;
  Buyucu({required this.manaPuani, required super.ad, required super.temelGuc});

  @override
  void saldir() {
    if (manaPuani >= 10) {
      manaPuani - 10;
      print(
        "[$ad] Alev Topu Fırlattı: Hasar: ${temelGuc * 2} Kalan mana:$manaPuani",
      );
    } else {
      print("Mana tükendi.");
      super.saldir();
    }
  }
}

class Okcu extends TemelSavasci {
  int oksayisi;
  Okcu({required this.oksayisi, required super.ad, required super.temelGuc});
  @override
  void saldir() {
    if (oksayisi > 0) {
      oksayisi--;
      print(
        "[$ad] hedefe zehirli ok fırlattı: hasar : ${temelGuc * 1.5} Kalan ok sayısı: $oksayisi",
      );
    } else {
      print("ok bitti");
      super.saldir();
    }
  }
}

void main() {
  print("savaş arenası");
  final asker = TemelSavasci(ad: "Ayberk", temelGuc: 20.0);
  //yumruk atar
  asker.saldir();
  print("---------------");
  final merlin = Buyucu(manaPuani: 20, ad: "Sümeyye Arab", temelGuc: 40.0);
  merlin.saldir();
  print("--------------");
  final legolas = Okcu(oksayisi: 5, ad: "Zelal", temelGuc: 35);
  legolas.saldir();
}
