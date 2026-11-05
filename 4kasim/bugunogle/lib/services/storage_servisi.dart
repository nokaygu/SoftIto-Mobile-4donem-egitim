import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageServisi {
//resimler gibi dosyalar için firestorage
  final FirebaseStorage _storage = FirebaseStorage.instance;
//dışarıdan resim almak için imagepicker
  final ImagePicker _picker = ImagePicker();
//async olarak resimsec
  Future<File?> gorselSec({bool kameradan = false}) async {
    final XFile? xFile = await _picker.pickImage(
      source: kameradan ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (xFile == null) return null;
    return File(xFile.path);
  }
//resim yükleme
  UploadTask yuklemeBaslat({
    required File dosya,
    required String dosyaAdi,
    String klasor = 'yuklemeler',
  }) {
//pathe referans noktası
    final Reference ref = _storage.ref().child('$klasor/$dosyaAdi');
    final metaData = SettableMetadata(
//dosya tipi resim png
      contentType: 'image/png',
      customMetadata: {'ekleyen': 'Berat Atmaca'},
    );
    return ref.putFile(dosya, metaData);
  }
//indirme urlsini getir
  Future<String> urlGetir(Reference ref) async {
    return await ref.getDownloadURL();
  }
//dosya silmek için pathiyle sil

  Future<void> dosyaSil(String dosyaYolu) async {
    final Reference ref = _storage.ref().child(dosyaYolu);
    await ref.delete();
  }
}
