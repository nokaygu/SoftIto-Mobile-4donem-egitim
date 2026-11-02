import 'package:flutter/material.dart';
import 'package:yenimagaza/models/urun_model.dart';
import 'package:yenimagaza/widgets/my_card.dart';

class UrunlerEkrani extends StatefulWidget {
  final String title;
  const UrunlerEkrani({super.key, required this.title});

  @override
  State<UrunlerEkrani> createState() => _UrunlerEkraniState();
}

class _UrunlerEkraniState extends State<UrunlerEkrani> {
  ValueNotifier<List<UrunModel>> urunler = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView.builder(
          itemCount: urunler.value.length,
          itemBuilder: (context, index) {
            return MyCard(urun: urun);
          },
        ),
      ),
    );
  }
}
