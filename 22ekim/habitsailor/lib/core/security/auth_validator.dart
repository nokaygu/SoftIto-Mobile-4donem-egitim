class AuthValidator {
  AuthValidator._();

  /// Validates username format and length.
  /// Returns null if valid, or a Turkish user-friendly error message if invalid.
  static String? validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Kullanıcı adı boş bırakılamaz.';
    }

    final trimmed = username.trim();
    if (trimmed.length < 3) {
      return 'Kullanıcı adı en az 3 karakter olmalıdır.';
    }
    if (trimmed.length > 25) {
      return 'Kullanıcı adı en fazla 25 karakter olabilir.';
    }

    final validPattern = RegExp(r'^[a-zA-Z0-9_ çğıöşüÇĞİÖŞÜ.-]+$');
    if (!validPattern.hasMatch(trimmed)) {
      return 'Kullanıcı adı sadece harf, rakam, alt çizgi ve nokta içerebilir.';
    }

    return null;
  }

  /// Validates password format and length.
  /// Returns null if valid, or a Turkish user-friendly error message if invalid.
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Şifre boş bırakılamaz.';
    }
    if (password.length < 4) {
      return 'Şifre en az 4 karakter olmalıdır.';
    }
    if (password.length > 50) {
      return 'Şifre en fazla 50 karakter olabilir.';
    }
    return null;
  }
}
