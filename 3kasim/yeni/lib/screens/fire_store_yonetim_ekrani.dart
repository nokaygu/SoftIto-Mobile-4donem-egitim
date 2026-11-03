import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yeni/models/ogrenci_model.dart';
import 'package:yeni/services/fire_store_ogrenci_servisi.dart';
import 'package:yeni/widgets/ogrenci_ekleme_formu.dart';
import 'package:yeni/widgets/ogrenci_karti.dart';

class FireStoreYonetimEkrani extends StatefulWidget {
  const FireStoreYonetimEkrani({super.key});

  @override
  State<FireStoreYonetimEkrani> createState() => _FireStoreYonetimEkraniState();
}

class _FireStoreYonetimEkraniState extends State<FireStoreYonetimEkrani> {
  final FireStoreOgrenciServisi _servis = FireStoreOgrenciServisi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("canlı firestore ekranı"),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Column(
        children: [
          // 1. Parça: Ayrı Widget olan Form
          OgrenciEklemeFormu(servis: _servis),

          const Divider(thickness: 2),

          // 2. Parça: Canlı Liste
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ogrenciler')
                  .orderBy('notu', descending: true)
                  .snapshots(),
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Bulut hatası: ${snapshot.error}"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("Henüz bulutta kayıtlı öğrenci yoktur."),
                      );
                    }

                    final List<DocumentSnapshot> dokumanlar =
                        snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: dokumanlar.length,
                      itemBuilder: (context, index) {
                        final doc = dokumanlar[index];
                        final ogrenci = OgrenciModel.fromFireStore(doc);

                        return OgrenciKarti(
                          ogrenci: ogrenci,
                          onSil: () {
                            _servis.ogrenciSil(ogrenci.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${ogrenci.adSoyad} buluttan silindi',
                                ),
                              ),
                            );
                          },
                          onDuzenle: () => _notGuncelleDialog(ogrenci),
                        );
                      },
                    );
                  },
            ),
          ),
        ],
      ),
    );
  }

  void _notGuncelleDialog(OgrenciModel ogrenci) {
    final TextEditingController yeniNotKontrolcusu = TextEditingController(
      text: ogrenci.notu.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${ogrenci.adSoyad} - Not Güncelle"),
          content: TextField(
            controller: yeniNotKontrolcusu,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Yeni Not (0-100)",
              prefixIcon: Icon(Icons.grade),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                final yeniNot = int.tryParse(yeniNotKontrolcusu.text.trim());
                if (yeniNot != null && yeniNot >= 0 && yeniNot <= 100) {
                  _servis.ogrenciNotuGuncelle(ogrenci.id, yeniNot);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${ogrenci.adSoyad} notu güncellendi'),
                    ),
                  );
                }
              },
              child: const Text("Güncelle"),
            ),
          ],
        );
      },
    );
  }
}

//yapılcaklar
//1 expnded içinde projeadı inputu açılacak
//2 _notGuncelleDialog fonksiyonu yazılacak
//3 sayfalar parse edilecek ve sistem çalışır hale geiterlecek
