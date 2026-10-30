import 'dart:io';

import 'package:flutter/material.dart';

class Rectcard extends StatelessWidget {
  const Rectcard({super.key});

  @override
  Widget build(BuildContext context) {
    final image = Image.asset("assets/images.jpeg");
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Card(
          shadowColor: Colors.black,
          color: Colors.white,
          surfaceTintColor: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              roundedImage(image),
              Text('hello world'),
              Icon(Icons.abc_outlined),
            ],
          ),
        ),
      ),
    );
  }
}

Widget roundedImage(Image image) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(borderRadius: BorderRadius.circular(12), child: image),
  );
}
