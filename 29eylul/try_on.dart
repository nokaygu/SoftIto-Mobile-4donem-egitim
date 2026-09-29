class Cloud implements Exception {
  final String hataKodu;
  final String mesaj;
  final DateTime zaman = DateTime.now();

  Cloud(this.hataKodu, this.mesaj);

  @override
  String toString() => "[$hataKodu] $mesaj ($zaman)";
}

class CpuOverlord extends Cloud {
  final double mevcutCpu;
  final double limit;
  CpuOverlord({required this.mevcutCpu, required this.limit})
    : super(
        "Err_cpu_overload",
        "Cpu kullanımı eşik limitini($limit)aştı $mevcutCpu%",
      );
}

class NodeUnavailable extends Cloud {
  final String nodeId;
  NodeUnavailable(this.nodeId)
    : super("Err_node_ofline", "yanıt vermiyor: $nodeId");
}

void podKaynagiTahsisEt(
  String podAdi,
  double talepEdilenCpu,
  double sistemKalanCpu,
) {
  if (talepEdilenCpu <= 0) {
    throw Cloud(
      "Err_invalid_param",
      "Talep edilen cpu pozitif bir edğer olmalıdır",
    );
  }
  if (talepEdilenCpu > sistemKalanCpu) {
    throw CpuOverlord(
      mevcutCpu: 100 - sistemKalanCpu + talepEdilenCpu,
      limit: 100,
    );
  }
  print(
    "Pod [$podAdi] başarıyla tahsis edildi. Kalan boş cpu: ${sistemKalanCpu - talepEdilenCpu}%",
  );
}

void main() {
  print("yönetim paneli");
  //başarılı tahsis
  try {
    podKaynagiTahsisEt("ingress-controller", 15.0, 40.0);
  } catch (e) {
    print("Hata $e");
  }

  //cpu aşım hataası yaklama
  try {
    podKaynagiTahsisEt("ai-training-pd", 75.0, 20.0);
  } on CpuOverlord catch (e) {
    print("cpu hatası yakalandı");
    print("hata kodu ${e.hataKodu}");
    print("mesaj ${e.mesaj}");
    print("aksiyon otomatik aws açma isteiği göndeirldi");
  } on Cloud catch (e) {
    print("bulut hatası ${e.mesaj}");
  } catch (e, stackTrace) {
    print("bilinmedik sistem hatası $e");
  } finally {
    print("pod tahsis günlüğü kapatıldı");
  }
}
