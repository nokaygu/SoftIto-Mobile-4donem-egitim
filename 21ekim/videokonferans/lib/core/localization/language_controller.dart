import 'package:flutter/foundation.dart';
import 'app_strings.dart';

/// TR ve EN dilleri arasında geçişi yöneten reaktif kontrolcü
class LanguageController {
  final ValueNotifier<String> currentLanguage = ValueNotifier<String>('tr');

  String get languageCode => currentLanguage.value;
  bool get isTurkish => currentLanguage.value == 'tr';

  void setLanguage(String code) {
    if (code == 'tr' || code == 'en') {
      currentLanguage.value = code;
    }
  }

  void toggleLanguage() {
    currentLanguage.value = currentLanguage.value == 'tr' ? 'en' : 'tr';
  }

  /// Aktif dildeki metni döner
  String text(String key) {
    return AppStrings.get(key, lang: currentLanguage.value);
  }
}
