import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServisi {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask yuklemeBaslat({
    required File dosya,
    required String hedefDizin,
    required String dosyaAdi,
  }) {
    final Reference ref = _storage.ref().child('$hedefDizin/$dosyaAdi');

    final metaData = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'yukleyen': 'Faik fahri fuat furkan fahrettin tek kişilik dev kadro',
      },
    );

    final UploadTask task = ref.putFile(dosya, metaData);

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      final double yuzde = snapshot.bytesTransferred / snapshot.totalBytes;

      print('Yükleniyor: ${(yuzde * 100).toStringAsFixed(1)}%');

      if (snapshot.state == TaskState.success) {
        print('Yükleme tamamlandı!');
      }
    });

    return task;
  }
}
