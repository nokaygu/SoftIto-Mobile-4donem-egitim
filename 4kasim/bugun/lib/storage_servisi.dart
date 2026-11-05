import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
//dosya yüklemek için firebase storage servisi
class StorageServisi {
  final FirebaseStorage _storage = FirebaseStorage.instance;
//yüklemr başlat

  UploadTask yuklemeBaslat({
    required File dosya,
    required String hedefDizin,
    required String dosyaAdi,
  }) {
//referans
    final Reference ref = _storage.ref().child('$hedefDizin/$dosyaAdi');
//meta veri ana veri deeğildir bilgi verir
    final metaData = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'yukleyen': 'Faik fahri fuat furkan fahrettin tek kişilik dev kadro',
      },
    );
//taska direkt return etmedim
    final UploadTask task = ref.putFile(dosya, metaData);

   //taska dinleme ekliyorum ilerleme oldukça gelişecek task.snapshotEvents.listen((TaskSnapshot snapshot) {
      final double yuzde = snapshot.bytesTransferred / snapshot.totalBytes;

      print('Yükleniyor: ${(yuzde * 100).toStringAsFixed(1)}%');

      if (snapshot.state == TaskState.success) {
        print('Yükleme tamamlandı!');
      }
    });

    return task;
  }
}
