##Sözleşmeler, SOLID prensipleri & OOP mimarisi
###1.1 'interface'(arayüz/sözleşme)
**sözlük anlamı:** iki bağımsız sistemin veya sınıfın birbiriyle nasıl konuşacağını belirleyen içi boş metod imzalarından oluşan kurallar bütünü.
**\*Neden kullanılır:** bir sınıfa göbekten bağımlı kalmamak örneğin gerçek şarj istasyonu cihazı olmadan sahte/mock şarj servisiyle testi çalıştıraiblmek için.

```dart
abstract interface class StationContract{
    Future<void> startCharging(String socketId);
    Stream <double> watchLivePower();
}
```

---

### 1.2. 'implements' vs `extends`vs `with`

###1.2.1 'implements' (arayüz sözleşmesi )
**_sözlük anlamı:_** bir sınıfın bir şablonun belirlediği kuralları kabul edip
**içini sıfırdan kendisinin doldurması** zorunludur.
**Neden kullanılır:**
farklı sınıflara ortak bir standart/sözleşme dayatmak, çoklu arayüğz desteği sağlamak ve koda bağımlılıkları azaltmak için.

### 1.2.2. `extends` (miras/kalıtım )

sözlük anlamı: bir sınıfın, başka bir sınıfın özelliklerini ve metodlarını doğrudan devralması.
**\*Neden kullanılır** kod tekrarını önlemek (DRY), mantıksal bir sınıf hiyerarşisi oluşturmak oluşturmak için.
####1.2.3 'with' (mixin/yetenek aşılama )
**\*Neden kullanılır:**sınıf hiyerraşisini bozmadan bağımsız bir sınıfa hazır kod blokları (metot değişken) enjekte etme mekanizmasıdır.
Akraba olmayan sınıflara ortak yetenekler kazandırmak, çoklu kalıtım kimliğini önlemek ve modülerliği arttırmak için.

###1.3 SOLID prensipleri (mobil & dart odaklı)

#### 1. S- Single responsibility principle

(tek sorumluluk prensibi)
**_kural:_** bir sınıfın veya dosyanın değişmesi için **yalnızca 1 sebebi** olmalıdır.

#### 2.0 Open / Closed principle (açık / kapalı prensibi)

**kural** yazılım varlıkları (sınıflar, modüller) **genişletilmeye açık** ancak **değiştirilmeye kapalı** olmalıdır.

### 3 L Liskov Substiton Principle

Liskovun yerine geçme prensiib
**_kural_** bir üst sınıfın yerine, onun alt sınıflarından herhangi biri geçirildiğinde sistemin davranışı bozulmamalı ve hata fırlatmamalı.

#### 4. I- Interface segregation Principle

(arayüz ayrıştırma prensibi)
**_kural:_** istemciler (sınıflar) , kullanmadıkları metodları içermeye zorlanmamalıdır.
şişman(fat) interfaceler yerine küçük amaca yönelik arayüzler kurulmalıdır.,

#### 5. D- Dependency Inversion Principle (bağımlılıkların tersine çevrilmesi)

## **_kural_** yüksek seviyeli modüller (UI, iş mantığı), düşük seviyeli modüllere (veritabanı,HTTP istemcisi) doğrudan bağımlı olmamalıdır. Her ikisi de soyutlamalara(ìnterface`) bağlı olmalıdır.

### 1.4. `Coupling` (Bağlaşıklık) & `Cohesion` (UYUM)

**_Tightly Coupled(Sıkı Bağlılık):_** sınıfların birbirinin her detayını bilmesi. birinde yapılan her değişiklik diğer 5 dosyayı bozuyorsa sistem sıkı bağımlıdır.
***loose coupled(Gevşek Bağlılık):***sınıfların birbirinin sadece ihtiyaç duyduğu kadarını bilmesi (Interface'ler aracılığıyla).
**_high Cohesion (Yüksek Uyum):_** bir sınıfın sadece ve sadece kendi uzmanlı alannı yapması
**_low cohesion (Düşük Uyum):_** bir sınıfın işi dışındaki işleri yapması,

---

## STREAM TEMELLERİ; CUBIT & ENTERPRISE BLOC

### 2.1 `Stream` Nedir? (Blocun kalbindeki motor)

**_sözlük anlamı:_** zaman içinde parça parça gelen, akıp giden asenkron veri dizisi.
**\* Bloc sırrı** BLOC kütüphanesi sihirli bir şey yapmaz! blocun içinde gizli bir `StreamController` vardır. Event'ler borunun bir ucundan girer(`sink.add`), BLoc onları işler ve diğer ucundna ekrana state akıtır.
(`stream.listen`),

---

### 2.3. Bloc'un 3 temel elemanı :`Event`, `State`,`Emitter`

**\*Event(olay)** kullanıcının veya sistemin Bloc'a attığı emir fişi.
_Mini Sözdizimi:_ `class StartChargingRequested extends ChargingEvent{final String socketId;}
***State(Durum)** ekranın o milisaniyedeki dondurulmuş footoğrafı (snapshot)
*Mini Sözdizimi* `class ChargingActiveState extends ChargingState{final double kwh}
**\*Emitter** BLoC'un ürettiği yeni state'i ekrana fırlatığı megafon borusu.
_kural:_ Senkron çalışır; `emite(NewState())` dendiği anda UI'daki builderlar tetiklenir.

Kullanıcı ekrandayken asenkron işlem başlar (await api.fetchSockets()). Kullanıcı cevap gelmeden geri tuşuna basıp sayfayı kapatır. BLoC/Cubit yok edildiği (closed) için hemen ardından gelen emit() satırı:

💥 StateError: Cannot emit new states after calling close

hatasını fırlatır ve uygulama çöker!

Çözüm: Asenkron await satırından sonraki her emit mutlaka şu şekilde korunmalıdır:
final data = await repository.getData();
if (!isClosed) {
emit(DataLoaded(data));
}

### 3.1 `Side Effect`(Yan etki) neden `BlocBuilder`içine yazılamaz

- `BlocBuildee`ı tek görvi widget döndürmektir.
  Flutter motoru ekrana saniyede 60 kez çizebilr -rebuild-. Eğer siz `BlocBuilder`içine `ScaffoldMessenger.showSnackBar`veya `Navigator.push`yazarsanız; kullanıcı cihazı yan çevirdiğinizde veya klavye açıldığında kullanıcıya üst üste 10 defa snackbar patlar veya 10 kez yeni sayfa açılır.
- **Kural:** yan etkişer sadce `BlocListener`içine yazılır; çünlkü `listener` sayfa rebuild olduğunda değil yalnızca state değiştiğğinde bir kez tetiklenir.

### 3.2 `BlocSelector`(Mikro performans & Pil tassırıfı)

- **Kavram:** State'in içindeki onlarca alandan sadece **1 tanesini süzüp izlemek**,

--

## 4.EŞİTLİK DEĞİŞMEZLİK &BLOCOBSERVER

### 4.1 `referential Equality`vs `value equality`

- **Dart varsayılanı (Referans eşitliği):** iki nesnenin bellekteki (RAM ) adresi aynı mı?
  `Soket('A')`== Soket('A') -> **false** içerikleri aynı olsa da ramdeki evleri farklıdır.

- **Değer eşitliği value equality**
  nesnelerin içindeki veriler aynı mı?
  'Equatable' paketi tam olark bunu çözer: nesneleri ram adresine göre değil `props`listesindeki alanların değerine göre karşılaştıırr.

### 4.2 `props`listsi yazılmazsa ne olur ?

- Bloc ekran kartını yormamak için şu denetimi yapar: `ìf (yeniState==eskiState) ekranıCizme()`
- EĞer siz `StationLoaded`stetine yeni bir `filterType`alanı eklerseniz ama `props`içine yazmayı unutusanız Bloc iki state eşit zanneder ekranı günncelemez arayüz donuk kalır.

### 4.3 `Immmutability` (değişmezlik) & `copyWith`

- **Kural** Sate sınıflarının tüm alnları `final` olmalıdır değişmez.
- **`copyWith` Mantığı:** Eski nesnenin 5 alanını koruyup, sadece değişen 1 alanını koruyup sadece değişen 1 allanını güncelleyerek taze bir nesne üretme yöntemidir.

```dart
final guncel =state.copyWith(isCharging:true); //diper alanlar bozulmadan kopyalanır
```

### 4.4 BlocObserver (Tüm Uygulamayı Röntgenleme)

- **Kavram:** uygulamadaki tüm BLoC ve Cubitlerin arkasında çalışan merkezi bir kara kutu / telemetri kaydedici.
- **Ne İşe Yarar?:** Hangi ekranda hangi Event fırlatılı, State nereden nereye geçti (onTransition) ve nerede hata fırlatıldı (onError) te merkezden konsola loglanır. Kurumsal projelerde analitik ve çökme takibi için zorunludur.

## 5.Clean Architecture katmanları & Sorumululuk duvarları

### 5.1 `Entity`vs `Model/DTO`

- **'Entity' (varlık):** Saf iş nesnesidir. Bir şarj soketinin gerçek hayattaki özelliklerini (`ìd`,`kw`,`durum`) tutar. `fromJson`veya `toJson`içermez.
- **`Model/DTO` (Data Transfer Object):**
  Apı'den gelen ham JSON verisini karşılayan taşayıcıdır. Èntity`den türer`fromJSon`ve`toJson` metotlarını barındırır.
- _"Neden entity içine `fromJson`yazmıyoruz_
  _Cevap yarın backend json yerine xml veya protobuf formatına geçerse; domain katmanındaki iş kurallarımız ve ui sayfalarımız zerre kadar etkilenmesn sadece data katmanıdaki model etkilensin diye_

### 5.2 `useCase`kullanım senaryosu

- **Kavram:** kullanıcınn veya sistemin gerçekleştirebilceği ** tek atomik bir iş kıuralı **
  Örnekler: StartChargingSessionUseCase, GetStationSocketsUseCase, RefundWalletBalanceUseCase.
  Kural: Her UseCase sınıfının içinde sadece tek bir call() veya execute() fonksiyonu bulunur

### 5.3 `Repository Contract`vs `Repository Implementation`

Contract (Domain Katmanında): Sadece sözleşmedir (abstract interface class StationRepository). Verinin nereden geleceğini bilmez.
Implementation (Data Katmanında): Sözleşmeyi uygulayan somut sınıftır (class StationRepositoryImpl implements StationRepository). Verinin önce yerel diskten mi yoksa internetten mi çekileceğine karar verir.

## 6.bağımlılık yönetimi : dependency injection & `get_it

### 6.1 Neden `new Dio()`yazmak yasaktır?

Eğer 5 ayrı sayfada final dio = Dio(); derseniz:

Bellekte 5 ayrı bağlantı havuzu açılır, telefonun soket sınırını zorlar.
Base URL veya Timeout değiştiğinde 5 ayrı dosyayı elle değiştirmek zorunda kalırsınız.
Test yazarken sahte (mock) veri enjekte edemezsiniz.

### 6.2 `GetIt`Kayıt Tipleri: Singleton vs LazySingleton vs Factory
Singleton: Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler.
LazySingleton: Uygulama açıldığında üretmez! Ne zaman ilk kez birisi sl<Dio>() derse o an üretir ve sonrasında hep aynı nesneyi verir. (Bellek ve açılış hızı dostudur).
Factory: Her çağrıldığında yepyeni, sıfır bir kopya üretir.

## 7. Kurumal AĞ MİMARİSİ: DIO, INTERCEPTOR & HTTP STATUS KODLARI

- **SÖZLÜK Anlamı:** Ağ isteği telefondan çıkıp internete gitmeden önce veya sunucudan cevap gelip koda düşmeden ömnce araya girip paketi inceleyen/değiştiren güvelik noktası.

### 7.2. Bearer Token & Payload

**Bearer Token:** "Bu anahtarı taşıyan kişi giriş yapmaya yetkilidir" anlamına gelen şifrelenmiş kimlik kartı metni (Authorization: Bearer eyJhbGci...).
**Payload:** Bir API isteğiyle sunucuya gönderilen veya sunucudan bize dönen asıl veri gövdesi (Body)

## 7.3 http duurm kodları sözlğpğ

**200 OK:** İstek başarılı, veri gövdede.
**201 Created:** Yeni kayıt (örneğin yeni şarj oturumu) başarıyla oluşturuldu.
**400 Bad Request:** İstemci hatası; eksik veya hatalı parametre gönderdin.
**401 Unauthorized:** Token yok veya süresi dolmuş; hemen Login'e yönlendir!
**403 Forbidden:** Giriş yaptın ama bu veriyi görmeye yetkin yok (Admin değilsin).
**404 Not Found:** Aradığın soket veya istasyon sunucuda bulunamadı.
**500 Internal Server Error:** Backend sunucusu patladı; istemcilik bir hata yok

### 8. veri dayanıklılığı cache first & savunmacı kodlama

8.1. Cache-First (Önce Önbellek) Stratejisi

- **Mantık:** Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner bekletme! Diskteki dünkü veriyi 0.01 milisaniyede ekrana bas. Arka planda sunucudan taze veriyi çek; gelince ekranı ve diski sessizce güncelle.

### 8.2. `Defensive Proframming` (Savunmacı Programlama)

- **Mantık** Sunucdan gelen veriye asla %100 güvenmeme prensibi.
