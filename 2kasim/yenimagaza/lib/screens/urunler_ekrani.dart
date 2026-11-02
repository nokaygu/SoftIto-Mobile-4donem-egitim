import 'package:flutter/material.dart';
import 'package:yenimagaza/models/urun_model.dart';
import 'package:yenimagaza/services/repositary.dart';
import 'package:yenimagaza/widgets/my_card.dart';

class UrunlerEkrani extends StatefulWidget {
  final String title;
  const UrunlerEkrani({super.key, required this.title});

  @override
  State<UrunlerEkrani> createState() => _UrunlerEkraniState();
}

class _UrunlerEkraniState extends State<UrunlerEkrani> {
  ValueNotifier<List<UrunModel>> urunler = ValueNotifier([]);
  final ValueNotifier<bool> yukleniyor = ValueNotifier<bool>(true);

  Future<void> _urunleriGetir() async {
    try {
      // Eğer urunleriGetir bir fonksiyonsa () ekleyin, getter ise () kaldırın
      final liste = await Repositary.canliApi.urunleriGetir();
      urunler.value = liste;
    } catch (e) {
      debugPrint("Veri çekme hatası: $e");
    } finally {
      yukleniyor.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _urunleriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ValueListenableBuilder<bool>(
        valueListenable: yukleniyor,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<List<UrunModel>>(
            valueListenable: urunler,
            builder: (context, urunListesi, _) {
              if (urunListesi.isEmpty) {
                return const Center(child: Text('Ürün bulunamadı.'));
              }

              return ListView.builder(
                itemCount: urunListesi.length,
                itemBuilder: (context, index) {
                  return MyCard(urun: urunListesi[index]);
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    urunler.dispose();
    yukleniyor.dispose();
    super.dispose();
  }
}
