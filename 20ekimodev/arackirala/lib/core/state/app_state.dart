import '../theme/theme_controller.dart';
import 'user_profile_controller.dart';
import '../../features/controllers/arac_controller.dart';
import '../../features/controllers/kiraci_controller.dart';
import '../../features/controllers/mesaj_controller.dart';

/// Tüm uygulama controller'larına erişim sağlayan merkezi durum yöneticisi.
class AppState {
  AppState._();

  static final ThemeController theme = ThemeController();
  static final UserProfileController userProfile = UserProfileController();
  static final AracController arac = AracController();
  static final KiraciController kiraci = KiraciController();
  static final MesajController mesaj = MesajController();
}
