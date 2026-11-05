import 'package:flutter/material.dart';

import '../models/bildirim_modeli.dart';

class BildirimListesiKarti extends StatelessWidget {
  //bildirimler listeni kaybetmemeye dikkat stmeli
  final List<BildirimModeli> bildirimler;
  final String? token;
  final bool konuyaAbonemi;
  //dwger değişirse tetikleme
  final ValueChanged<bool> onAboneDegisti;

  const BildirimListesiKarti({
    super.key,
    required this.bildirimler,
    required this.token,
    required this.konuyaAbonemi,
    required this.onAboneDegisti,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      //yumuşak kenarlı dikdörtgen sınır

      shape: RoundedRectangleBorder(
        borderRadius:
            //16lık kenarlardan ovallaştirme
            BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        //her kenardan 16 içeriden boşluk
        padding: const EdgeInsets.all(16),
        child: Column(
          //column cross axisi yatay hizadır
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //satır
            Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF006C4A),
                ),
                const SizedBox(width: 8),
                //const ile performans expanded ile görselsorunengelleme
                const Expanded(
                  child: Text(
                    'FCM Bildirim Merkezi',
                    //kalın yazı tipi
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF172A),
                    ),
                  ),
                ),
                //bu dart switxhi ddğil abonedeğişince tetiklenir
                Switch(
                  value: konuyaAbonemi,
                  onChanged: onAboneDegisti,
                  activeColor: const Color.fromARGB(15, 160, 40, 50),
                ),
              ],
            ),
            Text(
              konuyaAbonemi ? 'tüm sınıf yayını aktif' : 'Yayın kapalı',
              style: TextStyle(
                fontSize: 12,
                color: konuyaAbonemi
                    ? const Color.fromARGB(15, 24, 59, 17)
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "cihazın fcm tokeni",
                    style: TextStyle(
                      color: Color.fromARGB(255, 26, 40, 52),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  //seçilebilir yazı
                  SelectableText(
                    token ?? 'token alınıyor',
                    style: const TextStyle(
                      color: Color(0xFF388888),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Gelen Bildirimler (${bildirimler.length})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(0, 5, 249, 253),
              ),
            ),
            //eğer bildirimler bışsa henüz gelen bilfitiö yok değils listwievde göster
            const SizedBox(height: 8),
            bildirimler.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      'Henüz gelen bildirim yok',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bildirimler.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final b = bildirimler[index];
                      return ListTile(
                        //önceden geelcek paddig varsa içe onu yok et
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(0, 123, 238, 230),
                          child: Icon(
                            Icons.mark_email_unread_outlined,
                            color: Color.fromARGB(0, 28, 176, 127),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          b.baslik,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(b.icerik),
                        trailing: Text(
                          '${b.tarih.hour.toString().padLeft(2, '0')}:${b.tarih.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
