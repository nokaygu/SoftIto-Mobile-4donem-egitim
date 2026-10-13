/*Future<void> fetchDashboardData() async {
  try {
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);
    print("Tüm veriler geldi: $result");
  } catch (e) {
    print("İsteklerden biri başarısız oldu: $e");
  }
}
*/

//Future: tek bir krere veri çekileceği zaman kullanılır ya hata ya da değer dönüp bititr
//Stream: Bir boru hattı şeklinde çalışır (pipre), zaman içinde 1 10 1000 ya da sonsuz
//veri akışı (borsa fiyatalrı gps konum güncelleem,firebase tarafında canlı dinleme)
import 'dart:async';

void main() {
  //controller oluşturma
  final controller = StreamController<int>();
  //dinleyici listener bağlama
  final subscription = controller.stream.listen(
    (data) => print("yeni veri: $data"),
    onError: (error) => print("Hata oluştu: $error"),
    onDone: () => print("Yayın tamamlandı"),
  );
  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);
∏
  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("Uı ekranı: $d"));
  broadcastStream.listen((d) => print("Analitik servisi Ekranı: $d"));

  controller.close();
}
/*
code --install-extension Dart-Code.dart-code \
     --install-extension Dart-Code.flutter \
     --install-extension usernamehw.error-lens \
     --install-extension Nash.awesome-flutter-snippets \
     --install-extension PKief.material-icon-theme \
     --install-extension eamodio.gitlens \
     --install-extension pflannery.vscode-version-lens \
     --install-extension FelixAngelov.bloc \
     --install-extension naumovs.color-highlight \
     --install-extension streetsidesoftware.code-spell-checker
     */