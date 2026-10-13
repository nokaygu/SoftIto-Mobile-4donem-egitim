1.createState()

2.  mounted==TapRegionUpCallback

3. initState()  

4 didChangeDependencies() (widget değişimlerinde tetiklenir)
Thema.of (context) bu adımda güvenli olarak çalıştırılırş

5. build(BuildContext context)(UI burda döndürür 
(asla içinde asenkron işlem yapılmaz))

6.didUpdateWidget(oldwiget) (üst ebeveyn yeni bir parametre yolladığında 
çalışır)

7.deactivate() (ağaçtan geçici olarak kopma)

8.dispose() (kalıcı olarak kapatma(controller.dispose
Stream.cancel burda yapılır))

9 mounted  == false