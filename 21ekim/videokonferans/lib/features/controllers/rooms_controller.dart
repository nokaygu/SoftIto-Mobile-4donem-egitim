import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/meeting_room_model.dart';

/// Aktif toplantılar, son odalar ve oda keşfi kontrolcüsü
class RoomsController {
  final ValueNotifier<List<MeetingRoomModel>> activeRooms =
      ValueNotifier<List<MeetingRoomModel>>([
    MeetingRoomModel(
      id: 'room-demo',
      channelName: 'vizyon_demo',
      title: 'Vizyon Açık Demo Odası',
      description: 'Herkese açık genel sesli ve görüntülü test odası. Ali ve Veli burada buluşabilir.',
      hostUsername: 'ali',
      hostDisplayName: 'Ali Yılmaz',
      hostAvatarId: 0,
      participantCount: 2,
      participantAvatars: const <int>[0, 1],
      category: 'Demo',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    MeetingRoomModel(
      id: 'room-tech',
      channelName: 'yazilim_ekibi',
      title: 'Mobil & Agora v6.x Mimari Sync',
      description: 'Flutter state management, sıfır sıkışma mimarisi ve Agora RTC canlı testleri.',
      hostUsername: 'mehmet',
      hostDisplayName: 'Mehmet Can',
      hostAvatarId: 3,
      participantCount: 3,
      participantAvatars: const <int>[3, 2, 4],
      category: 'Yazılım',
      createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
    ),
    MeetingRoomModel(
      id: 'room-design',
      channelName: 'tasarim_inceleme',
      title: 'UI/UX & Dinamik Tema İncelemesi',
      description: 'Solarized Light, Dark, Cyberpunk temaları ve duyarlı layout kontrolleri.',
      hostUsername: 'ayse',
      hostDisplayName: 'Ayşe Demir',
      hostAvatarId: 2,
      participantCount: 2,
      participantAvatars: const <int>[2, 0],
      category: 'Tasarım',
      createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    MeetingRoomModel(
      id: 'room-project',
      channelName: 'proje_toplantisi',
      title: 'Haftalık Proje Değerlendirmesi',
      description: 'Sprint hedefleri, görev paylaşımları ve teslim tarihleri görüşülüyor.',
      hostUsername: 'zeynep',
      hostDisplayName: 'Zeynep Yıldız',
      hostAvatarId: 4,
      participantCount: 1,
      participantAvatars: const <int>[4],
      category: 'Planlama',
      createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
  ]);

  final ValueNotifier<List<String>> recentRooms =
      ValueNotifier<List<String>>(<String>['vizyon_demo', 'yazilim_ekibi']);

  /// Kullanıcı bir odaya katıldığında odayı aktif listeye ekler veya günceller
  void recordRoomJoin({
    required String channelName,
    required String displayName,
    required int avatarId,
  }) {
    final clean = channelName.trim();
    if (clean.isEmpty) return;

    // Son odalar listesini güncelle (en başa al, tekrarları önle)
    final updatedRecents = List<String>.from(recentRooms.value)
      ..removeWhere((String r) => r.toLowerCase() == clean.toLowerCase());
    updatedRecents.insert(0, clean);
    if (updatedRecents.length > 5) {
      updatedRecents.removeRange(5, updatedRecents.length);
    }
    recentRooms.value = updatedRecents;

    // Aktif odalarda var mı kontrol et
    final currentRooms = List<MeetingRoomModel>.from(activeRooms.value);
    final existingIndex = currentRooms.indexWhere(
      (MeetingRoomModel r) => r.channelName.toLowerCase() == clean.toLowerCase(),
    );

    if (existingIndex >= 0) {
      final existing = currentRooms[existingIndex];
      final avatars = List<int>.from(existing.participantAvatars);
      if (!avatars.contains(avatarId)) {
        avatars.add(avatarId);
      }
      currentRooms[existingIndex] = existing.copyWith(
        participantCount: existing.participantCount + 1,
        participantAvatars: avatars,
      );
    } else {
      // Yeni oda oluşturup listenin en başına ekle
      final newRoom = MeetingRoomModel(
        id: 'room_${DateTime.now().millisecondsSinceEpoch}',
        channelName: clean,
        title: '$clean Odası',
        description: '$displayName tarafından başlatılan canlı toplantı.',
        hostUsername: displayName.toLowerCase().replaceAll(' ', '_'),
        hostDisplayName: displayName,
        hostAvatarId: avatarId,
        participantCount: 1,
        participantAvatars: <int>[avatarId],
        category: 'Canlı',
        createdAt: DateTime.now(),
      );
      currentRooms.insert(0, newRoom);
    }

    activeRooms.value = currentRooms;
  }

  /// Kullanıcı odadan ayrıldığında katılımcı sayısını günceller
  void recordRoomLeave(String channelName) {
    final clean = channelName.trim();
    if (clean.isEmpty) return;

    final currentRooms = List<MeetingRoomModel>.from(activeRooms.value);
    final existingIndex = currentRooms.indexWhere(
      (MeetingRoomModel r) => r.channelName.toLowerCase() == clean.toLowerCase(),
    );

    if (existingIndex >= 0) {
      final existing = currentRooms[existingIndex];
      final newCount = max(0, existing.participantCount - 1);
      currentRooms[existingIndex] = existing.copyWith(participantCount: newCount);
      activeRooms.value = currentRooms;
    }
  }

  /// Kolay ve benzersiz rastgele bir oda kodu üretir (örn: meet-384)
  String generateRandomRoomCode() {
    final random = Random();
    final num = 100 + random.nextInt(900);
    return 'meet-$num';
  }
}
