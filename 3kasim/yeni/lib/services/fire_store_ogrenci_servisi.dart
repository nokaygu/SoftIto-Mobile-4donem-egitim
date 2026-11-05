import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeni/models/ogrenci_model.dart';
//fire store dabtabase koleksiyon mantığıyla çalışır 
class FireStoreOgrenciServisi {
  final CollectionReference _ogrencilerKoleksiyonu = FirebaseFirestore.instance
      .collection('ogrenciler');
  Future<void> ogrenciEkle({
    required String adSoyad,
    required String projeAdi,
    required int notu,
  }) async {
//koleksiyona try catch içinde ekleme yapıyoruz timestamp olarak servertimestamp kullanarak databsrdeki kayıt tarihini alıyoruz
    try {
      await _ogrencilerKoleksiyonu.add({
        'adSoyad': adSoyad,
        'projeAdi': projeAdi,
        'notu': notu,
        'kayıtTarihi': FieldValue.serverTimestamp(),
      });
      print('Öğrenci başarıyla kaydedildi');
    } catch (e) {
      print('Ogrenci ekleme başarısız: $e');
      rethrow;
    }
  }

  Future<void> ogrenciIdIleKaydet({
    required String tcNo,
    required String adSoyad,
    required String projeAdi,
  }) async {
//istersek tcnoyu id olarak kullanabiliriz
//set put gibidir yoksa ekler varsa günceller
//merge true demezsek eski varolan veriler komple silinir
    await _ogrencilerKoleksiyonu.doc(tcNo).set({
      'adSoyad': adSoyad,
      'projeAdi': projeAdi,
      'guncellemeTarihi': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
//snapshot ile koleksşyonsan nota azalan şekilde sııralama yaptık mao için fromfiresyore ile kendi modellerimziin listesine çevirdik
  Future<List<OgrenciModel>> tumOgrencileriGetir() async {
    try {
      final QuerySnapshot snapshot = await _ogrencilerKoleksiyonu
          .orderBy('notu', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => OgrenciModel.fromFireStore(doc))
          .toList();
    } catch (e) {
      print("Veri çekme hatası:$e");
      return [];
    }
  }
//koleksiyon içinde update ile not günceleme yapıyoruz

  Future<void> ogrenciNotuGuncelle(String documentId, int yeniNot) async {
    await _ogrencilerKoleksiyonu.doc(documentId).update({
      'notu': yeniNot,
      'sonDuzenleme': FieldValue.serverTimestamp(),
    });
  }

  Future<void> ogrenciSil(String documentId) async {
    await _ogrencilerKoleksiyonu.doc(documentId).delete();
    print('$documentId referanslı veri tamamen silindi');
  }
}
