import 'package:flutter_test/flutter_test.dart';
import 'package:habitsailor/core/security/auth_validator.dart';
import 'package:habitsailor/core/security/password_security.dart';

void main() {
  group('AuthValidator & PasswordSecurity Tests', () {
    test('validateUsername enforces non-empty, length and allowed characters', () {
      expect(AuthValidator.validateUsername(null), isNotNull);
      expect(AuthValidator.validateUsername(''), isNotNull);
      expect(AuthValidator.validateUsername('   '), isNotNull);
      expect(AuthValidator.validateUsername('ab'), isNotNull); // too short (< 3)
      expect(AuthValidator.validateUsername('a' * 26), isNotNull); // too long (> 25)
      expect(AuthValidator.validateUsername('kaptan@123'), isNotNull); // invalid symbol '@'
      expect(AuthValidator.validateUsername('Kaptan Barbaros'), isNull); // valid with space
      expect(AuthValidator.validateUsername('kaptan_deniz.1'), isNull); // valid
      expect(AuthValidator.validateUsername('Ömer_Kaptan'), isNull); // valid Turkish chars
    });

    test('validatePassword enforces non-empty, minimum and maximum length', () {
      expect(AuthValidator.validatePassword(null), isNotNull);
      expect(AuthValidator.validatePassword(''), isNotNull);
      expect(AuthValidator.validatePassword('123'), isNotNull); // too short (< 4)
      expect(AuthValidator.validatePassword('a' * 51), isNotNull); // too long (> 50)
      expect(AuthValidator.validatePassword('1234'), isNull); // valid min length
      expect(AuthValidator.validatePassword('gucluSifre2026'), isNull); // valid
    });

    test('PasswordSecurity facade backward compatibility works identically', () {
      expect(PasswordSecurity.validateUsername('ab'), equals(AuthValidator.validateUsername('ab')));
      expect(PasswordSecurity.validateUsername('Kaptan Ali'), isNull);
      expect(PasswordSecurity.validatePassword('12'), equals(AuthValidator.validatePassword('12')));
      expect(PasswordSecurity.validatePassword('pass1234'), isNull);
    });
  });
}
