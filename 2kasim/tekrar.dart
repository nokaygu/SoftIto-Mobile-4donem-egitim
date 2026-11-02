//mülakat için önemli : Sealed sınıflar dışardan extend edilmez. switch içinde tüm alt sınıflar tüketilmek zorundadır.
sealed class OdemeDurumu {}

class OdemeBasarili extends OdemeDurumu {
  final ({String referansKodu, double tutar}) veri;
  OdemeBasarili(this.veri);
}

class OdemeBasarisiz extends OdemeDurumu {
  final String hataNedeni;
  OdemeBasarisiz(this.hataNedeni);
}

abstract class IBankaServisi {
  Future<OdemeDurumu> odemeYap({required double miktar});
}

mixin GuvenlikDenetimiMixin {
  bool tokenGecerliMi(String token) {
    return token.isNotEmpty && token.length >= 2;
  }
}

mixin AuditLogMixin {
  void islemKaydet(String mesaj) {
    final zaman = DateTime.now().toIso8601String();
    print('Log - $zaman : $mesaj');
  }
}

class GarantiBankasiServisi
    with GuvenlikDenetimiMixin, AuditLogMixin
    implements IBankaServisi {
  final String apiAnahtari;
  GarantiBankasiServisi({required this.apiAnahtari});
  @override
  Future<OdemeDurumu> odemeYap({required double miktar}) async {
    if (!tokenGecerliMi(apiAnahtari)) {
      islemKaydet('Ödeme Reddedildi. Geçersiz Api anahtarı');
      return OdemeBasarisiz('Yetkilendirme hatası:geçersiz token');
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    islemKaydet('$miktar tutarındaki ödeme Garanti tarafından ONAYLANDI');
    return OdemeBasarili((
      referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}',
      tutar: miktar,
    ));
  }
}

void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  final mesaj = switch (durum) {
    OdemeBasarili b =>
      'Odeme basarılı.Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar}₺',
    OdemeBasarisiz h => 'Odeme Başarısız. Gerekçe: ${h.hataNedeni}',
  };
  print(mesaj);
}
