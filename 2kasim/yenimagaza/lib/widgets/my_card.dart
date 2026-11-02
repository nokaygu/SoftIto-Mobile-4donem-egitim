import 'package:flutter/material.dart';
import 'package:yenimagaza/models/urun_model.dart';

class MyCard extends StatelessWidget {
  final UrunModel urun;
  const MyCard({super.key, required this.urun});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 70, height: 70, child: Image.network(urun.resimUrl)),
          SizedBox(width: 30, height: 30),
          Column(
            children: [
              Text(urun.id.toString()),
              Text(urun.baslik),
              Text(urun.kategori),
            ],
          ),
        ],
      ),
    );
  }
}
