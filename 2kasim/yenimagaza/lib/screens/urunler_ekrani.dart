import 'package:flutter/material.dart';
import 'package:yenimagaza/models/urun_model.dart';
import 'package:yenimagaza/services/repositary.dart';
import 'package:yenimagaza/widgets/my_card.dart';

// 1. Ekran durumunu tek bir yapıda birleştirin
class UrunlerState {
  final List<UrunModel> urunler;
  final bool yukleniyor;
  final String? hataMesaji;

  const UrunlerState({
    this.urunler = const [],
    this.yukleniyor = false,
    this.hataMesaji,
  });
}

class UrunlerEkrani extends StatefulWidget {
  final String title;
  const UrunlerEkrani({super.key, required this.title});

  @override
  State<UrunlerEkrani> createState() => _UrunlerEkraniState();
}

class _UrunlerEkraniState extends State<UrunlerEkrani> {
  final ValueNotifier<UrunlerState> _state = ValueNotifier(
    const UrunlerState(yukleniyor: true),
  );

  Future<void> _urunleriGetir({bool sessizYenile = false}) async {
    // Sessiz yenilemede mevcut listeyi koruyarak ağacın yıkılmasını önlüyoruz
    if (!sessizYenile) {
      _state.value = UrunlerState(
        urunler: _state.value.urunler,
        yukleniyor: true,
      );
    }

    try {
      final liste = await Repositary.canliApi.urunleriGetir();
      _state.value = UrunlerState(urunler: liste, yukleniyor: false);
    } catch (e) {
      debugPrint("Veri çekme hatası: $e");
      _state.value = UrunlerState(
        urunler: _state.value.urunler,
        yukleniyor: false,
        hataMesaji: 'Ürünler yüklenirken bir hata oluştu.',
      );
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
      body: ValueListenableBuilder<UrunlerState>(
        valueListenable: _state,
        builder: (context, state, _) {
          // Sadece ilk yüklemede (liste henüz boşken) tam ekran yükleniyor göster
          if (state.yukleniyor && state.urunler.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Hata varsa ve elde hiç veri yoksa hata ekranı ve tekrar dene butonu göster
          if (state.hataMesaji != null && state.urunler.isEmpty) {
            return Center(
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.hataMesaji!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _urunleriGetir,
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.urunler.isEmpty) {
            return const Center(child: Text('Ürün bulunamadı.'));
          }

          // Liste bir kez oluştuktan sonra yenilemeler ListView ağacını yıkmaz
          return RefreshIndicator(
            onRefresh: () => _urunleriGetir(sessizYenile: true),
            child: ListView.builder(
              itemCount: state.urunler.length,
              itemBuilder: (context, index) {
                final urun = state.urunler[index];
                return MyCard(
                  // Elemanların yeniden kullanımını (Element reuse) optimize eder
                  key: ObjectKey(urun),
                  urun: urun,
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }
}
