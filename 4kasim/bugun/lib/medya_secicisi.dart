import 'dart:io';

import 'package:image_picker/image_picker.dart';
//resim seçici servisi
class MedyaSeciciServisi {
  final ImagePicker _picker = ImagePicker();
//pic imagw ile galeriden resim seç
  Future<File?> galeridenSec() async {
    final XFile? secilen = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
//seçmezse çık
    if (secilen == null) return null;
    return File(secilen.path);
  }
//kameradan çek
  Future<File?> kameradanCek() async {
    final XFile? cekilen = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (cekilen == null) return null;
    return File(cekilen.path);
  }
}
