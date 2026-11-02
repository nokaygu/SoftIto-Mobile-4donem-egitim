import 'package:demo/controller/sepet_kontrolu.dart';
import 'package:flutter/material.dart';

class VitrinEkrani extends StatelessWidget {
  const VitrinEkrani({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canlı vitrin(valuenotifier)')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            SepetKontrolu.ornek.sepeteEkle();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete ürün ekle(+1)'),
        ),
      ),
    );
  }
}
