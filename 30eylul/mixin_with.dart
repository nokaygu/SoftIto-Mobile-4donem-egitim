mixin UcmaYetkisi {
  int ucusIrtifasiMetre = 100;
  void gogeYuksel() {
    print(
      "Uçuş yetkisi: kanatlarını açtı ve $ucusIrtifasiMetre metreye yükseldi",
    );
  }
}

mixin GorunmezlikYetisi {
  void pelerinOrt() {
    print("Görünmezlik: Düşmanların gözünden tamamen kayboldu!");
  }
}

mixin AtesGucuYetisi {
  void alevSaldirisi() {
    print("Ateş Gücü:Kılıcını alevlendirdi ve alanı yaktı");
  }
}

class TemelKarakter {
  final String ad;
  TemelKarakter({required this.ad});
}

class EfsaneviEjderBinicisi extends TemelKarakter
    with UcmaYetkisi, AtesGucuYetisi {
  final String ejderhaAdi;
  EfsaneviEjderBinicisi({required this.ejderhaAdi, required super.ad});
  void hucumEt() {
    print("$ad ve ejderhası $ejderhaAdi savaşa atılıyor");
    gogeYuksel();
    alevSaldirisi();
  }
}

class GolgeSuikastci extends TemelKarakter with GorunmezlikYetisi {
  GolgeSuikastci({required super.ad});
  void suikastYap() {
    print("$ad hedefe sessizce yaklaşıyor");
    pelerinOrt();
    print("kritik darbe vurdu");
  }
}

void main() {
  print("süper güçler başlatılıyor");
  final birinci = EfsaneviEjderBinicisi(ejderhaAdi: "Aslıhan", ad: "AdilMurat");
  birinci.hucumEt();
  final ikinci = GolgeSuikastci(ad: "AdilMurat");
  ikinci.suikastYap();
}
