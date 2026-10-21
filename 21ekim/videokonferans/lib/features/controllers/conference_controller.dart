import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/agora_config.dart';
import '../../core/permissions/permission_service.dart';
import '../models/chat_message_model.dart';

/// Agora v6.x Video Konferans ve Oda İçi İletişim Kontrolcüsü
class ConferenceController {
  RtcEngine? _engine;
  VideoViewController? localVideoController;

  final ValueNotifier<bool> isJoined = ValueNotifier<bool>(false);
  final ValueNotifier<String> currentChannel = ValueNotifier<String>('');
  final ValueNotifier<bool> isMicMuted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCameraOff = ValueNotifier<bool>(false);
  final ValueNotifier<List<int>> remoteUids = ValueNotifier<List<int>>([]);
  final ValueNotifier<List<ChatMessageModel>> roomMessages = ValueNotifier<List<ChatMessageModel>>([]);
  final ValueNotifier<double> micVolume = ValueNotifier<double>(100.0);
  final ValueNotifier<bool> isFrontCamera = ValueNotifier<bool>(true);

  void Function(String channelName, String displayName, int avatarId)? onRoomJoined;
  void Function(String channelName)? onRoomLeft;

  RtcEngine? get engine => _engine;

  /// Kanala katılır
  Future<bool> joinChannel({
    required String channelName,
    required String username,
    required String displayName,
    required int avatarId,
  }) async {
    final cleanChannel = channelName.trim();
    if (cleanChannel.isEmpty) return false;

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
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            isJoined.value = true;
            currentChannel.value = cleanChannel;
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            if (!remoteUids.value.contains(remoteUid)) {
              remoteUids.value = <int>[...remoteUids.value, remoteUid];
            }
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            remoteUids.value = remoteUids.value.where((int id) => id != remoteUid).toList();
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('Agora Error: $err - $msg');
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
        channelId: cleanChannel,
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
      currentChannel.value = cleanChannel;
    } catch (e) {
      debugPrint('Agora joinChannel hatası: $e');
      isJoined.value = true;
      currentChannel.value = cleanChannel;
    }

    onRoomJoined?.call(cleanChannel, displayName, avatarId);

    // Odaya karşılama ve örnek mesajları ekle
    roomMessages.value = <ChatMessageModel>[
      ChatMessageModel(
        id: 'sys-1',
        senderUsername: 'system',
        senderDisplayName: 'Sistem Botu',
        senderAvatarId: 4,
        message: '$channelName odasına hoş geldiniz!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isSystem: true,
      ),
      ChatMessageModel(
        id: 'msg-demo-1',
        senderUsername: username == 'ali' ? 'veli' : 'ali',
        senderDisplayName: username == 'ali' ? 'Veli Kaya' : 'Ali Yılmaz',
        senderAvatarId: username == 'ali' ? 1 : 0,
        message: 'Selam! Konferans odasına katıldım, sesim geliyor mu?',
        timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
      ),
    ];

    return true;
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

  /// Ön/arka kamera değiştirir
  Future<void> switchCamera() async {
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

  /// Oda içi sohbet mesajı gönderir
  void sendMessage({
    required String senderUsername,
    required String senderDisplayName,
    required int senderAvatarId,
    required String text,
  }) {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final newMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderUsername: senderUsername,
      senderDisplayName: senderDisplayName,
      senderAvatarId: senderAvatarId,
      message: clean,
      timestamp: DateTime.now(),
    );

    roomMessages.value = <ChatMessageModel>[...roomMessages.value, newMessage];
  }

  /// Görüşmeden ayrılır
  Future<void> leaveChannel() async {
    try {
      await localVideoController?.dispose();
      localVideoController = null;
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
    isMicMuted.value = false;
    isCameraOff.value = false;
  }
}
