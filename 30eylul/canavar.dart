abstract class Canavar {
  final String isim;
  final int seviye;
  Canavar({required this.isim, required this.seviye});
  void kukre();
}

class Kurt extends Canavar {
  Kurt({required super.isim, required super.seviye});
  @override
  void kukre() => print("Atıl kurt ,$isim kurt kükredi");
}

class Ejderha extends Canavar {
  Ejderha({required super.isim, required super.seviye});
  @override
  void kukre() => print("dracarys ejderha kükrüyor");
}

void main() {
  final griKurt = Kurt(isim: "gri kurt", seviye: 1);
  final maviEjder = Ejderha(isim: "mavi ejderha", seviye: 10);
  griKurt.kukre();
  maviEjder.kukre();
}
