Görev 1
 <img width="906" height="662" alt="image" src="https://github.com/user-attachments/assets/68afd6d5-7294-432c-905f-15df5bc5bd98" />

Adım 1: Başla
Adım 2: Uygulamayı aç ve oturumDurumu değerini kontrol et
Adım 3: EĞER oturumDurumu == "Giriş Yapılmamış" İSE:
        Giriş ekranına yönlendir ve bilgileri doğrula
        GİT ADIM 2
Adım 4: Ana ekrana git
Adım 5: Ürünleri seç, sepete ekle ve siparişi onayla (sepetTutari hesapla)
Adım 6: EĞER cuzdanBakiyesi < sepetTutari İSE:
        Ekrana "Bakiye yükle uyarısı!" yaz
        GİT ADIM 5
Adım 7: Siparişi arka planda sunucuya gönder
Adım 8: cuzdanBakiyesi = cuzdanBakiyesi - sepetTutari
Adım 9: Ekrana "Başarılı" yazdır
Adım 10: Bitir
Görev 2
Sipariş Oluşturma Endpoint'i:
HTTP Metodu: POST
URL / Endpoint: /api/v1/siparisler
Header: Authorization: Bearer <token> , Content-Type: application/json
Örnek Request Body (JSON):
{"siparis_listesi": [
{"kahve_adi": "Latte",
"boyutu": "Büyük",
"adedi": 2}],
"toplam_tutar": 180.00}
Başarılı Sonuç HTTP Durum Kodu: 201 Created
Kullanıcı Giriş Yapmamışsa Dönecek HTTP Durum Kodu: 401 Unauthorized
Cüzdan Bakiye Sorgulama Endpoint'i:
HTTP Metodu: GET
URL / Endpoint: /api/v1/kullanici/bakiye
Örnek Response (JSON):
{"bakiye": 185.50,
"para_birimi": "TRY"}
Sunucuda Beklenmeyen Hata Çıkarsa Dönecek Durum Kodu: 500 Internal Server Error
POST idempotent değildir. Çünkü idempotent olması için bu api çağrı sonucunda veritabanında her zaman aynı sonuç olması veya veritabanında farklı bir değişiklik olmaması gerekir.


Görev 3
1.soru
Birbiriyle alakasız sorumluluklara sahip fonksiyonlar tek bir sınıf içinde birleştirilmiş.Çözüm olarak alakasız fonksiyonlar kendi sınıflarına ayrılmalı.
2.soru
Open closed principle. Hem önceki ödevde hem de dersteki örnekte aynı şekilde değiştirmeye mecbur etmeyecek şekilde kod yazılmalı diyerek benzer örnek verildi.

