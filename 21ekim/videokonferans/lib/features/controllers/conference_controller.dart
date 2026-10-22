import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/agora_config.dart';
import '../../core/permissions/permission_service.dart';
import '../models/chat_message_model.dart';

/// Agora v6.x Video Konferans, Gerçek Zamanlı DataStream ve Oda İçi İletişim Kontrolcüsü
class ConferenceController {
  RtcEngine? _engine;
  VideoViewController? localVideoController;
  int? _dataStreamId;

  final ValueNotifier<bool> isJoined = ValueNotifier<bool>(false);
  final ValueNotifier<String> currentChannel = ValueNotifier<String>('');
  final ValueNotifier<bool> isMicMuted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCameraOff = ValueNotifier<bool>(false);
  final ValueNotifier<List<int>> remoteUids = ValueNotifier<List<int>>([]);
  final ValueNotifier<List<ChatMessageModel>> roomMessages = ValueNotifier<List<ChatMessageModel>>([]);
  final ValueNotifier<double> micVolume = ValueNotifier<double>(100.0);
  final ValueNotifier<bool> isFrontCamera = ValueNotifier<bool>(true);

  /// Uzak kullanıcıların DataStream üzerinden paylaştığı profil bilgileri (uid -> {username, displayName, avatarId})
  final ValueNotifier<Map<int, Map<String, dynamic>>> remoteUserProfiles =
      ValueNotifier<Map<int, Map<String, dynamic>>>({});

  /// Bağlantı durumu ve ağ kalitesi bildirimleri
  final ValueNotifier<String?> connectionStatusMessage = ValueNotifier<String?>(null);
  final ValueNotifier<String?> lastError = ValueNotifier<String?>(null);

  void Function(String channelName, String displayName, int avatarId)? onRoomJoined;
  void Function(String channelName)? onRoomLeft;

  RtcEngine? get engine => _engine;

  String _localUsername = '';
  String _localDisplayName = '';
  int _localAvatarId = 0;

  /// Kanala katılır
  Future<bool> joinChannel({
    required String channelName,
    required String username,
    required String displayName,
    required int avatarId,
  }) async {
    final cleanChannel = channelName.trim();
    if (cleanChannel.isEmpty) {
      lastError.value = 'Kanal adı boş olamaz.';
      return false;
    }

    // Agora Token belirli bir kanal ('deneme') için üretilir.
    // Farklı bir kanal adıyla girilirse Agora sunucusu ERR_INVALID_TOKEN hatası verir.
    // Token varsa daima token'ın üretildiği kanalı ('deneme') kullanarak güvenli bağlanıyoruz.
    final actualChannel = (AgoraConfig.token.isNotEmpty && cleanChannel != AgoraConfig.defaultChannel)
        ? AgoraConfig.defaultChannel
        : cleanChannel;

    _localUsername = username;
    _localDisplayName = displayName;
    _localAvatarId = avatarId;
    lastError.value = null;

    // Kamera ve mikrofon izinlerini kontrol et
    await PermissionService.ensureCameraAndMicPermissions();

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(
        const RtcEngineContext(
          appId: AgoraConfig.appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
            isJoined.value = true;
            currentChannel.value = actualChannel;
            connectionStatusMessage.value = null;
            lastError.value = null;

            // Gerçek zamanlı sohbet ve profil senkronizasyonu için DataStream aç
            try {
              _dataStreamId = await _engine?.createDataStream(
                const DataStreamConfig(syncWithAudio: false, ordered: true),
              );
              _broadcastLocalProfile();
            } catch (e) {
              debugPrint('Agora createDataStream hatası: $e');
            }
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            if (!remoteUids.value.contains(remoteUid)) {
              remoteUids.value = <int>[...remoteUids.value, remoteUid];
            }
            // Yeni gelen kullanıcıya kendi profilimizi tekrar gönder
            _broadcastLocalProfile();
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            remoteUids.value = remoteUids.value.where((int id) => id != remoteUid).toList();
            final updated = Map<int, Map<String, dynamic>>.from(remoteUserProfiles.value);
            updated.remove(remoteUid);
            remoteUserProfiles.value = updated;
          },
          onConnectionStateChanged: (
            RtcConnection connection,
            ConnectionStateType state,
            ConnectionChangedReasonType reason,
          ) {
            debugPrint('Agora connectionState: $state, reason: $reason');
            if (state == ConnectionStateType.connectionStateConnecting) {
              connectionStatusMessage.value = 'Sunucuya bağlanıyor...';
            } else if (state == ConnectionStateType.connectionStateConnected) {
              connectionStatusMessage.value = null;
            } else if (state == ConnectionStateType.connectionStateReconnecting) {
              connectionStatusMessage.value = 'Yeniden bağlanıyor...';
            } else if (state == ConnectionStateType.connectionStateFailed) {
              connectionStatusMessage.value = 'Bağlantı koptu ($reason)';
              lastError.value = 'Agora sunucusuna bağlanılamadı. ($reason)';
            }
          },
          onStreamMessage: (
            RtcConnection connection,
            int remoteUid,
            int streamId,
            Uint8List data,
            int length,
            int sentTs,
          ) {
            _handleReceivedStreamMessage(remoteUid, data);
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('Agora Error: $err - $msg');
            if (err == ErrorCodeType.errTokenExpired) {
              lastError.value = 'Agora Token süresi doldu! Yeni bir temp token giriniz.';
            } else if (err == ErrorCodeType.errInvalidToken) {
              lastError.value = 'Geçersiz Token veya Kanal Adı uyuşmazlığı!';
            } else {
              lastError.value = 'Agora Hatası ($err): $msg';
            }
          },
        ),
      );

      await _engine!.enableAudio();
      await _engine!.enableVideo();
      await _engine!.startPreview();

      // Yerel kullanıcı için VideoViewController'ı başlat
      localVideoController = VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden,
        ),
      );

      await _engine!.joinChannel(
        token: AgoraConfig.token,
        channelId: actualChannel,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );

      isJoined.value = true;
      currentChannel.value = actualChannel;
    } catch (e) {
      debugPrint('Agora joinChannel hatası: $e');
      lastError.value = 'Bağlantı başlatılamadı: $e';
      isJoined.value = false;
      return false;
    }

    onRoomJoined?.call(actualChannel, displayName, avatarId);

    // Odaya başlangıç bilgilendirme mesajını ekle
    roomMessages.value = <ChatMessageModel>[
      ChatMessageModel(
        id: 'sys-${DateTime.now().millisecondsSinceEpoch}',
        senderUsername: 'system',
        senderDisplayName: 'Sistem',
        senderAvatarId: 4,
        message: '$actualChannel odasına bağlandınız.',
        timestamp: DateTime.now(),
        isSystem: true,
      ),
    ];

    return true;
  }

  /// Profil bilgisini kanaldaki diğer katılımcılara canlı DataStream ile yayınlar
  void _broadcastLocalProfile() {
    if (_engine == null || _dataStreamId == null) return;
    try {
      final payload = jsonEncode({
        'type': 'profile',
        'username': _localUsername,
        'displayName': _localDisplayName,
        'avatarId': _localAvatarId,
      });
      final bytes = Uint8List.fromList(utf8.encode(payload));
      _engine!.sendStreamMessage(
        streamId: _dataStreamId!,
        data: bytes,
        length: bytes.length,
      );
    } catch (e) {
      debugPrint('Agora _broadcastLocalProfile hatası: $e');
    }
  }

  /// Karşı taraftan gelen DataStream mesajlarını (sohbet ve profil) işler
  void _handleReceivedStreamMessage(int remoteUid, Uint8List data) {
    try {
      final text = utf8.decode(data);
      final map = jsonDecode(text) as Map<String, dynamic>;
      final type = map['type'] as String?;

      if (type == 'profile') {
        final updated = Map<int, Map<String, dynamic>>.from(remoteUserProfiles.value);
        updated[remoteUid] = {
          'username': map['username'] ?? '',
          'displayName': map['displayName'] ?? 'Katılımcı',
          'avatarId': (map['avatarId'] as num?)?.toInt() ?? 0,
        };
        remoteUserProfiles.value = updated;
      } else if (type == 'chat') {
        final chatMsg = ChatMessageModel(
          id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          senderUsername: map['senderUsername']?.toString() ?? 'katilimci',
          senderDisplayName: map['senderDisplayName']?.toString() ?? 'Katılımcı',
          senderAvatarId: (map['senderAvatarId'] as num?)?.toInt() ?? 0,
          message: map['message']?.toString() ?? '',
          timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
          isSystem: false,
        );
        roomMessages.value = <ChatMessageModel>[...roomMessages.value, chatMsg];
      }
    } catch (e) {
      debugPrint('Agora _handleReceivedStreamMessage parse hatası: $e');
    }
  }

  /// Mikrofonu açıp kapatır
  Future<void> toggleMic() async {
    isMicMuted.value = !isMicMuted.value;
    try {
      await _engine?.muteLocalAudioStream(isMicMuted.value);
    } catch (e) {
      debugPrint('Agora muteLocalAudioStream hatası: $e');
    }
  }

  /// Kamerayı açıp kapatır
  Future<void> toggleCamera() async {
    isCameraOff.value = !isCameraOff.value;
    try {
      await _engine?.muteLocalVideoStream(isCameraOff.value);
      if (isCameraOff.value) {
        await _engine?.stopPreview();
      } else {
        await _engine?.startPreview();
      }
    } catch (e) {
      debugPrint('Agora toggleCamera hatası: $e');
    }
  }

  /// Ön/arka kamera değiştirir (Masaüstü için korumalı)
  Future<void> switchCamera() async {
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      debugPrint('Masaüstünde ön/arka kamera değişimi desteklenmez.');
      return;
    }
    isFrontCamera.value = !isFrontCamera.value;
    try {
      await _engine?.switchCamera();
    } catch (e) {
      debugPrint('Agora switchCamera hatası: $e');
    }
  }

  /// Mikrofon kayıt ses seviyesini ayarlar (0 - 200)
  Future<void> setMicVolume(double volume) async {
    micVolume.value = volume;
    try {
      await _engine?.adjustRecordingSignalVolume(volume.toInt());
    } catch (e) {
      debugPrint('Agora adjustRecordingSignalVolume hatası: $e');
    }
  }

  /// Oda içi sohbet mesajı gönderir (Hem yerel listeye hem de Agora DataStream ile karşı tarafa iletir)
  void sendMessage({
    required String senderUsername,
    required String senderDisplayName,
    required int senderAvatarId,
    required String text,
  }) {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final now = DateTime.now();
    final msgId = now.millisecondsSinceEpoch.toString();

    final newMessage = ChatMessageModel(
      id: msgId,
      senderUsername: senderUsername,
      senderDisplayName: senderDisplayName,
      senderAvatarId: senderAvatarId,
      message: clean,
      timestamp: now,
    );

    // Yerel listeye ekle
    roomMessages.value = <ChatMessageModel>[...roomMessages.value, newMessage];

    // Agora DataStream ile odadaki diğer katılımcılara canlı ilet
    if (_engine != null && _dataStreamId != null) {
      try {
        final payload = jsonEncode({
          'type': 'chat',
          'id': msgId,
          'senderUsername': senderUsername,
          'senderDisplayName': senderDisplayName,
          'senderAvatarId': senderAvatarId,
          'message': clean,
          'timestamp': now.toIso8601String(),
        });
        final bytes = Uint8List.fromList(utf8.encode(payload));
        _engine!.sendStreamMessage(
          streamId: _dataStreamId!,
          data: bytes,
          length: bytes.length,
        );
      } catch (e) {
        debugPrint('Agora sendMessage stream hatası: $e');
      }
    }
  }

  /// Görüşmeden ayrılır
  Future<void> leaveChannel() async {
    try {
      await localVideoController?.dispose();
      localVideoController = null;
      _dataStreamId = null;
      await _engine?.leaveChannel();
      await _engine?.release();
    } catch (e) {
      debugPrint('Agora leaveChannel hatası: $e');
    }
    final prevChannel = currentChannel.value;
    if (prevChannel.isNotEmpty) {
      onRoomLeft?.call(prevChannel);
    }
    _engine = null;
    isJoined.value = false;
    currentChannel.value = '';
    remoteUids.value = <int>[];
    remoteUserProfiles.value = <int, Map<String, dynamic>>{};
    connectionStatusMessage.value = null;
    lastError.value = null;
    isMicMuted.value = false;
    isCameraOff.value = false;
  }
}
