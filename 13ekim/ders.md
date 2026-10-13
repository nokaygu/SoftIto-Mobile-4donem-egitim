1. widget tree
*iskelet
*imuttable(değişmez)
*çok ucuz (hafif)
*saniyede 60*120 kez çöpe atılıp yeniden üretilir
*ekranda çizim yapmaz 
*sadece şablon sunar

2.element tree
*yönetici & yaşayan omurga
*mutable (durumu ve referansı hafızada canlı tutar değişir)
*widget ile renderobject arasındaki koordinatördür(organizasyonu sunar)

//canUpdate

static bool canUpdate(Widget oldWidget,Widget newWidget){
return oldWidget.runTimeType=newWidget.runtimeType && oldWidget.key==newWidget.key;
}

stat yaşam döngüsü

*StatefulWidget imumutable (olarak değişmez) her rebuildde yeniden oluşturuklur
*state mutable (durumu saklar) rebuild sırasında çöpe atılmaz element tarafında devam eder

Eğer iki sınıf birleşik olsaydı her rebuild esnasında kullanıcı girdiler yayaçlar controller vb sıfırlanırdı.

