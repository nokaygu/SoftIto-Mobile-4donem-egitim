import '../../features/controllers/auth_controller.dart';
import '../../features/controllers/conference_controller.dart';
import '../../features/controllers/friends_controller.dart';
import '../../features/controllers/rooms_controller.dart';
import '../../features/controllers/settings_controller.dart';
import '../localization/language_controller.dart';
import '../theme/theme_controller.dart';

/// Merkezi Singleton Controller Erişim Merkezi
class AppState {
  AppState._();

  static final AuthController auth = AuthController();
  static final ThemeController theme = ThemeController();
  static final LanguageController language = LanguageController();
  static final ConferenceController conference = ConferenceController();
  static final FriendsController friends = FriendsController();
  static final SettingsController settings = SettingsController();
  static final RoomsController rooms = RoomsController();

  /// Controller'lar arası reaktif etkileşimleri bağlar
  static void init() {
    conference.onRoomJoined = (String channel, String name, int avatar) {
      rooms.recordRoomJoin(channelName: channel, displayName: name, avatarId: avatar);
    };
    conference.onRoomLeft = (String channel) {
      rooms.recordRoomLeave(channel);
    };
  }
}
