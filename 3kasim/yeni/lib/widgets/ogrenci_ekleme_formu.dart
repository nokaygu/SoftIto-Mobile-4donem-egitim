import 'package:flutter/material.dart';
import 'package:yeni/services/fire_store_ogrenci_servisi.dart';

class OgrenciEklemeFormu extends StatefulWidget {
  final FireStoreOgrenciServisi servis;

  const OgrenciEklemeFormu({super.key, required this.servis});
//alt çizgi private yapar dışarıdan erişilemez 
//görsel güncelleme varsa stateful widget yaparız state tutma yaparız
  @override
  State<OgrenciEklemeFormu> createState() => _OgrenciEklemeFormuState();
}

class _OgrenciEklemeFormuState extends State<OgrenciEklemeFormu> {
//text editingcontroller ile yazı düzenleme kontrolü
  final TextEditingController _adSoyadKontrolcusu = TextEditingController();
  final TextEditingController _projeKontrolcusu = TextEditingController();
  final TextEditingController _notKontrolcusu = TextEditingController();

  @override
  void dispose() {
    _adSoyadKontrolcusu.dispose();
    _projeKontrolcusu.dispose();
    _notKontrolcusu.dispose();
    super.dispose();
  }
//trimle boşlukları siler
  void _yeniOgrenciKaydet() {
    final adSoyad = _adSoyadKontrolcusu.text.trim();
    final project = _projeKontrolcusu.text.trim();
    final not = int.tryParse(_notKontrolcusu.text.trim()) ?? 0;

    if (adSoyad.isEmpty || project.isEmpty) {
 //snackbar ekranın altında gözüken geçici bildirim     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ad soyad ve proje adını giriniz')),
      );
      return;
    }
//ogrenci eklendikten sonra temizleme yapıyoruz
    widget.servis.ogrenciEkle(adSoyad: adSoyad, projeAdi: project, notu: not);
    _adSoyadKontrolcusu.clear();
    _projeKontrolcusu.clear();
    _notKontrolcusu.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
//her kenardan içe padding yaptık sojra da içine colum koyduk bu columnun açısından dışına oldu
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextField(
            controller: _adSoyadKontrolcusu,
            decoration: const InputDecoration(
              labelText: "Öğrenci adı soyadı",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _projeKontrolcusu,
                  decoration: const InputDecoration(
                    labelText: "Proje adı",
                    prefixIcon: Icon(Icons.folder),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 110,
                child: TextField(
                  controller: _notKontrolcusu,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Not (0-100)",
                    prefixIcon: Icon(Icons.grade),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.brown,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: _yeniOgrenciKaydet,
            icon: const Icon(Icons.cloud_upload),
            label: const Text("buluta kaydet"),
          ),
        ],
      ),
    );
  }
}
