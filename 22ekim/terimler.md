Const

1. ne işe yarar: İçine girilen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2. Neden kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widet'ı yeniden üretmez Cpu ve pil tasarrufu sağlar.

final

1. ne işe yarar: çalışma zamanında değeri bir kez ataanan ve sonrasında referansı asla değiştirilmeyen değişkenler
   \*\* const ve final farkı: const derlenirken bilinmek zorunda (const pi=3.14) final ise çalışma anında belirlenebilir . final saat=DateTime.now(); Model sınıflarında alanlar her zaman final olmalıdır.

late

1. ne işe yarar: değişen tanımlandığı anda değil, ilk kullanıldığında veya initState anında başlaycağı zaman kullanılır.

required
1)ne işe yarar: isimlendirilmiş parametrelerde o parametrenin(değişkenin) zorunlu olduğunu belirtir.

@override
1)ne işe yarar: alt sınıfın , üst sınıftan devraldığı metodu ezdiğini belirtir.
2)faydası: eğer üst metod adını yanlış yazarsanız (örek builds yazarsanız) derleyici @override sayesinde bunu anında hata oalrak yakalar.

Null-aware operatörleri (? ?? !)
?. - place?.title -> eğer place null ise hata veremk direkt null olarak döner
?? - if null : final id = state.userID ?? 10; ->sol taraf null ise sağdaki (hardcode olan değer )otomatik olarak atanı
! (null /force): final id= state.userId ! -> Bu kod derleyiciye bana güven bu değer o anda kesinkikle nul değil verir. eğer null gelir ise uygulama nında çöker. (çok dikkatlı kullanulmalı)

Spread operatörü (...)

1. ne işe yarar: bir listenin elemanlarını tek tek çıkartııp bulundupu üst listenin içine ekler . column ve ListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
   ...listeAdi.map((p)=>\_buildCard(p))

initState()
Ne zaman çalışır : Widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır
Ne yapar: ScrollController başlatmaları ve ilk api istekleri burda kurulur.
Kural: içinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır.

didChangeDependencies()
Ne zaman çalışır: initState()'ten hemen sonra ve widget dinlendiği bir (örnek : Theme.of(context)) değiştiğinde otomatik tetikler.
Ne yapar : BuildContext güvenli bir şekilde erişerek tema ve ya ekran boyutu bağımlılıkları ile ilgili ilk yüklemeler burada yapılır.
