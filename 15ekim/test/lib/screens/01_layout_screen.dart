import 'package:flutter/material.dart';

class LayoutStylingScreen extends StatefulWidget {
  const LayoutStylingScreen({super.key});

  @override
  State<LayoutStylingScreen> createState() => _LayoutStylingScreenState();
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> {
  bool _isBalanceVisible = true;
  String _lastAction = 'Hazır - Butonlara tıklayabilirsiniz';

  void _updateLastAction(String action) {
    setState(() {
      _lastAction = action;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          _buildWalletCard(),
          _buildQuickActions(),
          _buildFlexStatistics(),
          _buildNotificationBanner(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Son işlem: $_lastAction',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stack: profil simgesi ve üzerine yerleştirilen çevrim içi rozeti.
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x1F6366F1),
                  border: Border.all(
                    color: const Color(0xFF6366F1),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 32,
                  color: Color(0xFF6366F1),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF22C55E),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba, Berat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Cüzdanına hoş geldin',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Bildirimler',
            onPressed: () => _updateLastAction('Bildirimler butonuna tıklandı'),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Toplam bakiye',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              IconButton(
                tooltip:
                    _isBalanceVisible ? 'Bakiyeyi gizle' : 'Bakiyeyi göster',
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                    _lastAction = _isBalanceVisible
                        ? 'Bakiye gösterildi'
                        : 'Bakiye gizlendi';
                  });
                },
                icon: Icon(
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _isBalanceVisible ? '₺24.500,00' : '••••••',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Demo cüzdan • TRY',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(Icons.send_outlined, 'Gönder'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(Icons.add_circle_outline, 'Ekle'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(Icons.history, 'Geçmiş'),
          ),
        ],
      ),
    );
  }

  // Aynı tasarımdaki butonları tekrar yazmamak için yardımcı metot.
  Widget _buildActionButton(IconData icon, String label) {
    return OutlinedButton(
      onPressed: () => _updateLastAction('$label butonuna tıklandı'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6366F1),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildFlexStatistics() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bu ay',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildStatisticCard(
                  'Gelir',
                  '₺12.000',
                  Icons.south_west,
                  const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildStatisticCard(
                  'Gider',
                  '₺4.500',
                  Icons.north_east,
                  const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_active_outlined, color: Color(0xFFEA580C)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harcamalarını takip et',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                    'Bu ayki gelir ve giderlerini yukarıdan inceleyebilirsin.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
