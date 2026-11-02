import 'package:flutter/material.dart';
import 'package:yenimagaza/models/urun_model.dart';

class MyCard extends StatelessWidget {
  final UrunModel urun;
  const MyCard({super.key, required UrunModel urun});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Text(urun.id.toString()),
          Text(urun.baslik),
          Text(urun.kategori),
        ],
      ),
    );
  }
}
