import 'auth_validator.dart';

/// Backward-compatible facade for validation, removing external crypto dependency.
class PasswordSecurity {
  PasswordSecurity._();

  static String? validateUsername(String? username) =>
      AuthValidator.validateUsername(username);

  static String? validatePassword(String? password) =>
      AuthValidator.validatePassword(password);
}
