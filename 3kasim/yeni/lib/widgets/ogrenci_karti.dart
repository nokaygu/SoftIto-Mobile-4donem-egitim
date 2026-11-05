import 'package:flutter/material.dart';
import 'package:yeni/models/ogrenci_model.dart';

class OgrenciKarti extends StatelessWidget {
  final OgrenciModel ogrenci;
  final VoidCallback onSil;
  final VoidCallback onDuzenle;

  const OgrenciKarti({
    super.key,
    required this.ogrenci,
    required this.onSil,
    required this.onDuzenle,
  });
//dismissible silenebilir öge
//baştan sona kaydırılımca silinsin
//sağdece sağ içeriden boşluk
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(ogrenci.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
//sağa çejilince onsill CALLBACK
      onDismissed: (direction) => onSil(),
//çember avatar not 80dwn büyüksw yeşil değilse -> 50den büyükse turuncu değilse kırmızı
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ogrenci.notu >= 80
              ? Colors.green
              : (ogrenci.notu >= 50 ? Colors.orange : Colors.red),
          child: Text(
            '${ogrenci.notu}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
//kalın font trailing ucuna button iconlar 
        title: Text(
          ogrenci.adSoyad,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Proje: ${ogrenci.projeAdi}'),
        trailing: IconButton(
          onPressed: onDuzenle,
          icon: const Icon(Icons.edit, color: Colors.amberAccent),
        ),
      ),
    );
  }
}
