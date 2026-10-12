//soyutlama abstraction kavramı
/*
//1.adım sözleşmeler contract
abstract class AutReposity {
  Future<String> login(String email, String password);
  Future<void> logout();
  bool get isAuth;
}

//canlı uygulamna
class FirebaseAuthReposity implements AutReposity {
  @override
  Future<String> login(String email, String password) async {
    //gerçek Firebase SDK Çaprısı
    return "firebase_token_xyz_123";
  }

  @override
  Future<void> logout() async {
    //firebase logout
  }

  @override
  bool get isAuth => true;
}

// test ve offline simülasyon
class MockAuthReposity implements AutReposity {
  @override
  Future<String> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    return "mock_token_abc_789";
  }

  @override
  Future<void> logout() async {}

  @override
  bool get isAuth => false;
}

mixin Logger {
  void log(String msg) => print("LOG: $msg");
}

mixin Analytics {
  void log(String msg) => print("ANALİZ: $msg");
}

class PaymentService with Logger, Analytics {
  void pay() {
    log("ödeme yapıldı");
  }
}

//sadece baseWidget ve alt sınıflarda kulanılabilir.
abstract class BaseWidget {}

mixin LifeLogger on BaseWidget {
  void logInit() => print("Widget başlatıldı.");
}


extension StringValidator on String {
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegex.hasMatch(this);
  }

  String toCapitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

//kullanımı
void main() {
  String email = "selahaddin@gmail.com";
  if (email.isValidEmail) {
    print("geçerli email");
  } else {
    print("geçersiz email");
  }
}

abstract class Identifiable {
  String get id;
}

//T tipi mutalaka Identifiable aaryüzünü uygulamak zorundadır
class GenericCache<T extends Identifiable> {
  final Map<String, T> _storage = {};

  void save(T item) {
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındı");
  }

  T? getById(String id) => _storage[id];
}
*/
import 'dart:async';

void main() {
  print("1.Senkron başladı");
  scheduleMicrotask(() {
    print("2.Task Oluştu(Vip Kuyruk)");
  });
  Future(() {
    print("3.Standart Event Kuyruğu");
  });
  Future.microtask(() {
    print("4.Future.microtast çalıştı");
  });

  print("5.Senkron kod tamamlandı");
}
